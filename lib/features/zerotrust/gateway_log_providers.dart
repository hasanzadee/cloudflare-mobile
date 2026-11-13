import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/net/failure.dart';
import '../analytics/analytics_denials.dart';
import '../analytics/analytics_providers.dart' show graphqlProvider;
import 'gateway_log.dart';

class DnsLogState {
  const DnsLogState({
    this.entries = const [],
    this.loading = true,
    this.error,
    this.paused = false,
    this.decision,
    this.search = '',
    this.updatedAt,
  });

  final List<DnsLogEntry> entries;

  /// True until the first read for the current filter has answered.
  final bool loading;

  /// The last poll's failure. Rows already shown stay; a later poll that
  /// succeeds clears it.
  final Object? error;
  final bool paused;
  final DnsDecision? decision;
  final String search;
  final DateTime? updatedAt;

  /// The filter is left out on purpose: changing it starts a new log, which
  /// the controller does by building a fresh state.
  DnsLogState copyWith({
    List<DnsLogEntry>? entries,
    bool? loading,
    Object? error,
    bool clearError = false,
    bool? paused,
    DateTime? updatedAt,
  }) => DnsLogState(
    entries: entries ?? this.entries,
    loading: loading ?? this.loading,
    error: clearError ? null : (error ?? this.error),
    paused: paused ?? this.paused,
    decision: decision,
    search: search,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

/// Polls Gateway DNS queries for one account while the log screen is open.
///
/// Ten seconds between polls: rows reach the dataset about a minute late, so
/// polling faster only spends the GraphQL rate limit (300 queries per five
/// minutes, shared with every other analytics screen) without showing
/// anything sooner.
class DnsLogController extends AutoDisposeFamilyNotifier<DnsLogState, String> {
  static const Duration interval = Duration(seconds: 10);

  Timer? _timer;
  CancelToken? _inFlight;

  /// Bumped on every filter change, so an answer to an older filter that
  /// lands late is dropped instead of mixed into the new list.
  int _generation = 0;

  @override
  DnsLogState build(String accountId) {
    ref.onDispose(() {
      _timer?.cancel();
      _inFlight?.cancel();
    });
    Future.microtask(_restart);
    return const DnsLogState();
  }

  void setDecision(DnsDecision? decision) {
    if (decision == state.decision) return;
    state = DnsLogState(
      decision: decision,
      search: state.search,
      paused: state.paused,
    );
    _restart();
  }

  void setSearch(String search) {
    if (search.trim() == state.search.trim()) return;
    state = DnsLogState(
      decision: state.decision,
      search: search,
      paused: state.paused,
    );
    _restart();
  }

  /// Stops polling; rows on screen stay.
  void pause() {
    _timer?.cancel();
    _timer = null;
    state = state.copyWith(paused: true);
  }

  void resume() {
    state = state.copyWith(paused: false);
    _restart(keepRows: true);
  }

  /// For the app going to the background: stop without marking the log
  /// paused, so it picks up again on its own when the app comes back.
  void suspend() {
    _timer?.cancel();
    _timer = null;
  }

  void wake() {
    if (state.paused || _timer != null) return;
    _restart(keepRows: true);
  }

  Future<void> refresh() => _poll();

  void _restart({bool keepRows = false}) {
    _timer?.cancel();
    _timer = null;
    if (!keepRows) {
      _generation++;
      _inFlight?.cancel();
      _inFlight = null;
    }
    if (state.paused) return;
    unawaited(_poll());
    _timer = Timer.periodic(interval, (_) => _poll());
  }

  Future<void> _poll() async {
    if (_inFlight != null) return;
    final generation = _generation;
    final now = DateTime.now().toUtc();
    final newest = state.entries.isEmpty ? null : state.entries.first.at;
    final since = newest == null
        ? now.subtract(kDnsLogBacklog)
        : newest.subtract(kDnsLogOverlap);

    final token = _inFlight = CancelToken();
    try {
      final data = await ref
          .read(graphqlProvider)
          .query(
            gatewayDnsLogQuery,
            variables: {
              'accountTag': arg,
              'filter': dnsLogFilter(
                since: since,
                until: now,
                decision: state.decision,
                search: state.search,
              ),
            },
            cancelToken: token,
            missingPermissions: const {'Account Analytics Read'},
          );
      if (generation != _generation) return;
      state = state.copyWith(
        entries: mergeDnsLog(state.entries, parseDnsLog(data)),
        loading: false,
        clearError: true,
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      // A poll runs from a timer, so anything left uncaught here would go to
      // the zone handler rather than to the screen.
      if (e is NetworkFailure && e.kind == NetworkKind.cancelled) return;
      if (generation != _generation) return;
      final failure =
          e is CfFailure && e is! PermissionFailure && isAnalyticsDenied(e)
          ? PermissionFailure(
              missingPermissions: const {'Account Analytics Read'},
              errors: e.errors,
              httpStatus: e.httpStatus,
              requestPath: e.requestPath,
            )
          : e;
      state = state.copyWith(loading: false, error: failure);
      // Asking again every ten seconds will not grant a permission.
      if (failure is PermissionFailure) {
        _timer?.cancel();
        _timer = null;
      }
    } finally {
      if (identical(_inFlight, token)) _inFlight = null;
    }
  }
}

final dnsLogProvider = NotifierProvider.autoDispose
    .family<DnsLogController, DnsLogState, String>(DnsLogController.new);

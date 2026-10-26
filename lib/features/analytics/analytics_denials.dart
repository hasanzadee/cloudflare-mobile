/// Recognising "this token may not read analytics" in GraphQL answers.
///
/// The Analytics API does not say so with a 403. It answers 200 with an
/// `errors` array, which the GraphQL client reports as a [ValidationFailure],
/// and the wording varies by path:
///
/// - `zones [<id> <id> …] are not authorized` when a `zoneTag_in` filter
///   names any zone the token cannot see — and then the whole query fails, not
///   just those zones;
/// - `Actor '…' does not have permission '…analytics.read' for zone <id>`.
///
/// Shown raw, either one is a wall of hex on a phone. Recognised, it becomes
/// the same "missing Zone Analytics: Read" the rest of the app shows for a 403,
/// and Pulse can retry without the zones that were refused.
library;

import '../../core/net/failure.dart';

final RegExp _hexId = RegExp(r'\b[0-9a-f]{32}\b');

/// Zone ids the error names as refused, or null when [error] is not an
/// analytics denial at all. An empty set means "denied, but no zone named".
///
/// The set can include ids that are not zones (the token id in the "Actor"
/// form); callers only ever intersect it with the zones they asked for.
Set<String>? analyticsDeniedIds(Object error) {
  if (error is PermissionFailure) return const {};
  if (error is! ValidationFailure) return null;
  final text = [
    ...error.fields.map((f) => f.message),
    ...error.errors.map((e) => e.message),
  ].join(' ');
  final denied =
      text.contains('not authorized') ||
      text.contains('does not have permission');
  if (!denied) return null;
  return _hexId.allMatches(text).map((m) => m[0]!).toSet();
}

bool isAnalyticsDenied(Object error) => analyticsDeniedIds(error) != null;

/// Runs a multi-zone query, dropping zones the token may not read and asking
/// again for the rest.
///
/// One refused zone fails the whole `zoneTag_in` query, so without this a
/// single client zone on a shared token blanked Pulse for all ten zones in its
/// batch. Each retry removes at least one zone, so it ends; when the error
/// names no zone from the batch, the whole batch counts as refused.
Future<({List<Map<String, Object?>> results, Set<String> denied})>
queryDroppingDenied(
  List<String> zones,
  Future<Map<String, Object?>> Function(List<String> zones) run,
) async {
  var remaining = zones;
  final denied = <String>{};
  while (remaining.isNotEmpty) {
    try {
      return (results: [await run(remaining)], denied: denied);
    } on CfFailure catch (e) {
      final ids = analyticsDeniedIds(e);
      if (ids == null) rethrow;
      final refused = remaining.where(ids.contains).toSet();
      if (refused.isEmpty) {
        denied.addAll(remaining);
        break;
      }
      denied.addAll(refused);
      remaining = [
        for (final z in remaining)
          if (!refused.contains(z)) z,
      ];
    }
  }
  return (results: const <Map<String, Object?>>[], denied: denied);
}

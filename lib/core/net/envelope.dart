/// Parsing of Cloudflare's standard response envelope.
///
/// Every `client/v4` endpoint answers with the same wrapper:
/// `{success, result, errors, messages, result_info}`. The spec models this as
/// `allOf[api-response-common, {result: ...}]`, so the shape is stable even
/// though the payload is not.
///
/// Parsing here is deliberately lenient. The published spec disagrees with the
/// live API in small ways — `result_info.count` is typed as a number in some
/// schemas and arrives as a string from some endpoints — and a management
/// client must not fail to render a zone list because a counter changed type.
library;

int? _asInt(Object? v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v) ?? double.tryParse(v)?.toInt();
  return null;
}

String? _asString(Object? v) => v?.toString();

/// One entry of the `errors` or `messages` array.
class CfApiError {
  const CfApiError({
    required this.code,
    required this.message,
    this.documentationUrl,
    this.pointer,
    this.chain = const [],
  });

  final int code;
  final String message;
  final String? documentationUrl;

  /// JSON pointer into the request body, when the error is a field validation
  /// failure (`source.pointer`).
  final String? pointer;

  /// Nested detail Cloudflare returns as `error_chain`.
  final List<CfApiError> chain;

  static CfApiError fromJson(Object? raw) {
    if (raw is! Map) return CfApiError(code: 0, message: raw?.toString() ?? '');
    final source = raw['source'];
    return CfApiError(
      code: _asInt(raw['code']) ?? 0,
      message: _asString(raw['message']) ?? '',
      documentationUrl: _asString(raw['documentation_url']),
      pointer: source is Map ? _asString(source['pointer']) : null,
      chain: switch (raw['error_chain']) {
        final List<Object?> l => l.map(CfApiError.fromJson).toList(),
        _ => const <CfApiError>[],
      },
    );
  }

  static List<CfApiError> listFrom(Object? raw) => switch (raw) {
        final List<Object?> l => l.map(CfApiError.fromJson).toList(),
        _ => const <CfApiError>[],
      };

  /// Flattened view including nested chain entries, for matching error codes.
  Iterable<CfApiError> get flattened sync* {
    yield this;
    for (final c in chain) {
      yield* c.flattened;
    }
  }

  @override
  String toString() => code == 0 ? message : '[$code] $message';
}

/// Pagination metadata. Cloudflare uses page/per_page almost everywhere and
/// opaque cursors in a few places (Workers KV key listing, some Zero Trust
/// endpoints), so both are represented.
class CfResultInfo {
  const CfResultInfo({
    this.page,
    this.perPage,
    this.count,
    this.totalCount,
    this.totalPages,
    this.cursor,
  });

  final int? page;
  final int? perPage;

  /// Number of items in *this* response.
  final int? count;

  /// Number of items available across all pages.
  final int? totalCount;
  final int? totalPages;

  /// Opaque continuation token, when the endpoint is cursor-paginated.
  final String? cursor;

  static const CfResultInfo empty = CfResultInfo();

  static CfResultInfo? fromJson(Object? raw) {
    if (raw is! Map) return null;
    final cursors = raw['cursors'];
    return CfResultInfo(
      page: _asInt(raw['page']),
      perPage: _asInt(raw['per_page']),
      count: _asInt(raw['count']),
      totalCount: _asInt(raw['total_count']),
      totalPages: _asInt(raw['total_pages']),
      cursor: _asString(raw['cursor']) ??
          (cursors is Map ? _asString(cursors['after']) : null),
    );
  }

  /// Whether another page exists.
  ///
  /// Returns false when the endpoint reports no pagination at all, so callers
  /// stop rather than looping forever on a non-paginated response.
  bool get hasMore {
    if (cursor != null && cursor!.isNotEmpty) return true;
    final p = page;
    final tp = totalPages;
    if (p != null && tp != null) return p < tp;
    final c = count;
    final tc = totalCount;
    final pp = perPage;
    if (p != null && pp != null && tc != null) return p * pp < tc;
    if (c != null && tc != null) return c < tc;
    return false;
  }

  Map<String, Object?> toJson() => {
        if (page != null) 'page': page,
        if (perPage != null) 'per_page': perPage,
        if (count != null) 'count': count,
        if (totalCount != null) 'total_count': totalCount,
        if (totalPages != null) 'total_pages': totalPages,
        if (cursor != null) 'cursor': cursor,
      };
}

/// A parsed Cloudflare response.
class CfEnvelope {
  const CfEnvelope({
    required this.success,
    required this.result,
    required this.errors,
    required this.messages,
    this.resultInfo,
    this.httpStatus,
  });

  final bool success;
  final Object? result;
  final List<CfApiError> errors;
  final List<CfApiError> messages;
  final CfResultInfo? resultInfo;
  final int? httpStatus;

  /// Parses a decoded JSON body.
  ///
  /// Some endpoints answer with a bare payload rather than the envelope —
  /// `GET /zones/{id}/dns_records/export` returns a BIND zone file as text.
  /// Those are wrapped as a successful envelope carrying the raw body.
  factory CfEnvelope.fromBody(Object? body, {int? httpStatus}) {
    if (body is Map && body.containsKey('success')) {
      return CfEnvelope(
        success: body['success'] == true,
        result: body['result'],
        errors: CfApiError.listFrom(body['errors']),
        messages: CfApiError.listFrom(body['messages']),
        resultInfo: CfResultInfo.fromJson(body['result_info']),
        httpStatus: httpStatus,
      );
    }
    final ok = httpStatus == null || (httpStatus >= 200 && httpStatus < 300);
    return CfEnvelope(
      success: ok,
      result: body,
      errors: const [],
      messages: const [],
      httpStatus: httpStatus,
    );
  }

  /// All error codes, including nested `error_chain` entries.
  Set<int> get errorCodes =>
      errors.expand((e) => e.flattened).map((e) => e.code).toSet();

  List<Object?> get resultAsList => switch (result) {
        final List<Object?> l => l,
        null => const [],
        final Object o => [o],
      };

  Map<String, Object?> get resultAsMap => switch (result) {
        final Map<Object?, Object?> m =>
          m.map((k, v) => MapEntry(k.toString(), v)),
        _ => const {},
      };
}

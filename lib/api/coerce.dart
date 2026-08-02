/// Tolerant JSON coercions used by generated models.
///
/// Two facts drive the tolerance. First, the published spec and the live API
/// disagree in places — a field typed `number` can arrive as a string. Second,
/// this is a management client: rendering a zone list with one odd field is
/// always better than throwing and showing nothing. Generated fields are
/// therefore all nullable and every coercion returns null rather than raising.
library;

String? asString(Object? v) => v == null ? null : (v is String ? v : '$v');

int? asInt(Object? v) => switch (v) {
  final int i => i,
  final num n => n.toInt(),
  final String s => int.tryParse(s) ?? double.tryParse(s)?.toInt(),
  _ => null,
};

num? asNum(Object? v) => switch (v) {
  final num n => n,
  final String s => num.tryParse(s),
  _ => null,
};

double? asDouble(Object? v) => asNum(v)?.toDouble();

bool? asBool(Object? v) => switch (v) {
  final bool b => b,
  'true' || 'True' || '1' || 1 => true,
  'false' || 'False' || '0' || 0 => false,
  _ => null,
};

Map<String, Object?>? asMap(Object? v) =>
    v is Map ? v.map((k, value) => MapEntry(k.toString(), value)) : null;

/// Decodes a JSON array into models, skipping entries of the wrong shape
/// rather than failing the whole list.
List<T>? asModelList<T>(Object? v, T Function(Map<String, Object?>) parse) {
  if (v is! List) return null;
  final out = <T>[];
  for (final e in v) {
    final m = asMap(e);
    if (m != null) out.add(parse(m));
  }
  return out;
}

List<T>? asPrimitiveList<T>(Object? v, T? Function(Object?) coerce) {
  if (v is! List) return null;
  final out = <T>[];
  for (final e in v) {
    final c = coerce(e);
    if (c != null) out.add(c);
  }
  return out;
}

T? asModel<T>(Object? v, T Function(Map<String, Object?>) parse) {
  final m = asMap(v);
  return m == null ? null : parse(m);
}

/// Everything the schema did not describe.
///
/// Keeping unknown keys means an edit round-trip (GET, change one field, PUT)
/// cannot silently drop a property Cloudflare added after this spec snapshot.
Map<String, Object?> extraOf(Map<String, Object?> json, Set<String> known) {
  final out = <String, Object?>{};
  for (final entry in json.entries) {
    if (!known.contains(entry.key)) out[entry.key] = entry.value;
  }
  return out;
}

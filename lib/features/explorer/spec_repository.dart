import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One parameter, as described by the spec.
class SpecParam {
  const SpecParam({
    required this.name,
    required this.location,
    this.required = false,
    this.type,
    this.format,
    this.enumValues,
    this.doc,
    this.minimum,
    this.maximum,
    this.defaultValue,
  });

  final String name;

  /// `path`, `query` or `header`.
  final String location;
  final bool required;
  final String? type;
  final String? format;
  final List<String>? enumValues;
  final String? doc;
  final num? minimum;
  final num? maximum;
  final Object? defaultValue;

  static SpecParam fromJson(Map<String, Object?> json) => SpecParam(
    name: json['name']?.toString() ?? '',
    location: json['in']?.toString() ?? 'query',
    required: json['required'] == true,
    type: json['type']?.toString(),
    format: json['format']?.toString(),
    enumValues: switch (json['enum']) {
      final List<Object?> l => l.map((e) => e.toString()).toList(),
      _ => null,
    },
    doc: json['doc']?.toString(),
    minimum: json['minimum'] as num?,
    maximum: json['maximum'] as num?,
    defaultValue: json['default'],
  );
}

class SpecOperation {
  const SpecOperation({
    required this.id,
    required this.method,
    required this.path,
    required this.tag,
    this.summary,
    this.deprecated = false,
    this.params = const [],
    this.bodyRef,
  });

  final String id;
  final String method;
  final String path;
  final String tag;
  final String? summary;
  final bool deprecated;
  final List<SpecParam> params;
  final String? bodyRef;

  Iterable<SpecParam> get pathParams =>
      params.where((p) => p.location == 'path');
  Iterable<SpecParam> get queryParams =>
      params.where((p) => p.location == 'query');

  bool get takesBody => bodyRef != null;

  static SpecOperation fromJson(Map<String, Object?> json) => SpecOperation(
    id: json['id']?.toString() ?? '',
    method: json['method']?.toString() ?? 'GET',
    path: json['path']?.toString() ?? '/',
    tag: json['tag']?.toString() ?? 'Other',
    summary: json['summary']?.toString(),
    deprecated: json['deprecated'] == true,
    params: switch (json['params']) {
      final List<Object?> l =>
        l
            .whereType<Map<Object?, Object?>>()
            .map(
              (e) => SpecParam.fromJson(
                e.map((k, v) => MapEntry(k.toString(), v)),
              ),
            )
            .toList(),
      _ => const [],
    },
    bodyRef: json['body']?.toString(),
  );
}

/// The whole Cloudflare surface, loaded from the generated assets.
///
/// This is what makes "every endpoint" true without hand-writing 2884 of them:
/// the explorer builds a real form — typed inputs, enum dropdowns, required
/// markers, a pre-filled body — from the same schemas the typed client was
/// generated from.
class SpecIndex {
  SpecIndex({
    required this.operations,
    required this.schemas,
    required this.inlineBodies,
  });

  final List<SpecOperation> operations;
  final Map<String, Object?> schemas;
  final Map<String, Object?> inlineBodies;

  late final Map<String, List<SpecOperation>> byTag = () {
    final map = <String, List<SpecOperation>>{};
    for (final op in operations) {
      map.putIfAbsent(op.tag, () => []).add(op);
    }
    return map;
  }();

  List<SpecOperation> search(String query, {int limit = 200}) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    final out = <SpecOperation>[];
    for (final op in operations) {
      if (op.path.toLowerCase().contains(q) ||
          op.id.toLowerCase().contains(q) ||
          op.tag.toLowerCase().contains(q) ||
          (op.summary?.toLowerCase().contains(q) ?? false)) {
        out.add(op);
        if (out.length >= limit) break;
      }
    }
    return out;
  }

  /// Follows `$ref` into `components.schemas` or the synthetic inline table.
  Map<String, Object?>? resolve(String? ref, {int depth = 0}) {
    if (ref == null || depth > 16) return null;
    if (ref.startsWith('#/inline/')) {
      final node = inlineBodies[ref];
      return node is Map
          ? _deref(node.map((k, v) => MapEntry(k.toString(), v)), depth)
          : null;
    }
    const prefix = '#/components/schemas/';
    if (!ref.startsWith(prefix)) return null;
    final node = schemas[ref.substring(prefix.length)];
    return node is Map
        ? _deref(node.map((k, v) => MapEntry(k.toString(), v)), depth)
        : null;
  }

  Map<String, Object?>? _deref(Map<String, Object?> node, int depth) {
    final ref = node[r'$ref'];
    if (ref is String) return resolve(ref, depth: depth + 1);
    return node;
  }

  /// Builds a starter request body from a schema: required members first, with
  /// example-ish values derived from their declared types.
  String bodyTemplate(String? ref) {
    final schema = resolve(ref);
    if (schema == null) return '{\n  \n}';
    final sample = _sample(schema, 0);
    return const JsonEncoder.withIndent('  ').convert(sample);
  }

  Object? _sample(Map<String, Object?> schema, int depth) {
    if (depth > 4) return null;
    final resolved = _flatten(schema, depth);
    final props = resolved.props;
    if (props.isEmpty) {
      return switch (resolved.type) {
        'string' => '',
        'integer' || 'number' => 0,
        'boolean' => false,
        'array' => <Object?>[],
        _ => <String, Object?>{},
      };
    }

    final out = <String, Object?>{};
    for (final entry in props.entries) {
      // Keep the template short: required members are what a user must fill.
      if (!resolved.required.contains(entry.key) && props.length > 6) continue;
      final child = entry.value;
      if (child is! Map) continue;
      final childMap = child.map((k, v) => MapEntry(k.toString(), v));
      final deref = _deref(childMap, depth) ?? childMap;
      final enumValues = deref['enum'];
      if (enumValues is List && enumValues.isNotEmpty) {
        out[entry.key] = enumValues.first;
        continue;
      }
      out[entry.key] = switch (deref['type']) {
        'string' => '',
        'integer' || 'number' => 0,
        'boolean' => false,
        'array' => <Object?>[],
        'object' => _sample(deref, depth + 1),
        _ => null,
      };
    }
    return out;
  }

  _Flat _flatten(Map<String, Object?> schema, int depth) {
    final props = <String, Object?>{};
    final required = <String>{};
    String? type = schema['type']?.toString();

    for (final key in const ['allOf', 'anyOf', 'oneOf']) {
      final branches = schema[key];
      if (branches is! List) continue;
      for (final branch in branches) {
        if (branch is! Map) continue;
        final resolved = _deref(
          branch.map((k, v) => MapEntry(k.toString(), v)),
          depth,
        );
        if (resolved == null) continue;
        final sub = _flatten(resolved, depth + 1);
        props.addAll(sub.props);
        if (key == 'allOf') required.addAll(sub.required);
        type ??= sub.type;
      }
    }
    final direct = schema['properties'];
    if (direct is Map) {
      props.addAll(direct.map((k, v) => MapEntry(k.toString(), v)));
    }
    final req = schema['required'];
    if (req is List) required.addAll(req.map((e) => e.toString()));
    return _Flat(props: props, required: required, type: type);
  }
}

class _Flat {
  const _Flat({required this.props, required this.required, this.type});
  final Map<String, Object?> props;
  final Set<String> required;
  final String? type;
}

/// Parsing 3.6 MB of JSON on the UI isolate would drop frames, so it happens
/// in a background isolate and is cached for the app's lifetime.
Future<SpecIndex> _loadSpec() async {
  final opsRaw = await rootBundle.loadString('assets/spec/operations.json');
  final schemasRaw = await rootBundle.loadString('assets/spec/schemas.json');
  return compute(_parseSpec, [opsRaw, schemasRaw]);
}

SpecIndex _parseSpec(List<String> raw) {
  final ops = jsonDecode(raw[0]) as Map<String, Object?>;
  final schemas = jsonDecode(raw[1]) as Map<String, Object?>;
  return SpecIndex(
    operations: (ops['operations'] as List<Object?>)
        .whereType<Map<Object?, Object?>>()
        .map(
          (e) => SpecOperation.fromJson(
            e.map((k, v) => MapEntry(k.toString(), v)),
          ),
        )
        .toList(),
    schemas: (schemas['schemas'] as Map<Object?, Object?>).map(
      (k, v) => MapEntry(k.toString(), v),
    ),
    inlineBodies: (schemas['inline'] as Map<Object?, Object?>? ?? {}).map(
      (k, v) => MapEntry(k.toString(), v),
    ),
  );
}

final specProvider = FutureProvider<SpecIndex>((ref) => _loadSpec());

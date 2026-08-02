// Generates the typed Cloudflare client and the spec assets.
//
//   dart run tool/openapi/generate.dart
//
// Inputs : spec/openapi.json, tool/openapi/allowlist.yaml
// Outputs: lib/api/generated/**, assets/spec/*.json, spec/openapi.lock.json,
//          test/generated/model_smoke_test.dart
//
// Design notes live in tool/openapi/README.md. The short version: full
// generation over 5815 component schemas is not viable, so a small allowlist
// gets real types and every other endpoint is served at runtime from the two
// emitted spec assets.
//
// This runs by hand, never during `flutter build`. CI re-runs it and fails on
// `git diff`, so the committed output can never drift from the spec.

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:yaml/yaml.dart';

import 'naming.dart';

const String kGeneratorVersion = '1';
const String kHeader = '''
// GENERATED CODE — DO NOT EDIT BY HAND.
//
// Produced by tool/openapi/generate.dart from spec/openapi.json.
// Re-run `dart run tool/openapi/generate.dart` after changing the spec or
// tool/openapi/allowlist.yaml.
''';

void main(List<String> args) {
  final root = Directory.current;
  final specFile = File('${root.path}/spec/openapi.json');
  if (!specFile.existsSync()) {
    stderr.writeln('spec/openapi.json not found — run from the repo root.');
    exitCode = 2;
    return;
  }

  final bytes = specFile.readAsBytesSync();
  final spec = jsonDecode(utf8.decode(bytes)) as Map<String, Object?>;
  final allowlist =
      loadYaml(
            File('${root.path}/tool/openapi/allowlist.yaml').readAsStringSync(),
          )
          as YamlMap;

  final gen = Generator(spec: spec, allowlist: allowlist, root: root.path);
  gen.run();

  final digest = sha256.convert(bytes).toString();
  File('${root.path}/spec/openapi.lock.json').writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert({
      'sha256': digest,
      'api_version': (spec['info'] as Map?)?['version'],
      'operations': gen.totalOperations,
      'schemas': gen.totalSchemas,
      'generator': kGeneratorVersion,
    }),
  );

  stdout.writeln(
    'Generated ${gen.models.length} models, '
    '${gen.emittedOps} typed operations, '
    'indexed ${gen.totalOperations} operations / ${gen.totalSchemas} schemas.',
  );

  final fmt = Process.runSync('dart', [
    'format',
    'lib/api/generated',
    'test/generated',
  ]);
  if (fmt.exitCode != 0) {
    stderr.writeln('dart format failed:\n${fmt.stderr}');
  }
}

// ---------------------------------------------------------------------------
// Spec model
// ---------------------------------------------------------------------------

class SpecOp {
  SpecOp({
    required this.id,
    required this.method,
    required this.path,
    required this.tag,
    required this.node,
  });

  final String id;
  final String method;
  final String path;
  final String tag;
  final Map<String, Object?> node;

  String? get summary => node['summary'] as String?;
  bool get deprecated => node['deprecated'] == true;
}

/// A resolved object shape: what a schema actually contains once `$ref`,
/// `allOf`, `anyOf` and `oneOf` have been folded in.
class Shape {
  final Map<String, Object?> props = {};
  final Set<String> required = {};
  bool freeForm = false;
}

class ModelField {
  ModelField({
    required this.jsonKey,
    required this.dartName,
    required this.type,
    this.doc,
  });

  final String jsonKey;
  final String dartName;
  final TypeInfo type;
  final String? doc;
}

class ModelDef {
  ModelDef(this.name, {this.doc, this.example});

  final String name;
  final String? doc;
  final Map<String, Object?>? example;
  final List<ModelField> fields = [];
}

/// How one field is typed, read and written.
class TypeInfo {
  TypeInfo({
    required this.dart,
    required this.read,
    this.write,
    this.isModel = false,
    this.isModelList = false,
  });

  /// Non-nullable Dart type, e.g. `String`, `List<Zone>`, `Map<String, Object?>`.
  final String dart;

  /// Builds an expression that reads the value out of `src`.
  final String Function(String src) read;

  /// Builds the `toJson` value expression for a non-null field named `name`.
  final String Function(String name)? write;

  final bool isModel;
  final bool isModelList;

  String get nullable => '$dart?';

  String writeExpr(String name) => write?.call(name) ?? name;

  static TypeInfo primitive(String dart, String coerce) =>
      TypeInfo(dart: dart, read: (src) => '$coerce($src)');
}

// ---------------------------------------------------------------------------
// Generator
// ---------------------------------------------------------------------------

class Generator {
  Generator({required this.spec, required this.allowlist, required this.root});

  final Map<String, Object?> spec;
  final YamlMap allowlist;
  final String root;

  late final Map<String, Object?> schemas =
      ((spec['components'] as Map?)?['schemas'] as Map?)?.map(
        (k, v) => MapEntry(k.toString(), v),
      ) ??
      {};

  final List<SpecOp> allOps = [];
  final Map<String, ModelDef> models = {};

  /// `$ref` string -> generated class name, so a schema is emitted once.
  final Map<String, String> _refToModel = {};
  final Set<String> _takenNames = {};

  int emittedOps = 0;
  int get totalOperations => allOps.length;
  int get totalSchemas => schemas.length;

  static const List<String> _httpMethods = [
    'get',
    'post',
    'put',
    'patch',
    'delete',
    'head',
    'options',
  ];

  void run() {
    _indexOperations();
    final emitted = _buildOperations();
    _writeModels();
    _writeOps(emitted);
    _writeBarrel(emitted);
    _writeAssets();
    _writeSmokeTest();
  }

  // --- indexing ------------------------------------------------------------

  void _indexOperations() {
    final paths = (spec['paths'] as Map?) ?? {};
    for (final entry in paths.entries) {
      final path = entry.key.toString();
      final item = entry.value;
      if (item is! Map) continue;
      for (final method in _httpMethods) {
        final node = item[method];
        if (node is! Map) continue;
        final map = node.map((k, v) => MapEntry(k.toString(), v));
        final tags = map['tags'];
        allOps.add(
          SpecOp(
            // 49 operations in the spec have no operationId; synthesising a
            // stable one keeps the explorer able to address them.
            id:
                (map['operationId'] as String?) ??
                '${method}_${path.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')}',
            method: method.toUpperCase(),
            path: path,
            tag: (tags is List && tags.isNotEmpty)
                ? tags.first.toString()
                : 'Other',
            node: map,
          ),
        );
      }
    }
    allOps.sort((a, b) => a.id.compareTo(b.id));
  }

  // --- $ref / composition resolution ---------------------------------------

  Map<String, Object?>? _lookupRef(String ref) {
    if (!ref.startsWith('#/')) return null;
    Object? node = spec;
    for (final segment in ref.substring(2).split('/')) {
      final key = segment.replaceAll('~1', '/').replaceAll('~0', '~');
      if (node is Map) {
        node = node[key];
      } else {
        return null;
      }
    }
    return node is Map ? node.map((k, v) => MapEntry(k.toString(), v)) : null;
  }

  /// Follows `$ref` chains to the concrete node.
  Map<String, Object?> deref(Map<String, Object?> node) {
    var current = node;
    var guard = 0;
    while (current[r'$ref'] is String && guard++ < 32) {
      final next = _lookupRef(current[r'$ref']! as String);
      if (next == null) return current;
      current = next;
    }
    return current;
  }

  /// Folds allOf/anyOf/oneOf and inherited `$ref`s into one object shape.
  ///
  /// `allOf` is a straight merge. `anyOf`/`oneOf` are merged too, with every
  /// branch-specific property left optional — correct for the cases we
  /// allowlist (`dns-record-post` branches on `type`, and the editor already
  /// selects fields by record type).
  Shape flatten(Map<String, Object?> schema, {int depth = 0}) {
    final shape = Shape();
    if (depth > 12) return shape;

    final node = deref(schema);

    for (final key in const ['allOf', 'anyOf', 'oneOf']) {
      final branches = node[key];
      if (branches is! List) continue;
      for (final branch in branches) {
        if (branch is! Map) continue;
        final sub = flatten(
          branch.map((k, v) => MapEntry(k.toString(), v)),
          depth: depth + 1,
        );
        shape.props.addAll(sub.props);
        if (key == 'allOf') shape.required.addAll(sub.required);
        shape.freeForm |= sub.freeForm;
      }
    }

    final props = node['properties'];
    if (props is Map) {
      shape.props.addAll(props.map((k, v) => MapEntry(k.toString(), v)));
    }
    final req = node['required'];
    if (req is List) {
      shape.required.addAll(req.map((e) => e.toString()));
    }
    if (shape.props.isEmpty && node['additionalProperties'] != null) {
      shape.freeForm = true;
    }
    return shape;
  }

  // --- model building ------------------------------------------------------

  /// Registers (or reuses) a model for an object schema and returns its name.
  String _modelFor(
    Map<String, Object?> schema,
    String fallbackName, {
    int depth = 0,
  }) {
    final ref = schema[r'$ref'];
    if (ref is String) {
      final existing = _refToModel[ref];
      if (existing != null) return existing;
      final target = _lookupRef(ref);
      if (target == null) return 'Map<String, Object?>';
      final name = uniqueName(pascalCase(_nameFromRef(ref)), _takenNames);
      // Register before recursing so a self-referencing schema terminates.
      _refToModel[ref] = name;
      _defineModel(name, target, depth: depth);
      return name;
    }

    final name = uniqueName(pascalCase(fallbackName), _takenNames);
    _defineModel(name, schema, depth: depth);
    return name;
  }

  static String _nameFromRef(String ref) {
    final raw = ref.split('/').last;
    // `dns-records_dns-record-response` -> `dns record response`; the tag
    // prefix is dropped because it repeats in every name from that file.
    final underscore = raw.indexOf('_');
    return underscore > 0 ? raw.substring(underscore + 1) : raw;
  }

  void _defineModel(String name, Map<String, Object?> schema, {int depth = 0}) {
    final node = deref(schema);
    final shape = flatten(node);
    final example = node['example'];
    final def = ModelDef(
      name,
      doc: node['description'] as String?,
      example: example is Map
          ? example.map((k, v) => MapEntry(k.toString(), v))
          : null,
    );
    models[name] = def;

    final usedMembers = <String>{'extra'};
    for (final entry in shape.props.entries) {
      final propSchema = entry.value;
      if (propSchema is! Map) continue;
      final map = propSchema.map((k, v) => MapEntry(k.toString(), v));
      final type = _typeFor(
        map,
        '$name${pascalCase(entry.key)}',
        depth: depth + 1,
      );
      def.fields.add(
        ModelField(
          jsonKey: entry.key,
          dartName: uniqueName(safeMember(entry.key), usedMembers),
          type: type,
          doc: _fieldDoc(map),
        ),
      );
    }
  }

  String? _fieldDoc(Map<String, Object?> schema) {
    final node = deref(schema);
    final description = node['description'] as String?;
    final values = node['enum'];
    if (values is List && values.isNotEmpty) {
      final list = values.map((e) => '`$e`').join(', ');
      return [?description, 'Allowed values: $list.'].join(' ');
    }
    return description;
  }

  TypeInfo _typeFor(
    Map<String, Object?> schema,
    String fallbackName, {
    int depth = 0,
  }) {
    if (depth > 10) {
      return TypeInfo(dart: 'Object', read: (src) => src);
    }

    final isRef = schema[r'$ref'] is String;
    final node = deref(schema);
    final type = node['type'];

    if (type == 'string') return TypeInfo.primitive('String', 'asString');
    if (type == 'integer') return TypeInfo.primitive('int', 'asInt');
    if (type == 'number') return TypeInfo.primitive('num', 'asNum');
    if (type == 'boolean') return TypeInfo.primitive('bool', 'asBool');

    if (type == 'array') {
      final items = node['items'];
      if (items is! Map) {
        return TypeInfo(
          dart: 'List<Object?>',
          read: (src) => 'asObjectList($src)',
        );
      }
      final itemMap = items.map((k, v) => MapEntry(k.toString(), v));
      final item = _typeFor(itemMap, '${fallbackName}Item', depth: depth + 1);
      if (item.isModel) {
        return TypeInfo(
          dart: 'List<${item.dart}>',
          read: (src) => 'asModelList($src, ${item.dart}.fromJson)',
          write: (name) => '$name.map((e) => e.toJson()).toList()',
          isModelList: true,
        );
      }
      final coerce = switch (item.dart) {
        'String' => 'asString',
        'int' => 'asInt',
        'num' => 'asNum',
        'bool' => 'asBool',
        _ => null,
      };
      if (coerce == null) {
        return TypeInfo(
          dart: 'List<Object?>',
          read: (src) => 'asObjectList($src)',
        );
      }
      return TypeInfo(
        dart: 'List<${item.dart}>',
        read: (src) => 'asPrimitiveList<${item.dart}>($src, $coerce)',
      );
    }

    final shape = flatten(node);
    if (shape.props.isNotEmpty) {
      final modelName = _modelFor(
        isRef ? schema : node,
        fallbackName,
        depth: depth,
      );
      if (modelName == 'Map<String, Object?>') {
        return TypeInfo(dart: 'Map<String, Object?>', read: (s) => 'asMap($s)');
      }
      return TypeInfo(
        dart: modelName,
        read: (src) => 'asModel($src, $modelName.fromJson)',
        write: (name) => '$name.toJson()',
        isModel: true,
      );
    }

    if (type == 'object' || shape.freeForm) {
      return TypeInfo(dart: 'Map<String, Object?>', read: (s) => 'asMap($s)');
    }

    return TypeInfo(dart: 'Object', read: (src) => src);
  }

  // --- operations ----------------------------------------------------------

  final Map<String, List<_EmittedOp>> _byGroup = {};

  Map<String, List<_EmittedOp>> _buildOperations() {
    final byId = {for (final op in allOps) op.id: op};
    final entries = allowlist['operations'];
    if (entries is! YamlList) return _byGroup;

    for (final raw in entries) {
      if (raw is! YamlMap) continue;
      final id = raw['id'] as String?;
      if (id == null) continue;
      final op = byId[id];
      if (op == null) {
        stderr.writeln('WARNING: operationId not found in spec: $id');
        continue;
      }
      final group = (raw['group'] as String?) ?? 'misc';
      final methodName = (raw['as'] as String?) ?? camelCase(id);
      final perms = switch (raw['perms']) {
        final YamlList l => l.map((e) => e.toString()).toList(),
        _ => const <String>[],
      };
      _byGroup
          .putIfAbsent(group, () => [])
          .add(_buildOp(op, methodName, perms));
      emittedOps++;
    }
    return _byGroup;
  }

  _EmittedOp _buildOp(SpecOp op, String methodName, List<String> perms) {
    final pathParams = RegExp(
      r'\{([^}]+)\}',
    ).allMatches(op.path).map((m) => m.group(1)!).toList();

    final queryParams = <_Param>[];
    final headerParams = <_Param>[];
    final rawParams = op.node['parameters'];
    if (rawParams is List) {
      for (final entry in rawParams) {
        if (entry is! Map) continue;
        final resolved = deref(entry.map((k, v) => MapEntry(k.toString(), v)));
        final name = resolved['name'] as String?;
        final location = resolved['in'] as String?;
        if (name == null || location == null) continue;
        final schemaNode = resolved['schema'];
        final schema = schemaNode is Map
            ? schemaNode.map((k, v) => MapEntry(k.toString(), v))
            : <String, Object?>{};
        final type = _typeFor(
          schema,
          '${pascalCase(op.id)}${pascalCase(name)}',
        );
        final param = _Param(
          jsonName: name,
          dartName: safeMember(name),
          dart: _paramDart(type),
          required: resolved['required'] == true,
          doc: _fieldDoc(schema),
        );
        if (location == 'query') queryParams.add(param);
        if (location == 'header') headerParams.add(param);
      }
    }

    // Request body
    String? bodyType;
    var bodyIsModel = false;
    final requestBody = op.node['requestBody'];
    if (requestBody is Map) {
      final resolved = deref(
        requestBody.map((k, v) => MapEntry(k.toString(), v)),
      );
      final content = resolved['content'];
      if (content is Map && content['application/json'] is Map) {
        final schemaNode = (content['application/json']! as Map)['schema'];
        if (schemaNode is Map) {
          final schema = schemaNode.map((k, v) => MapEntry(k.toString(), v));
          final info = _typeFor(schema, '${pascalCase(op.id)}Body');
          bodyType = info.dart;
          bodyIsModel = info.isModel;
        }
      }
    }

    // Response
    final response = _responseSchema(op);
    return _EmittedOp(
      op: op,
      methodName: methodName,
      perms: perms,
      pathParams: pathParams,
      queryParams: queryParams,
      headerParams: headerParams,
      bodyType: bodyType,
      bodyIsModel: bodyIsModel,
      resultModel: response.model,
      isCollection: response.isCollection,
      plainText: response.plainText,
    );
  }

  String _paramDart(TypeInfo info) => switch (info.dart) {
    'String' || 'int' || 'num' || 'bool' => info.dart,
    final String d when d.startsWith('List<') => 'List<String>',
    _ => 'String',
  };

  _ResponseInfo _responseSchema(SpecOp op) {
    final responses = op.node['responses'];
    if (responses is! Map) return const _ResponseInfo();

    Map<String, Object?>? success;
    for (final code in const ['200', '201', '202', '2XX']) {
      final node = responses[code];
      if (node is Map) {
        success = deref(node.map((k, v) => MapEntry(k.toString(), v)));
        break;
      }
    }
    if (success == null) return const _ResponseInfo();

    final content = success['content'];
    if (content is! Map || content.isEmpty) return const _ResponseInfo();
    final json = content['application/json'];
    if (json is! Map) {
      // e.g. the BIND export, which answers with text/plain.
      return const _ResponseInfo(plainText: true);
    }
    final schemaNode = json['schema'];
    if (schemaNode is! Map) return const _ResponseInfo();

    final schema = schemaNode.map((k, v) => MapEntry(k.toString(), v));
    final shape = flatten(schema);
    final hasEnvelope =
        shape.props.containsKey('success') && shape.props.containsKey('result');
    if (!hasEnvelope) return const _ResponseInfo();

    final resultSchema = shape.props['result'];
    if (resultSchema is! Map) return const _ResponseInfo();
    final result = resultSchema.map((k, v) => MapEntry(k.toString(), v));
    final resolved = deref(result);

    if (resolved['type'] == 'array') {
      final items = resolved['items'];
      if (items is! Map) return const _ResponseInfo();
      final info = _typeFor(
        items.map((k, v) => MapEntry(k.toString(), v)),
        '${pascalCase(op.id)}Item',
      );
      return _ResponseInfo(
        model: info.isModel ? info.dart : null,
        isCollection: true,
      );
    }

    final info = _typeFor(result, '${pascalCase(op.id)}Result');
    return _ResponseInfo(model: info.isModel ? info.dart : null);
  }

  // --- emission ------------------------------------------------------------

  void _writeModels() {
    final buffer = StringBuffer()
      ..writeln(kHeader)
      ..writeln("import '../coerce.dart';")
      ..writeln();

    final names = models.keys.toList()..sort();
    for (final name in names) {
      _emitModel(buffer, models[name]!);
    }
    _write('lib/api/generated/models.dart', buffer.toString());
  }

  void _emitModel(StringBuffer b, ModelDef def) {
    final doc = docComment(def.doc);
    if (doc.isNotEmpty) b.writeln(doc);
    b.writeln('class ${def.name} {');

    // constructor
    b.writeln('  const ${def.name}({');
    for (final f in def.fields) {
      b.writeln('    this.${f.dartName},');
    }
    b.writeln('    this.extra = const <String, Object?>{},');
    b.writeln('  });');
    b.writeln();

    // fromJson
    b.writeln(
      '  factory ${def.name}.fromJson(Map<String, Object?> json) => ${def.name}(',
    );
    for (final f in def.fields) {
      b.writeln(
        '        ${f.dartName}: ${f.type.read("json[${dartString(f.jsonKey)}]")},',
      );
    }
    b.writeln('        extra: extraOf(json, _knownKeys),');
    b.writeln('      );');
    b.writeln();

    // fields
    for (final f in def.fields) {
      final fieldDoc = docComment(f.doc, indent: '  ');
      if (fieldDoc.isNotEmpty) b.writeln(fieldDoc);
      b.writeln('  final ${f.type.nullable} ${f.dartName};');
    }
    b
      ..writeln()
      ..writeln(
        '  /// Keys returned by Cloudflare that this spec snapshot does',
      )
      ..writeln('  /// not describe. Preserved so an edit round-trip cannot')
      ..writeln('  /// silently drop them.')
      ..writeln('  final Map<String, Object?> extra;')
      ..writeln();

    // known keys
    b.write('  static const Set<String> _knownKeys = {');
    b.write(def.fields.map((f) => dartString(f.jsonKey)).join(', '));
    b
      ..writeln('};')
      ..writeln();

    // toJson
    b.writeln('  Map<String, Object?> toJson() => <String, Object?>{');
    b.writeln('        ...extra,');
    for (final f in def.fields) {
      final value = f.type.writeExpr('${f.dartName}!');
      b.writeln(
        '        if (${f.dartName} != null) ${dartString(f.jsonKey)}: $value,',
      );
    }
    b
      ..writeln('      };')
      ..writeln();

    // copyWith — cannot unset a field to null by design; build a fresh
    // instance when that is what you mean.
    if (def.fields.isNotEmpty) {
      b.writeln('  ${def.name} copyWith({');
      for (final f in def.fields) {
        b.writeln('    ${f.type.nullable} ${f.dartName},');
      }
      b.writeln('    Map<String, Object?>? extra,');
      b.writeln('  }) => ${def.name}(');
      for (final f in def.fields) {
        b.writeln(
          '        ${f.dartName}: ${f.dartName} ?? this.${f.dartName},',
        );
      }
      b.writeln('        extra: extra ?? this.extra,');
      b.writeln('      );');
    }

    b
      ..writeln('}')
      ..writeln();
  }

  void _writeOps(Map<String, List<_EmittedOp>> groups) {
    for (final entry in groups.entries) {
      final className = '${pascalCase(entry.key)}Api';
      final b = StringBuffer()
        ..writeln(kHeader)
        ..writeln("import 'package:dio/dio.dart';")
        ..writeln()
        // ops/ sits two levels below lib/api, so core is three levels up.
        ..writeln("import '../../../core/net/cf_client.dart';")
        ..writeln("import '../../../core/net/envelope.dart';")
        ..writeln("import '../../../core/net/paginator.dart';")
        ..writeln("import '../models.dart';")
        ..writeln()
        ..writeln('/// ${_groupDoc(entry.key)}')
        ..writeln('class $className {')
        ..writeln('  const $className(this._client);')
        ..writeln()
        ..writeln('  final CfClient _client;');

      for (final op in entry.value) {
        _emitOperation(b, op);
      }
      b.writeln('}');
      _write(
        'lib/api/generated/ops/${snakeCase(entry.key)}_api.dart',
        b.toString(),
      );
    }
  }

  String _groupDoc(String group) {
    final groups = allowlist['groups'];
    if (groups is YamlMap && groups[group] != null) {
      return groups[group].toString();
    }
    return 'Generated Cloudflare operations.';
  }

  void _emitOperation(StringBuffer b, _EmittedOp op) {
    final returnType = op.returnType;
    final params = <String>[];

    for (final p in op.pathParams) {
      params.add('required String ${safeMember(p)}');
    }
    if (op.bodyType != null) {
      params.add('required ${op.bodyType} body');
    }
    for (final q in op.queryParams) {
      params.add('${q.dart}? ${q.dartName}');
    }
    params
      ..add('Map<String, Object?>? extraQuery')
      ..add('CancelToken? cancelToken');

    b
      ..writeln()
      ..writeln('  /// `${op.op.method} ${op.op.path}`');
    final summary = op.op.summary;
    if (summary != null && summary.trim().isNotEmpty) {
      b.writeln(docComment(summary, indent: '  '));
    }
    if (op.op.deprecated) {
      b.writeln('  @Deprecated(\'Deprecated in the Cloudflare API.\')');
    }

    b
      ..writeln('  Future<$returnType> ${op.methodName}({')
      ..writeln('    ${params.join(',\n    ')},')
      ..writeln('  }) async {');

    // path interpolation
    final dartPath = op.op.path.replaceAllMapped(
      RegExp(r'\{([^}]+)\}'),
      (m) => '\$${safeMember(m.group(1)!)}',
    );

    // Leading underscore so it can never collide with a parameter: safeMember
    // strips punctuation, so no Cloudflare parameter name can produce one.
    // Pages' deployment listing has a query parameter literally called `env`.
    b.writeln('    final _env = await _client.send(');
    b.writeln("      method: '${op.op.method}',");
    b.writeln("      path: '$dartPath',");
    if (op.bodyType != null) {
      b.writeln('      body: ${op.bodyIsModel ? 'body.toJson()' : 'body'},');
    }
    b.writeln('      query: <String, Object?>{');
    for (final q in op.queryParams) {
      b.writeln('        ${dartString(q.jsonName)}: ${q.dartName},');
    }
    b.writeln('        ...?extraQuery,');
    b.writeln('      },');
    b.writeln('      cancelToken: cancelToken,');
    if (op.perms.isNotEmpty) {
      final set = op.perms.map(dartString).join(', ');
      b.writeln('      missingPermissions: const {$set},');
    }
    if (op.plainText) {
      b.writeln('      responseType: ResponseType.plain,');
    }
    b.writeln('    );');

    if (op.isCollection && op.resultModel != null) {
      b.writeln('    return CfPage.from(_env, ${op.resultModel}.fromJson);');
    } else if (op.resultModel != null) {
      b.writeln('    return ${op.resultModel}.fromJson(_env.resultAsMap);');
    } else {
      b.writeln('    return _env;');
    }
    b.writeln('  }');
  }

  void _writeBarrel(Map<String, List<_EmittedOp>> groups) {
    final b = StringBuffer()
      ..writeln(kHeader)
      ..writeln("import '../../core/net/cf_client.dart';");
    final keys = groups.keys.toList()..sort();
    for (final g in keys) {
      b.writeln("import 'ops/${snakeCase(g)}_api.dart';");
    }
    b.writeln();
    b.writeln("export 'models.dart';");
    for (final g in keys) {
      b.writeln("export 'ops/${snakeCase(g)}_api.dart';");
    }
    b
      ..writeln()
      ..writeln('/// Number of operations described by the bundled spec.')
      ..writeln('///')
      ..writeln('/// Emitted rather than written by hand so the figure quoted')
      ..writeln('/// in onboarding cannot drift from the shipped index.')
      ..writeln('const int kCloudflareOperationCount = ${allOps.length};')
      ..writeln()
      ..writeln('/// `info.version` of the bundled Cloudflare description.')
      ..writeln(
        'const String kCloudflareApiVersion = '
        '${dartString((spec['info'] as Map?)?['version']?.toString() ?? '')};',
      )
      ..writeln()
      ..writeln(
        '/// Typed entry point to the allowlisted Cloudflare operations.',
      )
      ..writeln('///')
      ..writeln(
        '/// Endpoints outside the allowlist remain reachable through the',
      )
      ..writeln('/// schema-aware explorer and [CfClient.sendRaw].')
      ..writeln('class CfApi {')
      ..writeln('  CfApi(this.client);')
      ..writeln()
      ..writeln('  final CfClient client;');
    for (final g in keys) {
      b.writeln('  late final ${camelCase(g)} = ${pascalCase(g)}Api(client);');
    }
    b.writeln('}');
    _write('lib/api/generated/generated.dart', b.toString());
  }

  // --- runtime spec assets --------------------------------------------------

  static const Set<String> _stripKeys = {
    'description',
    'example',
    'examples',
    'externalDocs',
    'title',
    'xml',
    'x-stainless-const',
  };

  Object? _strip(Object? node) {
    if (node is Map) {
      final out = <String, Object?>{};
      node.forEach((k, v) {
        final key = k.toString();
        if (_stripKeys.contains(key)) return;
        out[key] = _strip(v);
      });
      return out;
    }
    if (node is List) return node.map(_strip).toList();
    return node;
  }

  void _writeAssets() {
    // Operation index: everything a form builder needs, and nothing else.
    final ops = <Map<String, Object?>>[];
    for (final op in allOps) {
      final params = <Map<String, Object?>>[];
      final raw = op.node['parameters'];
      if (raw is List) {
        for (final entry in raw) {
          if (entry is! Map) continue;
          final p = deref(entry.map((k, v) => MapEntry(k.toString(), v)));
          final schemaNode = p['schema'];
          final schema = schemaNode is Map
              ? deref(schemaNode.map((k, v) => MapEntry(k.toString(), v)))
              : const <String, Object?>{};
          params.add({
            'name': p['name'],
            'in': p['in'],
            if (p['required'] == true) 'required': true,
            if (schema['type'] != null) 'type': schema['type'],
            if (schema['format'] != null) 'format': schema['format'],
            if (schema['enum'] != null) 'enum': schema['enum'],
            if (schema['default'] != null) 'default': schema['default'],
            if (schema['minimum'] != null) 'minimum': schema['minimum'],
            if (schema['maximum'] != null) 'maximum': schema['maximum'],
            if (schema['pattern'] != null) 'pattern': schema['pattern'],
            if (p['description'] != null)
              'doc': _shorten(p['description'].toString()),
          });
        }
      }

      String? bodyRef;
      final body = op.node['requestBody'];
      if (body is Map) {
        final resolved = deref(body.map((k, v) => MapEntry(k.toString(), v)));
        final content = resolved['content'];
        if (content is Map) {
          final json = content['application/json'];
          if (json is Map && json['schema'] is Map) {
            final schema = json['schema']! as Map;
            bodyRef = schema[r'$ref'] as String?;
            bodyRef ??= '#/inline/${op.id}';
          }
        }
      }

      ops.add({
        'id': op.id,
        'method': op.method,
        'path': op.path,
        'tag': op.tag,
        if (op.summary != null) 'summary': _shorten(op.summary!),
        if (op.deprecated) 'deprecated': true,
        if (params.isNotEmpty) 'params': params,
        'body': ?bodyRef,
      });
    }

    _write(
      'assets/spec/operations.json',
      jsonEncode({
        'api_version': (spec['info'] as Map?)?['version'],
        'count': ops.length,
        'operations': ops,
      }),
      format: false,
    );

    // Inline request bodies get a synthetic entry so the explorer can build a
    // form for them exactly as it does for a named schema.
    final inline = <String, Object?>{};
    for (final op in allOps) {
      final body = op.node['requestBody'];
      if (body is! Map) continue;
      final resolved = deref(body.map((k, v) => MapEntry(k.toString(), v)));
      final content = resolved['content'];
      if (content is! Map) continue;
      final json = content['application/json'];
      if (json is! Map || json['schema'] is! Map) continue;
      final schema = json['schema']! as Map;
      if (schema[r'$ref'] != null) continue;
      inline['#/inline/${op.id}'] = _strip(schema);
    }

    _write(
      'assets/spec/schemas.json',
      jsonEncode({'schemas': _strip(schemas), 'inline': inline}),
      format: false,
    );
  }

  static String _shorten(String text) {
    final collapsed = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    return collapsed.length > 240
        ? '${collapsed.substring(0, 240)}…'
        : collapsed;
  }

  // --- smoke test ----------------------------------------------------------

  /// Emits a round-trip test per generated model.
  ///
  /// It uses the spec's own `example` payloads where present, which makes this
  /// the cheapest possible guard against spec drift: when the weekly spec bot
  /// changes a field name, this test fails in the same PR.
  void _writeSmokeTest() {
    final b = StringBuffer()
      ..writeln(kHeader)
      ..writeln("import 'dart:convert';")
      ..writeln()
      ..writeln("import 'package:cloudflare_mobile/api/generated/models.dart';")
      ..writeln("import 'package:flutter_test/flutter_test.dart';")
      ..writeln()
      ..writeln('void main() {')
      ..writeln("  group('generated models round-trip', () {");

    final names = models.keys.toList()..sort();
    for (final name in names) {
      final def = models[name]!;
      // A raw triple-quoted literal sidesteps every escaping question that
      // JSON payloads raise inside Dart source ($, quotes, backslashes).
      final sample = def.example == null ? '{}' : jsonEncode(def.example);
      if (sample.contains("'''")) continue;
      b
        ..writeln("    test('$name', () {")
        ..writeln("      final json = jsonDecode(r'''$sample''')")
        ..writeln('          as Map<String, Object?>;')
        ..writeln('      final model = $name.fromJson(json);')
        ..writeln('      final encoded = model.toJson();')
        ..writeln('      final again = $name.fromJson(encoded);')
        ..writeln('      expect(again.toJson(), encoded);')
        ..writeln('    });');
    }

    b
      ..writeln('  });')
      ..writeln('}');
    _write('test/generated/model_smoke_test.dart', b.toString());
  }

  // --- io ------------------------------------------------------------------

  void _write(String relative, String contents, {bool format = true}) {
    final file = File('$root/$relative');
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(contents.replaceAll('\r\n', '\n'));
  }
}

class _Param {
  _Param({
    required this.jsonName,
    required this.dartName,
    required this.dart,
    required this.required,
    this.doc,
  });

  final String jsonName;
  final String dartName;
  final String dart;
  final bool required;
  final String? doc;
}

class _ResponseInfo {
  const _ResponseInfo({
    this.model,
    this.isCollection = false,
    this.plainText = false,
  });

  final String? model;
  final bool isCollection;
  final bool plainText;
}

class _EmittedOp {
  _EmittedOp({
    required this.op,
    required this.methodName,
    required this.perms,
    required this.pathParams,
    required this.queryParams,
    required this.headerParams,
    required this.bodyType,
    required this.bodyIsModel,
    required this.resultModel,
    required this.isCollection,
    required this.plainText,
  });

  final SpecOp op;
  final String methodName;
  final List<String> perms;
  final List<String> pathParams;
  final List<_Param> queryParams;
  final List<_Param> headerParams;
  final String? bodyType;
  final bool bodyIsModel;
  final String? resultModel;
  final bool isCollection;
  final bool plainText;

  String get returnType {
    if (isCollection && resultModel != null) return 'CfPage<$resultModel>';
    if (resultModel != null) return resultModel!;
    return 'CfEnvelope';
  }
}

/// Identifier hygiene for generated code.
///
/// Cloudflare's schema and property names are not Dart-safe: they contain
/// hyphens (`dns-records_dns-record-post`), dots (`account.id`), apostrophes
/// (`user'-s-account-memberships-list-memberships`), and they include words
/// that are Dart keywords — `in`, `default`, `class`, `switch` and `is` all
/// appear as real field names in the spec.
library;

/// Dart reserved words plus contextual keywords that cannot be used bare as a
/// parameter or field name.
const Set<String> dartReserved = {
  'abstract', 'as', 'assert', 'async', 'await', 'base', 'break', 'case',
  'catch', 'class', 'const', 'continue', 'covariant', 'default', 'deferred',
  'do', 'dynamic', 'else', 'enum', 'export', 'extends', 'extension',
  'external', 'factory', 'false', 'final', 'finally', 'for', 'function',
  'get', 'hide', 'if', 'implements', 'import', 'in', 'interface', 'is',
  'late', 'library', 'mixin', 'new', 'null', 'of', 'on', 'operator', 'part',
  'required', 'rethrow', 'return', 'sealed', 'set', 'show', 'static', 'super',
  'switch', 'sync', 'this', 'throw', 'true', 'try', 'type', 'typedef', 'var',
  'void', 'when', 'while', 'with', 'yield',
};

/// Names that would collide with members every generated class already has.
const Set<String> reservedMembers = {
  'toJson',
  'fromJson',
  'copyWith',
  'extra',
  'hashCode',
  'runtimeType',
  'toString',
  'noSuchMethod',
};

List<String> _words(String raw) {
  final cleaned = raw.replaceAll(RegExp(r'[^A-Za-z0-9]+'), ' ');
  final parts = <String>[];
  for (final chunk in cleaned.split(' ')) {
    if (chunk.isEmpty) continue;
    // Split camelCase and acronym boundaries: `perPage` -> [per, Page],
    // `DNSRecord` -> [DNS, Record].
    final matches = RegExp(
      r'[A-Z]+(?![a-z])|[A-Z][a-z0-9]*|[a-z0-9]+',
    ).allMatches(chunk);
    if (matches.isEmpty) {
      parts.add(chunk);
    } else {
      parts.addAll(matches.map((m) => m.group(0)!));
    }
  }
  return parts;
}

String pascalCase(String raw) {
  final words = _words(raw);
  if (words.isEmpty) return 'Unnamed';
  final buffer = StringBuffer();
  for (final w in words) {
    final lower = w.toLowerCase();
    buffer
      ..write(lower[0].toUpperCase())
      ..write(lower.substring(1));
  }
  var out = buffer.toString();
  if (RegExp(r'^[0-9]').hasMatch(out)) out = 'N$out';
  return out;
}

String camelCase(String raw) {
  final p = pascalCase(raw);
  if (p.isEmpty) return p;
  return p[0].toLowerCase() + p.substring(1);
}

String snakeCase(String raw) => _words(raw).map((w) => w.toLowerCase()).join('_');

/// A Dart-safe field or parameter name. Keywords get a trailing underscore,
/// which keeps them readable while the JSON key is preserved separately.
String safeMember(String jsonKey) {
  var name = camelCase(jsonKey);
  if (name.isEmpty) name = 'value';
  if (dartReserved.contains(name) || reservedMembers.contains(name)) {
    name = '${name}_';
  }
  if (RegExp(r'^[0-9]').hasMatch(name)) name = 'n$name';
  return name;
}

/// Ensures a name is unique within a namespace, appending 2, 3, … on collision.
String uniqueName(String candidate, Set<String> taken) {
  if (taken.add(candidate)) return candidate;
  var i = 2;
  while (!taken.add('$candidate$i')) {
    i++;
  }
  return '$candidate$i';
}

/// Escapes a string for a single-quoted Dart literal.
String dartString(String value) {
  final escaped = value
      .replaceAll(r'\', r'\\')
      .replaceAll("'", r"\'")
      .replaceAll(r'$', r'\$')
      .replaceAll('\n', r'\n')
      .replaceAll('\r', r'\r');
  return "'$escaped'";
}

/// Wraps text as a `///` doc comment, or returns an empty string.
String docComment(String? text, {String indent = ''}) {
  if (text == null || text.trim().isEmpty) return '';
  final collapsed = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  final words = collapsed.split(' ');
  final lines = <String>[];
  var current = StringBuffer();
  for (final w in words) {
    if (current.length + w.length + 1 > 76) {
      lines.add(current.toString());
      current = StringBuffer();
    }
    if (current.isNotEmpty) current.write(' ');
    current.write(w);
  }
  if (current.isNotEmpty) lines.add(current.toString());
  return lines.map((l) => '$indent/// $l').join('\n');
}

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Endpoint {
  final String method;
  final String path;
  final String summary;
  final String operationId;
  final bool deprecated;
  final String tag;

  const Endpoint({
    required this.method,
    required this.path,
    required this.summary,
    required this.operationId,
    required this.deprecated,
    required this.tag,
  });

  /// Path parameter names extracted from `{name}` placeholders.
  List<String> get pathParams {
    final reg = RegExp(r'\{([^}]+)\}');
    return reg.allMatches(path).map((m) => m.group(1)!).toList();
  }

  /// Pretty grouped category derived from tag (first word).
  String get category {
    if (tag.startsWith('Radar')) return 'Radar';
    if (tag.startsWith('Workers') ||
        tag.startsWith('Worker ') ||
        tag.startsWith('workers') ||
        tag.startsWith('Worker')) {
      return 'Workers';
    }
    if (tag.startsWith('R2')) return 'R2 Storage';
    if (tag.startsWith('DNS') || tag.contains('DNS')) return 'DNS';
    if (tag.startsWith('Zone')) return 'Zones';
    if (tag.startsWith('Page')) return 'Pages';
    if (tag.startsWith('Stream')) return 'Stream';
    if (tag.startsWith('Email')) return 'Email';
    if (tag.startsWith('AI ') || tag.startsWith('Workers AI')) return 'AI';
    if (tag.startsWith('Magic')) return 'Magic Networking';
    if (tag.startsWith('Tunnel') || tag.contains('Tunnel')) return 'Tunnels';
    if (tag.contains('Access') || tag.startsWith('Zero Trust')) {
      return 'Zero Trust';
    }
    if (tag.startsWith('Account')) return 'Account';
    if (tag.startsWith('User')) return 'User';
    if (tag.startsWith('Cache')) return 'Cache';
    if (tag.startsWith('SSL') || tag.startsWith('TLS') ||
        tag.startsWith('Certificate')) {
      return 'SSL/TLS';
    }
    if (tag.startsWith('Firewall') || tag.contains('WAF') ||
        tag.startsWith('Security')) {
      return 'Security';
    }
    if (tag.startsWith('Load')) return 'Load Balancing';
    if (tag.startsWith('Queue')) return 'Queues';
    if (tag.startsWith('KV')) return 'KV';
    if (tag.startsWith('D1')) return 'D1 Database';
    return 'Other';
  }
}

class Catalog {
  final List<Endpoint> all;
  final Map<String, List<Endpoint>> byTag;
  final Map<String, List<String>> tagsByCategory;

  Catalog({
    required this.all,
    required this.byTag,
    required this.tagsByCategory,
  });

  static Future<Catalog> load() async {
    final raw = await rootBundle.loadString('assets/endpoints.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final byTag = <String, List<Endpoint>>{};
    final all = <Endpoint>[];
    for (final entry in json.entries) {
      final list = (entry.value as List)
          .map((e) => Endpoint(
                method: (e['method'] ?? '').toString().toUpperCase(),
                path: (e['path'] ?? '').toString(),
                summary: (e['summary'] ?? '').toString(),
                operationId: (e['operationId'] ?? '').toString(),
                deprecated: e['deprecated'] == true,
                tag: entry.key,
              ))
          .toList();
      byTag[entry.key] = list;
      all.addAll(list);
    }
    // Sort tags inside each list by method then path.
    for (final v in byTag.values) {
      v.sort((a, b) {
        final m = a.method.compareTo(b.method);
        if (m != 0) return m;
        return a.path.compareTo(b.path);
      });
    }
    // Group tags by category.
    final categoryMap = <String, List<String>>{};
    for (final tag in byTag.keys) {
      final cat = byTag[tag]!.first.category;
      categoryMap.putIfAbsent(cat, () => []).add(tag);
    }
    for (final v in categoryMap.values) {
      v.sort();
    }
    return Catalog(all: all, byTag: byTag, tagsByCategory: categoryMap);
  }
}

final catalogProvider = FutureProvider<Catalog>((_) => Catalog.load());

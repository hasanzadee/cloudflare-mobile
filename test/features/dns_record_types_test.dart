import 'package:cloudflare_mobile/api/generated/models.dart';
import 'package:cloudflare_mobile/features/dns/record_types.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('record type table', () {
    test('covers the types Cloudflare accepts', () {
      final names = kDnsRecordTypes.map((t) => t.name).toSet();
      expect(
        names,
        containsAll(<String>[
          'A',
          'AAAA',
          'CNAME',
          'TXT',
          'MX',
          'NS',
          'PTR',
          'SRV',
          'CAA',
          'TLSA',
          'SSHFP',
          'DS',
          'DNSKEY',
          'NAPTR',
          'CERT',
          'SMIMEA',
          'URI',
          'SVCB',
          'HTTPS',
          'LOC',
          'OPENPGPKEY',
        ]),
      );
    });

    test('only proxyable types offer the orange cloud', () {
      final proxyable = kDnsRecordTypes
          .where((t) => t.proxyable)
          .map((t) => t.name)
          .toSet();
      expect(proxyable, {'A', 'AAAA', 'CNAME'});
    });

    test('MX carries a priority, A does not', () {
      expect(dnsTypeByName('MX').hasPriority, isTrue);
      expect(dnsTypeByName('A').hasPriority, isFalse);
    });

    test('SRV is data-driven, not content-driven', () {
      // The prototype offered one free-text `content` box, which made SRV
      // impossible to create at all.
      final srv = dnsTypeByName('SRV');
      expect(srv.usesContent, isFalse);
      expect(
        srv.dataFields.map((f) => f.key),
        containsAll(<String>['priority', 'weight', 'port', 'target']),
      );
    });

    test('an unknown type falls back rather than throwing', () {
      expect(dnsTypeByName('NOPE').name, 'A');
      expect(dnsTypeByName(null).name, 'A');
    });

    test('ttl 1 is Cloudflare\'s automatic sentinel', () {
      expect(ttlLabel(1), 'Auto');
      expect(ttlLabel(300), '5 min');
      expect(ttlLabel(7200), '2 h');
    });
  });

  group('record serialization', () {
    test('per-type data fields survive toJson via extra', () {
      // The generated DnsRecordPostData only declares the two members the
      // spec's anyOf branches share; everything else rides in `extra`. If that
      // ever stopped round-tripping, SRV and CAA records would be silently
      // truncated on save.
      final record = DnsRecordPost(
        type_: 'SRV',
        name: '_sip._tcp.example.com',
        ttl: 1,
        data: const DnsRecordPostData(
          extra: {
            'priority': 10,
            'weight': 60,
            'port': 5060,
            'target': 'sip.example.com',
          },
        ),
      );

      final json = record.toJson();
      expect(json['type'], 'SRV');

      final data = json['data']! as Map<String, Object?>;
      expect(data['priority'], 10);
      expect(data['weight'], 60);
      expect(data['port'], 5060);
      expect(data['target'], 'sip.example.com');
    });

    test('a CAA record keeps flags, tag and value', () {
      final json = const DnsRecordPost(
        type_: 'CAA',
        name: 'example.com',
        data: DnsRecordPostData(
          extra: {'flags': 0, 'tag': 'issue', 'value': 'letsencrypt.org'},
        ),
      ).toJson();

      final data = json['data']! as Map<String, Object?>;
      expect(data['tag'], 'issue');
      expect(data['value'], 'letsencrypt.org');
    });

    test('MX priority lands at the top level, not inside data', () {
      final json = const DnsRecordPost(
        type_: 'MX',
        name: 'example.com',
        content: 'mail.example.com',
        priority: 10,
      ).toJson();

      expect(json['priority'], 10);
      expect(json.containsKey('data'), isFalse);
    });

    test('null fields are omitted so a PATCH does not clear them', () {
      final json = const DnsRecordPost(type_: 'A', name: 'x').toJson();
      expect(json.keys, containsAll(<String>['type', 'name']));
      expect(json.containsKey('proxied'), isFalse);
      expect(json.containsKey('content'), isFalse);
    });

    test('unknown response keys survive a read-modify-write cycle', () {
      // Cloudflare adds fields between spec snapshots; dropping them on save
      // would quietly revert settings the app never knew about.
      final parsed = DnsRecordResponse.fromJson(const {
        'id': 'abc',
        'type': 'A',
        'name': 'example.com',
        'content': '192.0.2.1',
        'some_new_field': 'keep me',
      });

      expect(parsed.extra['some_new_field'], 'keep me');
      expect(parsed.toJson()['some_new_field'], 'keep me');
    });
  });
}

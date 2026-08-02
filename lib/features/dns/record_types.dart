/// Field layout for every DNS record type Cloudflare accepts.
///
/// The prototype exposed `type` as a free-text field and offered one `content`
/// box, so creating an MX record without a priority, or an SRV record at all,
/// simply failed with a server-side error the user had to decode.
///
/// Cloudflare models the structured types with a `data` object rather than a
/// content string; this table says which fields go where. It is hand-written on
/// purpose: the spec expresses these as 21 sibling schemas with overlapping
/// field names, and a mechanical rendering of that produces a worse form than a
/// short table does.
library;

enum DnsFieldKind { text, number, multiline }

class DnsField {
  const DnsField({
    required this.key,
    required this.label,
    this.kind = DnsFieldKind.text,
    this.required = true,
    this.hint,
    this.min,
    this.max,
  });

  /// Key inside `data`, or `content` / `priority` at the top level.
  final String key;
  final String label;
  final DnsFieldKind kind;
  final bool required;
  final String? hint;
  final num? min;
  final num? max;
}

class DnsRecordType {
  const DnsRecordType({
    required this.name,
    required this.description,
    this.usesContent = true,
    this.hasPriority = false,
    this.proxyable = false,
    this.dataFields = const [],
    this.contentHint,
  });

  final String name;
  final String description;

  /// Whether the value lives in the top-level `content` string.
  final bool usesContent;

  /// Whether a top-level `priority` applies (MX, URI).
  final bool hasPriority;

  /// Whether the orange cloud can be turned on for this type.
  final bool proxyable;

  /// Structured members of the `data` object.
  final List<DnsField> dataFields;

  final String? contentHint;
}

const List<DnsRecordType> kDnsRecordTypes = [
  DnsRecordType(
    name: 'A',
    description: 'IPv4 address',
    proxyable: true,
    contentHint: '192.0.2.1',
  ),
  DnsRecordType(
    name: 'AAAA',
    description: 'IPv6 address',
    proxyable: true,
    contentHint: '2001:db8::1',
  ),
  DnsRecordType(
    name: 'CNAME',
    description: 'Alias to another name',
    proxyable: true,
    contentHint: 'example.com',
  ),
  DnsRecordType(
    name: 'TXT',
    description: 'Free-form text, SPF, DKIM, verification',
    contentHint: 'v=spf1 include:_spf.example.com ~all',
  ),
  DnsRecordType(
    name: 'MX',
    description: 'Mail exchanger',
    hasPriority: true,
    contentHint: 'mail.example.com',
  ),
  DnsRecordType(
    name: 'NS',
    description: 'Delegation to another nameserver',
    contentHint: 'ns1.example.com',
  ),
  DnsRecordType(
    name: 'PTR',
    description: 'Reverse lookup',
    contentHint: 'example.com',
  ),
  DnsRecordType(
    name: 'SRV',
    description: 'Service location',
    usesContent: false,
    dataFields: [
      DnsField(
        key: 'priority',
        label: 'Priority',
        kind: DnsFieldKind.number,
        min: 0,
        max: 65535,
      ),
      DnsField(
        key: 'weight',
        label: 'Weight',
        kind: DnsFieldKind.number,
        min: 0,
        max: 65535,
      ),
      DnsField(
        key: 'port',
        label: 'Port',
        kind: DnsFieldKind.number,
        min: 0,
        max: 65535,
      ),
      DnsField(key: 'target', label: 'Target', hint: 'server.example.com'),
    ],
  ),
  DnsRecordType(
    name: 'CAA',
    description: 'Which CAs may issue certificates',
    usesContent: false,
    dataFields: [
      DnsField(
        key: 'flags',
        label: 'Flags',
        kind: DnsFieldKind.number,
        min: 0,
        max: 255,
      ),
      DnsField(key: 'tag', label: 'Tag', hint: 'issue, issuewild or iodef'),
      DnsField(key: 'value', label: 'Value', hint: 'letsencrypt.org'),
    ],
  ),
  DnsRecordType(
    name: 'TLSA',
    description: 'TLS certificate association',
    usesContent: false,
    dataFields: [
      DnsField(
        key: 'usage',
        label: 'Usage',
        kind: DnsFieldKind.number,
        min: 0,
        max: 3,
      ),
      DnsField(
        key: 'selector',
        label: 'Selector',
        kind: DnsFieldKind.number,
        min: 0,
        max: 1,
      ),
      DnsField(
        key: 'matching_type',
        label: 'Matching type',
        kind: DnsFieldKind.number,
        min: 0,
        max: 2,
      ),
      DnsField(
        key: 'certificate',
        label: 'Certificate',
        kind: DnsFieldKind.multiline,
      ),
    ],
  ),
  DnsRecordType(
    name: 'SSHFP',
    description: 'SSH host key fingerprint',
    usesContent: false,
    dataFields: [
      DnsField(
        key: 'algorithm',
        label: 'Algorithm',
        kind: DnsFieldKind.number,
        min: 0,
        max: 4,
      ),
      DnsField(
        key: 'type',
        label: 'Type',
        kind: DnsFieldKind.number,
        min: 0,
        max: 2,
      ),
      DnsField(
        key: 'fingerprint',
        label: 'Fingerprint',
        kind: DnsFieldKind.multiline,
      ),
    ],
  ),
  DnsRecordType(
    name: 'DS',
    description: 'DNSSEC delegation signer',
    usesContent: false,
    dataFields: [
      DnsField(
        key: 'key_tag',
        label: 'Key tag',
        kind: DnsFieldKind.number,
        min: 0,
        max: 65535,
      ),
      DnsField(
        key: 'algorithm',
        label: 'Algorithm',
        kind: DnsFieldKind.number,
        min: 0,
        max: 255,
      ),
      DnsField(
        key: 'digest_type',
        label: 'Digest type',
        kind: DnsFieldKind.number,
        min: 0,
        max: 255,
      ),
      DnsField(key: 'digest', label: 'Digest', kind: DnsFieldKind.multiline),
    ],
  ),
  DnsRecordType(
    name: 'DNSKEY',
    description: 'DNSSEC public key',
    usesContent: false,
    dataFields: [
      DnsField(
        key: 'flags',
        label: 'Flags',
        kind: DnsFieldKind.number,
        min: 0,
        max: 65535,
      ),
      DnsField(
        key: 'protocol',
        label: 'Protocol',
        kind: DnsFieldKind.number,
        min: 0,
        max: 255,
      ),
      DnsField(
        key: 'algorithm',
        label: 'Algorithm',
        kind: DnsFieldKind.number,
        min: 0,
        max: 255,
      ),
      DnsField(
        key: 'public_key',
        label: 'Public key',
        kind: DnsFieldKind.multiline,
      ),
    ],
  ),
  DnsRecordType(
    name: 'NAPTR',
    description: 'Naming authority pointer',
    usesContent: false,
    dataFields: [
      DnsField(
        key: 'order',
        label: 'Order',
        kind: DnsFieldKind.number,
        min: 0,
        max: 65535,
      ),
      DnsField(
        key: 'preference',
        label: 'Preference',
        kind: DnsFieldKind.number,
        min: 0,
        max: 65535,
      ),
      DnsField(key: 'flags', label: 'Flags', required: false),
      DnsField(key: 'service', label: 'Service', required: false),
      DnsField(key: 'regex', label: 'Regex', required: false),
      DnsField(key: 'replacement', label: 'Replacement', required: false),
    ],
  ),
  DnsRecordType(
    name: 'CERT',
    description: 'Certificate',
    usesContent: false,
    dataFields: [
      DnsField(
        key: 'type',
        label: 'Type',
        kind: DnsFieldKind.number,
        min: 0,
        max: 65535,
      ),
      DnsField(
        key: 'key_tag',
        label: 'Key tag',
        kind: DnsFieldKind.number,
        min: 0,
        max: 65535,
      ),
      DnsField(
        key: 'algorithm',
        label: 'Algorithm',
        kind: DnsFieldKind.number,
        min: 0,
        max: 255,
      ),
      DnsField(
        key: 'certificate',
        label: 'Certificate',
        kind: DnsFieldKind.multiline,
      ),
    ],
  ),
  DnsRecordType(
    name: 'SMIMEA',
    description: 'S/MIME certificate association',
    usesContent: false,
    dataFields: [
      DnsField(
        key: 'usage',
        label: 'Usage',
        kind: DnsFieldKind.number,
        min: 0,
        max: 3,
      ),
      DnsField(
        key: 'selector',
        label: 'Selector',
        kind: DnsFieldKind.number,
        min: 0,
        max: 1,
      ),
      DnsField(
        key: 'matching_type',
        label: 'Matching type',
        kind: DnsFieldKind.number,
        min: 0,
        max: 2,
      ),
      DnsField(
        key: 'certificate',
        label: 'Certificate',
        kind: DnsFieldKind.multiline,
      ),
    ],
  ),
  DnsRecordType(
    name: 'URI',
    description: 'Redirect target with priority and weight',
    usesContent: false,
    hasPriority: true,
    dataFields: [
      DnsField(
        key: 'weight',
        label: 'Weight',
        kind: DnsFieldKind.number,
        min: 0,
        max: 65535,
      ),
      DnsField(key: 'target', label: 'Target', hint: 'https://example.com'),
    ],
  ),
  DnsRecordType(
    name: 'SVCB',
    description: 'Service binding',
    usesContent: false,
    dataFields: [
      DnsField(
        key: 'priority',
        label: 'Priority',
        kind: DnsFieldKind.number,
        min: 0,
        max: 65535,
      ),
      DnsField(key: 'target', label: 'Target'),
      DnsField(
        key: 'value',
        label: 'Params',
        required: false,
        hint: 'alpn="h2"',
      ),
    ],
  ),
  DnsRecordType(
    name: 'HTTPS',
    description: 'HTTPS service binding',
    usesContent: false,
    dataFields: [
      DnsField(
        key: 'priority',
        label: 'Priority',
        kind: DnsFieldKind.number,
        min: 0,
        max: 65535,
      ),
      DnsField(key: 'target', label: 'Target'),
      DnsField(
        key: 'value',
        label: 'Params',
        required: false,
        hint: 'alpn="h2"',
      ),
    ],
  ),
  DnsRecordType(
    name: 'LOC',
    description: 'Geographic location',
    usesContent: false,
    dataFields: [
      DnsField(
        key: 'lat_degrees',
        label: 'Latitude degrees',
        kind: DnsFieldKind.number,
        min: 0,
        max: 90,
      ),
      DnsField(
        key: 'lat_minutes',
        label: 'Latitude minutes',
        kind: DnsFieldKind.number,
        min: 0,
        max: 59,
      ),
      DnsField(
        key: 'lat_seconds',
        label: 'Latitude seconds',
        kind: DnsFieldKind.number,
        min: 0,
        max: 59,
      ),
      DnsField(
        key: 'lat_direction',
        label: 'Latitude direction',
        hint: 'N or S',
      ),
      DnsField(
        key: 'long_degrees',
        label: 'Longitude degrees',
        kind: DnsFieldKind.number,
        min: 0,
        max: 180,
      ),
      DnsField(
        key: 'long_minutes',
        label: 'Longitude minutes',
        kind: DnsFieldKind.number,
        min: 0,
        max: 59,
      ),
      DnsField(
        key: 'long_seconds',
        label: 'Longitude seconds',
        kind: DnsFieldKind.number,
        min: 0,
        max: 59,
      ),
      DnsField(
        key: 'long_direction',
        label: 'Longitude direction',
        hint: 'E or W',
      ),
      DnsField(
        key: 'altitude',
        label: 'Altitude (m)',
        kind: DnsFieldKind.number,
        required: false,
      ),
      DnsField(
        key: 'size',
        label: 'Size (m)',
        kind: DnsFieldKind.number,
        required: false,
      ),
      DnsField(
        key: 'precision_horz',
        label: 'Horizontal precision',
        kind: DnsFieldKind.number,
        required: false,
      ),
      DnsField(
        key: 'precision_vert',
        label: 'Vertical precision',
        kind: DnsFieldKind.number,
        required: false,
      ),
    ],
  ),
  DnsRecordType(
    name: 'OPENPGPKEY',
    description: 'OpenPGP public key',
    contentHint: 'base64 key material',
  ),
];

DnsRecordType dnsTypeByName(String? name) {
  for (final t in kDnsRecordTypes) {
    if (t.name == name) return t;
  }
  return kDnsRecordTypes.first;
}

/// TTL choices. 1 is Cloudflare's sentinel for "automatic".
const List<int> kTtlChoices = [
  1,
  60,
  120,
  300,
  600,
  1800,
  3600,
  7200,
  43200,
  86400,
];

String ttlLabel(int ttl) => ttl == 1
    ? 'Auto'
    : ttl >= 3600
    ? '${ttl ~/ 3600} h'
    : ttl >= 60
    ? '${ttl ~/ 60} min'
    : '$ttl s';

// GENERATED CODE — DO NOT EDIT BY HAND.
//
// Produced by tool/openapi/generate.dart from spec/openapi.json.
// Re-run `dart run tool/openapi/generate.dart` after changing the spec or
// tool/openapi/allowlist.yaml.

import '../coerce.dart';

class Account {
  const Account({
    this.createdOn,
    this.id,
    this.managedBy,
    this.name,
    this.settings,
    this.type_,
    this.extra = const <String, Object?>{},
  });

  factory Account.fromJson(Map<String, Object?> json) => Account(
    createdOn: asString(json['created_on']),
    id: asString(json['id']),
    managedBy: asModel(json['managed_by'], AccountManagedBy.fromJson),
    name: asString(json['name']),
    settings: asModel(json['settings'], AccountSettings.fromJson),
    type_: json['type'],
    extra: extraOf(json, _knownKeys),
  );

  /// Timestamp for the creation of the account
  final String? createdOn;

  /// Identifier
  final String? id;

  /// Parent container details
  final AccountManagedBy? managedBy;

  /// Account name
  final String? name;

  /// Account settings
  final AccountSettings? settings;

  /// Allowed values: `standard`, `enterprise`.
  final Object? type_;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'created_on',
    'id',
    'managed_by',
    'name',
    'settings',
    'type',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (createdOn != null) 'created_on': createdOn!,
    if (id != null) 'id': id!,
    if (managedBy != null) 'managed_by': managedBy!.toJson(),
    if (name != null) 'name': name!,
    if (settings != null) 'settings': settings!.toJson(),
    if (type_ != null) 'type': type_!,
  };

  Account copyWith({
    String? createdOn,
    String? id,
    AccountManagedBy? managedBy,
    String? name,
    AccountSettings? settings,
    Object? type_,
    Map<String, Object?>? extra,
  }) => Account(
    createdOn: createdOn ?? this.createdOn,
    id: id ?? this.id,
    managedBy: managedBy ?? this.managedBy,
    name: name ?? this.name,
    settings: settings ?? this.settings,
    type_: type_ ?? this.type_,
    extra: extra ?? this.extra,
  );
}

/// Parent container details
class AccountManagedBy {
  const AccountManagedBy({
    this.parentOrgId,
    this.parentOrgName,
    this.extra = const <String, Object?>{},
  });

  factory AccountManagedBy.fromJson(Map<String, Object?> json) =>
      AccountManagedBy(
        parentOrgId: asString(json['parent_org_id']),
        parentOrgName: asString(json['parent_org_name']),
        extra: extraOf(json, _knownKeys),
      );

  /// ID of the parent Organization, if one exists
  final String? parentOrgId;

  /// Name of the parent Organization, if one exists
  final String? parentOrgName;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'parent_org_id', 'parent_org_name'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (parentOrgId != null) 'parent_org_id': parentOrgId!,
    if (parentOrgName != null) 'parent_org_name': parentOrgName!,
  };

  AccountManagedBy copyWith({
    String? parentOrgId,
    String? parentOrgName,
    Map<String, Object?>? extra,
  }) => AccountManagedBy(
    parentOrgId: parentOrgId ?? this.parentOrgId,
    parentOrgName: parentOrgName ?? this.parentOrgName,
    extra: extra ?? this.extra,
  );
}

/// Account settings
class AccountSettings {
  const AccountSettings({
    this.abuseContactEmail,
    this.enforceTwofactor,
    this.extra = const <String, Object?>{},
  });

  factory AccountSettings.fromJson(Map<String, Object?> json) =>
      AccountSettings(
        abuseContactEmail: asString(json['abuse_contact_email']),
        enforceTwofactor: asBool(json['enforce_twofactor']),
        extra: extraOf(json, _knownKeys),
      );

  /// Sets an abuse contact email to notify for abuse reports.
  final String? abuseContactEmail;

  /// Indicates whether membership in this account requires that Two-Factor
  /// Authentication is enabled
  final bool? enforceTwofactor;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'abuse_contact_email',
    'enforce_twofactor',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (abuseContactEmail != null) 'abuse_contact_email': abuseContactEmail!,
    if (enforceTwofactor != null) 'enforce_twofactor': enforceTwofactor!,
  };

  AccountSettings copyWith({
    String? abuseContactEmail,
    bool? enforceTwofactor,
    Map<String, Object?>? extra,
  }) => AccountSettings(
    abuseContactEmail: abuseContactEmail ?? this.abuseContactEmail,
    enforceTwofactor: enforceTwofactor ?? this.enforceTwofactor,
    extra: extra ?? this.extra,
  );
}

class DnsRecordPatch {
  const DnsRecordPatch({
    this.comment,
    this.name,
    this.proxied,
    this.settings,
    this.tags,
    this.ttl,
    this.content,
    this.privateRouting,
    this.type_,
    this.priority,
    this.data,
    this.extra = const <String, Object?>{},
  });

  factory DnsRecordPatch.fromJson(Map<String, Object?> json) => DnsRecordPatch(
    comment: asString(json['comment']),
    name: asString(json['name']),
    proxied: asBool(json['proxied']),
    settings: asModel(json['settings'], Settings.fromJson),
    tags: asPrimitiveList<String>(json['tags'], asString),
    ttl: asNum(json['ttl']),
    content: asString(json['content']),
    privateRouting: asBool(json['private_routing']),
    type_: asString(json['type']),
    priority: asNum(json['priority']),
    data: asModel(json['data'], DnsRecordPatchData.fromJson),
    extra: extraOf(json, _knownKeys),
  );

  /// Comments or notes about the DNS record. This field has no effect on DNS
  /// responses.
  final String? comment;

  /// Complete DNS record name, including the zone name, in Punycode.
  final String? name;

  /// Whether the record is receiving the performance and security benefits of
  /// Cloudflare.
  final bool? proxied;

  /// Settings for the DNS record.
  final Settings? settings;

  /// Custom tags for the DNS record. This field has no effect on DNS responses.
  final List<String>? tags;

  /// Time To Live (TTL) of the DNS record in seconds. Setting to 1 means
  /// 'automatic'. Value must be between 60 and 86400, with the minimum reduced to
  /// 30 for Enterprise zones.
  final num? ttl;

  /// Formatted URI content. See 'data' to set URI properties.
  final String? content;

  /// Enables private network routing to the origin.
  final bool? privateRouting;

  /// Record type. Allowed values: `URI`.
  final String? type_;

  /// Required for MX and URI records; ignored for other record types (but may
  /// still be returned by the API). Records with lower priorities are preferred.
  /// This field is to be deprecated in favor of the priority field within the
  /// data map.
  final num? priority;

  /// Components of a URI record.
  final DnsRecordPatchData? data;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'comment',
    'name',
    'proxied',
    'settings',
    'tags',
    'ttl',
    'content',
    'private_routing',
    'type',
    'priority',
    'data',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (comment != null) 'comment': comment!,
    if (name != null) 'name': name!,
    if (proxied != null) 'proxied': proxied!,
    if (settings != null) 'settings': settings!.toJson(),
    if (tags != null) 'tags': tags!,
    if (ttl != null) 'ttl': ttl!,
    if (content != null) 'content': content!,
    if (privateRouting != null) 'private_routing': privateRouting!,
    if (type_ != null) 'type': type_!,
    if (priority != null) 'priority': priority!,
    if (data != null) 'data': data!.toJson(),
  };

  DnsRecordPatch copyWith({
    String? comment,
    String? name,
    bool? proxied,
    Settings? settings,
    List<String>? tags,
    num? ttl,
    String? content,
    bool? privateRouting,
    String? type_,
    num? priority,
    DnsRecordPatchData? data,
    Map<String, Object?>? extra,
  }) => DnsRecordPatch(
    comment: comment ?? this.comment,
    name: name ?? this.name,
    proxied: proxied ?? this.proxied,
    settings: settings ?? this.settings,
    tags: tags ?? this.tags,
    ttl: ttl ?? this.ttl,
    content: content ?? this.content,
    privateRouting: privateRouting ?? this.privateRouting,
    type_: type_ ?? this.type_,
    priority: priority ?? this.priority,
    data: data ?? this.data,
    extra: extra ?? this.extra,
  );
}

/// Components of a URI record.
class DnsRecordPatchData {
  const DnsRecordPatchData({
    this.target,
    this.weight,
    this.extra = const <String, Object?>{},
  });

  factory DnsRecordPatchData.fromJson(Map<String, Object?> json) =>
      DnsRecordPatchData(
        target: asString(json['target']),
        weight: asNum(json['weight']),
        extra: extraOf(json, _knownKeys),
      );

  /// The record content.
  final String? target;

  /// The record weight.
  final num? weight;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'target', 'weight'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (target != null) 'target': target!,
    if (weight != null) 'weight': weight!,
  };

  DnsRecordPatchData copyWith({
    String? target,
    num? weight,
    Map<String, Object?>? extra,
  }) => DnsRecordPatchData(
    target: target ?? this.target,
    weight: weight ?? this.weight,
    extra: extra ?? this.extra,
  );
}

class DnsRecordPost {
  const DnsRecordPost({
    this.comment,
    this.name,
    this.proxied,
    this.settings,
    this.tags,
    this.ttl,
    this.content,
    this.privateRouting,
    this.type_,
    this.priority,
    this.data,
    this.extra = const <String, Object?>{},
  });

  factory DnsRecordPost.fromJson(Map<String, Object?> json) => DnsRecordPost(
    comment: asString(json['comment']),
    name: asString(json['name']),
    proxied: asBool(json['proxied']),
    settings: asModel(json['settings'], Settings.fromJson),
    tags: asPrimitiveList<String>(json['tags'], asString),
    ttl: asNum(json['ttl']),
    content: asString(json['content']),
    privateRouting: asBool(json['private_routing']),
    type_: asString(json['type']),
    priority: asNum(json['priority']),
    data: asModel(json['data'], DnsRecordPostData.fromJson),
    extra: extraOf(json, _knownKeys),
  );

  /// Comments or notes about the DNS record. This field has no effect on DNS
  /// responses.
  final String? comment;

  /// Complete DNS record name, including the zone name, in Punycode.
  final String? name;

  /// Whether the record is receiving the performance and security benefits of
  /// Cloudflare.
  final bool? proxied;

  /// Settings for the DNS record.
  final Settings? settings;

  /// Custom tags for the DNS record. This field has no effect on DNS responses.
  final List<String>? tags;

  /// Time To Live (TTL) of the DNS record in seconds. Setting to 1 means
  /// 'automatic'. Value must be between 60 and 86400, with the minimum reduced to
  /// 30 for Enterprise zones.
  final num? ttl;

  /// Formatted URI content. See 'data' to set URI properties.
  final String? content;

  /// Enables private network routing to the origin.
  final bool? privateRouting;

  /// Record type. Allowed values: `URI`.
  final String? type_;

  /// Required for MX and URI records; ignored for other record types (but may
  /// still be returned by the API). Records with lower priorities are preferred.
  /// This field is to be deprecated in favor of the priority field within the
  /// data map.
  final num? priority;

  /// Components of a URI record.
  final DnsRecordPostData? data;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'comment',
    'name',
    'proxied',
    'settings',
    'tags',
    'ttl',
    'content',
    'private_routing',
    'type',
    'priority',
    'data',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (comment != null) 'comment': comment!,
    if (name != null) 'name': name!,
    if (proxied != null) 'proxied': proxied!,
    if (settings != null) 'settings': settings!.toJson(),
    if (tags != null) 'tags': tags!,
    if (ttl != null) 'ttl': ttl!,
    if (content != null) 'content': content!,
    if (privateRouting != null) 'private_routing': privateRouting!,
    if (type_ != null) 'type': type_!,
    if (priority != null) 'priority': priority!,
    if (data != null) 'data': data!.toJson(),
  };

  DnsRecordPost copyWith({
    String? comment,
    String? name,
    bool? proxied,
    Settings? settings,
    List<String>? tags,
    num? ttl,
    String? content,
    bool? privateRouting,
    String? type_,
    num? priority,
    DnsRecordPostData? data,
    Map<String, Object?>? extra,
  }) => DnsRecordPost(
    comment: comment ?? this.comment,
    name: name ?? this.name,
    proxied: proxied ?? this.proxied,
    settings: settings ?? this.settings,
    tags: tags ?? this.tags,
    ttl: ttl ?? this.ttl,
    content: content ?? this.content,
    privateRouting: privateRouting ?? this.privateRouting,
    type_: type_ ?? this.type_,
    priority: priority ?? this.priority,
    data: data ?? this.data,
    extra: extra ?? this.extra,
  );
}

/// Components of a URI record.
class DnsRecordPostData {
  const DnsRecordPostData({
    this.target,
    this.weight,
    this.extra = const <String, Object?>{},
  });

  factory DnsRecordPostData.fromJson(Map<String, Object?> json) =>
      DnsRecordPostData(
        target: asString(json['target']),
        weight: asNum(json['weight']),
        extra: extraOf(json, _knownKeys),
      );

  /// The record content.
  final String? target;

  /// The record weight.
  final num? weight;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'target', 'weight'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (target != null) 'target': target!,
    if (weight != null) 'weight': weight!,
  };

  DnsRecordPostData copyWith({
    String? target,
    num? weight,
    Map<String, Object?>? extra,
  }) => DnsRecordPostData(
    target: target ?? this.target,
    weight: weight ?? this.weight,
    extra: extra ?? this.extra,
  );
}

class DnsRecordResponse {
  const DnsRecordResponse({
    this.comment,
    this.name,
    this.proxied,
    this.settings,
    this.tags,
    this.ttl,
    this.content,
    this.privateRouting,
    this.type_,
    this.priority,
    this.data,
    this.commentModifiedOn,
    this.createdOn,
    this.id,
    this.meta,
    this.modifiedOn,
    this.proxiable,
    this.tagsModifiedOn,
    this.extra = const <String, Object?>{},
  });

  factory DnsRecordResponse.fromJson(Map<String, Object?> json) =>
      DnsRecordResponse(
        comment: asString(json['comment']),
        name: asString(json['name']),
        proxied: asBool(json['proxied']),
        settings: asModel(json['settings'], Settings.fromJson),
        tags: asPrimitiveList<String>(json['tags'], asString),
        ttl: asNum(json['ttl']),
        content: asString(json['content']),
        privateRouting: asBool(json['private_routing']),
        type_: asString(json['type']),
        priority: asNum(json['priority']),
        data: asModel(json['data'], DnsRecordResponseData.fromJson),
        commentModifiedOn: asString(json['comment_modified_on']),
        createdOn: asString(json['created_on']),
        id: asString(json['id']),
        meta: asMap(json['meta']),
        modifiedOn: asString(json['modified_on']),
        proxiable: asBool(json['proxiable']),
        tagsModifiedOn: asString(json['tags_modified_on']),
        extra: extraOf(json, _knownKeys),
      );

  /// Comments or notes about the DNS record. This field has no effect on DNS
  /// responses.
  final String? comment;

  /// Complete DNS record name, including the zone name, in Punycode.
  final String? name;

  /// Whether the record is receiving the performance and security benefits of
  /// Cloudflare.
  final bool? proxied;

  /// Settings for the DNS record.
  final Settings? settings;

  /// Custom tags for the DNS record. This field has no effect on DNS responses.
  final List<String>? tags;

  /// Time To Live (TTL) of the DNS record in seconds. Setting to 1 means
  /// 'automatic'. Value must be between 60 and 86400, with the minimum reduced to
  /// 30 for Enterprise zones.
  final num? ttl;

  /// Formatted URI content. See 'data' to set URI properties.
  final String? content;

  /// Enables private network routing to the origin.
  final bool? privateRouting;

  /// Record type. Allowed values: `URI`.
  final String? type_;

  /// Required for MX and URI records; ignored for other record types (but may
  /// still be returned by the API). Records with lower priorities are preferred.
  /// This field is to be deprecated in favor of the priority field within the
  /// data map.
  final num? priority;

  /// Components of a URI record.
  final DnsRecordResponseData? data;

  /// When the record comment was last modified. Omitted if there is no comment.
  final String? commentModifiedOn;

  /// When the record was created.
  final String? createdOn;

  /// Identifier.
  final String? id;

  /// Extra Cloudflare-specific information about the record.
  final Map<String, Object?>? meta;

  /// When the record was last modified.
  final String? modifiedOn;

  /// Whether the record can be proxied by Cloudflare or not.
  final bool? proxiable;

  /// When the record tags were last modified. Omitted if there are no tags.
  final String? tagsModifiedOn;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'comment',
    'name',
    'proxied',
    'settings',
    'tags',
    'ttl',
    'content',
    'private_routing',
    'type',
    'priority',
    'data',
    'comment_modified_on',
    'created_on',
    'id',
    'meta',
    'modified_on',
    'proxiable',
    'tags_modified_on',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (comment != null) 'comment': comment!,
    if (name != null) 'name': name!,
    if (proxied != null) 'proxied': proxied!,
    if (settings != null) 'settings': settings!.toJson(),
    if (tags != null) 'tags': tags!,
    if (ttl != null) 'ttl': ttl!,
    if (content != null) 'content': content!,
    if (privateRouting != null) 'private_routing': privateRouting!,
    if (type_ != null) 'type': type_!,
    if (priority != null) 'priority': priority!,
    if (data != null) 'data': data!.toJson(),
    if (commentModifiedOn != null) 'comment_modified_on': commentModifiedOn!,
    if (createdOn != null) 'created_on': createdOn!,
    if (id != null) 'id': id!,
    if (meta != null) 'meta': meta!,
    if (modifiedOn != null) 'modified_on': modifiedOn!,
    if (proxiable != null) 'proxiable': proxiable!,
    if (tagsModifiedOn != null) 'tags_modified_on': tagsModifiedOn!,
  };

  DnsRecordResponse copyWith({
    String? comment,
    String? name,
    bool? proxied,
    Settings? settings,
    List<String>? tags,
    num? ttl,
    String? content,
    bool? privateRouting,
    String? type_,
    num? priority,
    DnsRecordResponseData? data,
    String? commentModifiedOn,
    String? createdOn,
    String? id,
    Map<String, Object?>? meta,
    String? modifiedOn,
    bool? proxiable,
    String? tagsModifiedOn,
    Map<String, Object?>? extra,
  }) => DnsRecordResponse(
    comment: comment ?? this.comment,
    name: name ?? this.name,
    proxied: proxied ?? this.proxied,
    settings: settings ?? this.settings,
    tags: tags ?? this.tags,
    ttl: ttl ?? this.ttl,
    content: content ?? this.content,
    privateRouting: privateRouting ?? this.privateRouting,
    type_: type_ ?? this.type_,
    priority: priority ?? this.priority,
    data: data ?? this.data,
    commentModifiedOn: commentModifiedOn ?? this.commentModifiedOn,
    createdOn: createdOn ?? this.createdOn,
    id: id ?? this.id,
    meta: meta ?? this.meta,
    modifiedOn: modifiedOn ?? this.modifiedOn,
    proxiable: proxiable ?? this.proxiable,
    tagsModifiedOn: tagsModifiedOn ?? this.tagsModifiedOn,
    extra: extra ?? this.extra,
  );
}

/// Components of a URI record.
class DnsRecordResponseData {
  const DnsRecordResponseData({
    this.target,
    this.weight,
    this.extra = const <String, Object?>{},
  });

  factory DnsRecordResponseData.fromJson(Map<String, Object?> json) =>
      DnsRecordResponseData(
        target: asString(json['target']),
        weight: asNum(json['weight']),
        extra: extraOf(json, _knownKeys),
      );

  /// The record content.
  final String? target;

  /// The record weight.
  final num? weight;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'target', 'weight'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (target != null) 'target': target!,
    if (weight != null) 'weight': weight!,
  };

  DnsRecordResponseData copyWith({
    String? target,
    num? weight,
    Map<String, Object?>? extra,
  }) => DnsRecordResponseData(
    target: target ?? this.target,
    weight: weight ?? this.weight,
    extra: extra ?? this.extra,
  );
}

class DnsRecordsForAZoneImportDnsRecordsResult {
  const DnsRecordsForAZoneImportDnsRecordsResult({
    this.recsAdded,
    this.totalRecordsParsed,
    this.extra = const <String, Object?>{},
  });

  factory DnsRecordsForAZoneImportDnsRecordsResult.fromJson(
    Map<String, Object?> json,
  ) => DnsRecordsForAZoneImportDnsRecordsResult(
    recsAdded: asNum(json['recs_added']),
    totalRecordsParsed: asNum(json['total_records_parsed']),
    extra: extraOf(json, _knownKeys),
  );

  /// Number of DNS records added.
  final num? recsAdded;

  /// Total number of DNS records parsed.
  final num? totalRecordsParsed;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'recs_added', 'total_records_parsed'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (recsAdded != null) 'recs_added': recsAdded!,
    if (totalRecordsParsed != null) 'total_records_parsed': totalRecordsParsed!,
  };

  DnsRecordsForAZoneImportDnsRecordsResult copyWith({
    num? recsAdded,
    num? totalRecordsParsed,
    Map<String, Object?>? extra,
  }) => DnsRecordsForAZoneImportDnsRecordsResult(
    recsAdded: recsAdded ?? this.recsAdded,
    totalRecordsParsed: totalRecordsParsed ?? this.totalRecordsParsed,
    extra: extra ?? this.extra,
  );
}

class Organization {
  const Organization({
    this.id,
    this.name,
    this.permissions,
    this.roles,
    this.status,
    this.extra = const <String, Object?>{},
  });

  factory Organization.fromJson(Map<String, Object?> json) => Organization(
    id: asString(json['id']),
    name: asString(json['name']),
    permissions: asPrimitiveList<String>(json['permissions'], asString),
    roles: asPrimitiveList<String>(json['roles'], asString),
    status: asString(json['status']),
    extra: extraOf(json, _knownKeys),
  );

  /// Identifier
  final String? id;

  /// Organization name.
  final String? name;

  /// Access permissions for this User.
  final List<String>? permissions;

  /// List of roles that a user has within an organization.
  final List<String>? roles;

  /// Whether the user is a member of the organization or has an invitation
  /// pending. Allowed values: `member`, `invited`.
  final String? status;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'id',
    'name',
    'permissions',
    'roles',
    'status',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (id != null) 'id': id!,
    if (name != null) 'name': name!,
    if (permissions != null) 'permissions': permissions!,
    if (roles != null) 'roles': roles!,
    if (status != null) 'status': status!,
  };

  Organization copyWith({
    String? id,
    String? name,
    List<String>? permissions,
    List<String>? roles,
    String? status,
    Map<String, Object?>? extra,
  }) => Organization(
    id: id ?? this.id,
    name: name ?? this.name,
    permissions: permissions ?? this.permissions,
    roles: roles ?? this.roles,
    status: status ?? this.status,
    extra: extra ?? this.extra,
  );
}

class PermissionGroupsListPermissionGroupsItem {
  const PermissionGroupsListPermissionGroupsItem({
    this.id,
    this.name,
    this.scopes,
    this.extra = const <String, Object?>{},
  });

  factory PermissionGroupsListPermissionGroupsItem.fromJson(
    Map<String, Object?> json,
  ) => PermissionGroupsListPermissionGroupsItem(
    id: asString(json['id']),
    name: asString(json['name']),
    scopes: asPrimitiveList<String>(json['scopes'], asString),
    extra: extraOf(json, _knownKeys),
  );

  /// Public ID.
  final String? id;

  /// Permission Group Name
  final String? name;

  /// Resources to which the Permission Group is scoped
  final List<String>? scopes;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'id', 'name', 'scopes'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (id != null) 'id': id!,
    if (name != null) 'name': name!,
    if (scopes != null) 'scopes': scopes!,
  };

  PermissionGroupsListPermissionGroupsItem copyWith({
    String? id,
    String? name,
    List<String>? scopes,
    Map<String, Object?>? extra,
  }) => PermissionGroupsListPermissionGroupsItem(
    id: id ?? this.id,
    name: name ?? this.name,
    scopes: scopes ?? this.scopes,
    extra: extra ?? this.extra,
  );
}

class Setting {
  const Setting({
    this.editable,
    this.id,
    this.modifiedOn,
    this.value,
    this.timeRemaining,
    this.enabled,
    this.extra = const <String, Object?>{},
  });

  factory Setting.fromJson(Map<String, Object?> json) => Setting(
    editable: asBool(json['editable']),
    id: json['id'],
    modifiedOn: asString(json['modified_on']),
    value: asString(json['value']),
    timeRemaining: asNum(json['time_remaining']),
    enabled: asBool(json['enabled']),
    extra: extraOf(json, _knownKeys),
  );

  /// Whether or not this setting can be modified for this zone (based on your
  /// Cloudflare plan level). Allowed values: `true`, `false`.
  final bool? editable;

  /// ID of the zone setting. Allowed values: `websockets`.
  final Object? id;

  /// last time this setting was modified.
  final String? modifiedOn;

  /// Value of the zone setting. Allowed values: `off`, `on`.
  final String? value;

  /// Value of the zone setting. Notes: The interval (in seconds) from when
  /// development mode expires (positive integer) or last expired (negative
  /// integer) for the domain. If development mode has never been enabled, this
  /// value is false.
  final num? timeRemaining;

  /// ssl-recommender enrollment setting.
  final bool? enabled;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'editable',
    'id',
    'modified_on',
    'value',
    'time_remaining',
    'enabled',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (editable != null) 'editable': editable!,
    if (id != null) 'id': id!,
    if (modifiedOn != null) 'modified_on': modifiedOn!,
    if (value != null) 'value': value!,
    if (timeRemaining != null) 'time_remaining': timeRemaining!,
    if (enabled != null) 'enabled': enabled!,
  };

  Setting copyWith({
    bool? editable,
    Object? id,
    String? modifiedOn,
    String? value,
    num? timeRemaining,
    bool? enabled,
    Map<String, Object?>? extra,
  }) => Setting(
    editable: editable ?? this.editable,
    id: id ?? this.id,
    modifiedOn: modifiedOn ?? this.modifiedOn,
    value: value ?? this.value,
    timeRemaining: timeRemaining ?? this.timeRemaining,
    enabled: enabled ?? this.enabled,
    extra: extra ?? this.extra,
  );
}

class SettingValue {
  const SettingValue({
    this.enabled,
    this.poolId,
    this.cacheByDeviceType,
    this.cf,
    this.hostnames,
    this.wordpress,
    this.wpPlugin,
    this.strictTransportSecurity,
    this.extra = const <String, Object?>{},
  });

  factory SettingValue.fromJson(Map<String, Object?> json) => SettingValue(
    enabled: asBool(json['enabled']),
    poolId: asString(json['pool_id']),
    cacheByDeviceType: asBool(json['cache_by_device_type']),
    cf: asBool(json['cf']),
    hostnames: asPrimitiveList<String>(json['hostnames'], asString),
    wordpress: asBool(json['wordpress']),
    wpPlugin: asBool(json['wp_plugin']),
    strictTransportSecurity: asModel(
      json['strict_transport_security'],
      SettingValueStrictTransportSecurity.fromJson,
    ),
    extra: extraOf(json, _knownKeys),
  );

  /// Indicates whether or not Automatic Platform Optimization is enabled.
  final bool? enabled;

  /// Egress pool id which refers to a grouping of dedicated egress IPs through
  /// which Cloudflare will connect to origin.
  final String? poolId;

  /// Indicates whether or not [cache by device
  /// type](https://developers.cloudflare.com/automatic-platform-optimization/reference/cache-device-type/)
  /// is enabled.
  final bool? cacheByDeviceType;

  /// Indicates whether or not Cloudflare proxy is enabled.
  final bool? cf;

  /// An array of hostnames where Automatic Platform Optimization for WordPress is
  /// activated.
  final List<String>? hostnames;

  /// Indicates whether or not site is powered by WordPress.
  final bool? wordpress;

  /// Indicates whether or not [Cloudflare for WordPress
  /// plugin](https://wordpress.org/plugins/cloudflare/) is installed.
  final bool? wpPlugin;

  /// Strict Transport Security.
  final SettingValueStrictTransportSecurity? strictTransportSecurity;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'enabled',
    'pool_id',
    'cache_by_device_type',
    'cf',
    'hostnames',
    'wordpress',
    'wp_plugin',
    'strict_transport_security',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (enabled != null) 'enabled': enabled!,
    if (poolId != null) 'pool_id': poolId!,
    if (cacheByDeviceType != null) 'cache_by_device_type': cacheByDeviceType!,
    if (cf != null) 'cf': cf!,
    if (hostnames != null) 'hostnames': hostnames!,
    if (wordpress != null) 'wordpress': wordpress!,
    if (wpPlugin != null) 'wp_plugin': wpPlugin!,
    if (strictTransportSecurity != null)
      'strict_transport_security': strictTransportSecurity!.toJson(),
  };

  SettingValue copyWith({
    bool? enabled,
    String? poolId,
    bool? cacheByDeviceType,
    bool? cf,
    List<String>? hostnames,
    bool? wordpress,
    bool? wpPlugin,
    SettingValueStrictTransportSecurity? strictTransportSecurity,
    Map<String, Object?>? extra,
  }) => SettingValue(
    enabled: enabled ?? this.enabled,
    poolId: poolId ?? this.poolId,
    cacheByDeviceType: cacheByDeviceType ?? this.cacheByDeviceType,
    cf: cf ?? this.cf,
    hostnames: hostnames ?? this.hostnames,
    wordpress: wordpress ?? this.wordpress,
    wpPlugin: wpPlugin ?? this.wpPlugin,
    strictTransportSecurity:
        strictTransportSecurity ?? this.strictTransportSecurity,
    extra: extra ?? this.extra,
  );
}

/// Strict Transport Security.
class SettingValueStrictTransportSecurity {
  const SettingValueStrictTransportSecurity({
    this.enabled,
    this.includeSubdomains,
    this.maxAge,
    this.nosniff,
    this.preload,
    this.extra = const <String, Object?>{},
  });

  factory SettingValueStrictTransportSecurity.fromJson(
    Map<String, Object?> json,
  ) => SettingValueStrictTransportSecurity(
    enabled: asBool(json['enabled']),
    includeSubdomains: asBool(json['include_subdomains']),
    maxAge: asNum(json['max_age']),
    nosniff: asBool(json['nosniff']),
    preload: asBool(json['preload']),
    extra: extraOf(json, _knownKeys),
  );

  /// Whether or not strict transport security is enabled.
  final bool? enabled;

  /// Include all subdomains for strict transport security.
  final bool? includeSubdomains;

  /// Max age in seconds of the strict transport security.
  final num? maxAge;

  /// Whether or not to include 'X-Content-Type-Options: nosniff' header.
  final bool? nosniff;

  /// Enable automatic preload of the HSTS configuration.
  final bool? preload;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'enabled',
    'include_subdomains',
    'max_age',
    'nosniff',
    'preload',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (enabled != null) 'enabled': enabled!,
    if (includeSubdomains != null) 'include_subdomains': includeSubdomains!,
    if (maxAge != null) 'max_age': maxAge!,
    if (nosniff != null) 'nosniff': nosniff!,
    if (preload != null) 'preload': preload!,
  };

  SettingValueStrictTransportSecurity copyWith({
    bool? enabled,
    bool? includeSubdomains,
    num? maxAge,
    bool? nosniff,
    bool? preload,
    Map<String, Object?>? extra,
  }) => SettingValueStrictTransportSecurity(
    enabled: enabled ?? this.enabled,
    includeSubdomains: includeSubdomains ?? this.includeSubdomains,
    maxAge: maxAge ?? this.maxAge,
    nosniff: nosniff ?? this.nosniff,
    preload: preload ?? this.preload,
    extra: extra ?? this.extra,
  );
}

/// Settings for the DNS record.
class Settings {
  const Settings({
    this.ipv4Only,
    this.ipv6Only,
    this.extra = const <String, Object?>{},
  });

  factory Settings.fromJson(Map<String, Object?> json) => Settings(
    ipv4Only: asBool(json['ipv4_only']),
    ipv6Only: asBool(json['ipv6_only']),
    extra: extraOf(json, _knownKeys),
  );

  /// When enabled, only A records will be generated, and AAAA records will not be
  /// created. This setting is intended for exceptional cases. Note that this
  /// option only applies to proxied records and it has no effect on whether
  /// Cloudflare communicates with the origin using IPv4 or IPv6.
  final bool? ipv4Only;

  /// When enabled, only AAAA records will be generated, and A records will not be
  /// created. This setting is intended for exceptional cases. Note that this
  /// option only applies to proxied records and it has no effect on whether
  /// Cloudflare communicates with the origin using IPv4 or IPv6.
  final bool? ipv6Only;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'ipv4_only', 'ipv6_only'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (ipv4Only != null) 'ipv4_only': ipv4Only!,
    if (ipv6Only != null) 'ipv6_only': ipv6Only!,
  };

  Settings copyWith({
    bool? ipv4Only,
    bool? ipv6Only,
    Map<String, Object?>? extra,
  }) => Settings(
    ipv4Only: ipv4Only ?? this.ipv4Only,
    ipv6Only: ipv6Only ?? this.ipv6Only,
    extra: extra ?? this.extra,
  );
}

class UserApiTokensVerifyTokenResult {
  const UserApiTokensVerifyTokenResult({
    this.expiresOn,
    this.id,
    this.notBefore,
    this.status,
    this.extra = const <String, Object?>{},
  });

  factory UserApiTokensVerifyTokenResult.fromJson(Map<String, Object?> json) =>
      UserApiTokensVerifyTokenResult(
        expiresOn: asString(json['expires_on']),
        id: asString(json['id']),
        notBefore: asString(json['not_before']),
        status: asString(json['status']),
        extra: extraOf(json, _knownKeys),
      );

  /// The expiration time on or after which the JWT MUST NOT be accepted for
  /// processing.
  final String? expiresOn;

  /// Token identifier tag.
  final String? id;

  /// The time before which the token MUST NOT be accepted for processing.
  final String? notBefore;

  /// Status of the token. Allowed values: `active`, `disabled`, `expired`.
  final String? status;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'expires_on',
    'id',
    'not_before',
    'status',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (expiresOn != null) 'expires_on': expiresOn!,
    if (id != null) 'id': id!,
    if (notBefore != null) 'not_before': notBefore!,
    if (status != null) 'status': status!,
  };

  UserApiTokensVerifyTokenResult copyWith({
    String? expiresOn,
    String? id,
    String? notBefore,
    String? status,
    Map<String, Object?>? extra,
  }) => UserApiTokensVerifyTokenResult(
    expiresOn: expiresOn ?? this.expiresOn,
    id: id ?? this.id,
    notBefore: notBefore ?? this.notBefore,
    status: status ?? this.status,
    extra: extra ?? this.extra,
  );
}

class UserUserDetailsResult {
  const UserUserDetailsResult({
    this.betas,
    this.country,
    this.firstName,
    this.hasBusinessZones,
    this.hasEnterpriseZones,
    this.hasProZones,
    this.id,
    this.lastName,
    this.organizations,
    this.suspended,
    this.telephone,
    this.twoFactorAuthenticationEnabled,
    this.twoFactorAuthenticationLocked,
    this.zipcode,
    this.extra = const <String, Object?>{},
  });

  factory UserUserDetailsResult.fromJson(Map<String, Object?> json) =>
      UserUserDetailsResult(
        betas: asPrimitiveList<String>(json['betas'], asString),
        country: asString(json['country']),
        firstName: asString(json['first_name']),
        hasBusinessZones: asBool(json['has_business_zones']),
        hasEnterpriseZones: asBool(json['has_enterprise_zones']),
        hasProZones: asBool(json['has_pro_zones']),
        id: asString(json['id']),
        lastName: asString(json['last_name']),
        organizations: asModelList(
          json['organizations'],
          Organization.fromJson,
        ),
        suspended: asBool(json['suspended']),
        telephone: asString(json['telephone']),
        twoFactorAuthenticationEnabled: asBool(
          json['two_factor_authentication_enabled'],
        ),
        twoFactorAuthenticationLocked: asBool(
          json['two_factor_authentication_locked'],
        ),
        zipcode: asString(json['zipcode']),
        extra: extraOf(json, _knownKeys),
      );

  /// Lists the betas that the user is participating in.
  final List<String>? betas;

  /// The country in which the user lives.
  final String? country;

  /// User's first name
  final String? firstName;

  /// Indicates whether user has any business zones
  final bool? hasBusinessZones;

  /// Indicates whether user has any enterprise zones
  final bool? hasEnterpriseZones;

  /// Indicates whether user has any pro zones
  final bool? hasProZones;

  /// Identifier of the user.
  final String? id;

  /// User's last name
  final String? lastName;
  final List<Organization>? organizations;

  /// Indicates whether user has been suspended
  final bool? suspended;

  /// User's telephone number
  final String? telephone;

  /// Indicates whether two-factor authentication is enabled for the user account.
  /// Does not apply to API authentication.
  final bool? twoFactorAuthenticationEnabled;

  /// Indicates whether two-factor authentication is required by one of the
  /// accounts that the user is a member of.
  final bool? twoFactorAuthenticationLocked;

  /// The zipcode or postal code where the user lives.
  final String? zipcode;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'betas',
    'country',
    'first_name',
    'has_business_zones',
    'has_enterprise_zones',
    'has_pro_zones',
    'id',
    'last_name',
    'organizations',
    'suspended',
    'telephone',
    'two_factor_authentication_enabled',
    'two_factor_authentication_locked',
    'zipcode',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (betas != null) 'betas': betas!,
    if (country != null) 'country': country!,
    if (firstName != null) 'first_name': firstName!,
    if (hasBusinessZones != null) 'has_business_zones': hasBusinessZones!,
    if (hasEnterpriseZones != null) 'has_enterprise_zones': hasEnterpriseZones!,
    if (hasProZones != null) 'has_pro_zones': hasProZones!,
    if (id != null) 'id': id!,
    if (lastName != null) 'last_name': lastName!,
    if (organizations != null)
      'organizations': organizations!.map((e) => e.toJson()).toList(),
    if (suspended != null) 'suspended': suspended!,
    if (telephone != null) 'telephone': telephone!,
    if (twoFactorAuthenticationEnabled != null)
      'two_factor_authentication_enabled': twoFactorAuthenticationEnabled!,
    if (twoFactorAuthenticationLocked != null)
      'two_factor_authentication_locked': twoFactorAuthenticationLocked!,
    if (zipcode != null) 'zipcode': zipcode!,
  };

  UserUserDetailsResult copyWith({
    List<String>? betas,
    String? country,
    String? firstName,
    bool? hasBusinessZones,
    bool? hasEnterpriseZones,
    bool? hasProZones,
    String? id,
    String? lastName,
    List<Organization>? organizations,
    bool? suspended,
    String? telephone,
    bool? twoFactorAuthenticationEnabled,
    bool? twoFactorAuthenticationLocked,
    String? zipcode,
    Map<String, Object?>? extra,
  }) => UserUserDetailsResult(
    betas: betas ?? this.betas,
    country: country ?? this.country,
    firstName: firstName ?? this.firstName,
    hasBusinessZones: hasBusinessZones ?? this.hasBusinessZones,
    hasEnterpriseZones: hasEnterpriseZones ?? this.hasEnterpriseZones,
    hasProZones: hasProZones ?? this.hasProZones,
    id: id ?? this.id,
    lastName: lastName ?? this.lastName,
    organizations: organizations ?? this.organizations,
    suspended: suspended ?? this.suspended,
    telephone: telephone ?? this.telephone,
    twoFactorAuthenticationEnabled:
        twoFactorAuthenticationEnabled ?? this.twoFactorAuthenticationEnabled,
    twoFactorAuthenticationLocked:
        twoFactorAuthenticationLocked ?? this.twoFactorAuthenticationLocked,
    zipcode: zipcode ?? this.zipcode,
    extra: extra ?? this.extra,
  );
}

class Zone {
  const Zone({
    this.account,
    this.activatedOn,
    this.cnameSuffix,
    this.createdOn,
    this.developmentMode,
    this.id,
    this.meta,
    this.modifiedOn,
    this.name,
    this.nameServers,
    this.originalDnshost,
    this.originalNameServers,
    this.originalRegistrar,
    this.owner,
    this.paused,
    this.permissions,
    this.plan,
    this.status,
    this.tenant,
    this.tenantUnit,
    this.type_,
    this.vanityNameServers,
    this.verificationKey,
    this.extra = const <String, Object?>{},
  });

  factory Zone.fromJson(Map<String, Object?> json) => Zone(
    account: asModel(json['account'], ZoneAccount.fromJson),
    activatedOn: asString(json['activated_on']),
    cnameSuffix: asString(json['cname_suffix']),
    createdOn: asString(json['created_on']),
    developmentMode: asNum(json['development_mode']),
    id: asString(json['id']),
    meta: asModel(json['meta'], ZoneMeta.fromJson),
    modifiedOn: asString(json['modified_on']),
    name: asString(json['name']),
    nameServers: asPrimitiveList<String>(json['name_servers'], asString),
    originalDnshost: asString(json['original_dnshost']),
    originalNameServers: asPrimitiveList<String>(
      json['original_name_servers'],
      asString,
    ),
    originalRegistrar: asString(json['original_registrar']),
    owner: asModel(json['owner'], ZoneOwner.fromJson),
    paused: asBool(json['paused']),
    permissions: asPrimitiveList<String>(json['permissions'], asString),
    plan: asModel(json['plan'], ZonePlan.fromJson),
    status: asString(json['status']),
    tenant: asModel(json['tenant'], ZoneTenant.fromJson),
    tenantUnit: asModel(json['tenant_unit'], ZoneTenantUnit.fromJson),
    type_: asString(json['type']),
    vanityNameServers: asPrimitiveList<String>(
      json['vanity_name_servers'],
      asString,
    ),
    verificationKey: asString(json['verification_key']),
    extra: extraOf(json, _knownKeys),
  );

  /// The account the zone belongs to.
  final ZoneAccount? account;

  /// The last time proof of ownership was detected and the zone was made active.
  final String? activatedOn;

  /// Allows the customer to use a custom apex. *Tenants Only Configuration*.
  final String? cnameSuffix;

  /// When the zone was created.
  final String? createdOn;

  /// The interval (in seconds) from when development mode expires (positive
  /// integer) or last expired (negative integer) for the domain. If development
  /// mode has never been enabled, this value is 0.
  final num? developmentMode;

  /// Identifier
  final String? id;

  /// Metadata about the zone.
  final ZoneMeta? meta;

  /// When the zone was last modified.
  final String? modifiedOn;

  /// The domain name. Per [RFC
  /// 1035](https://datatracker.ietf.org/doc/html/rfc1035#section-2.3.4) the
  /// overall zone name can be up to 253 characters, with each segment ("label")
  /// not exceeding 63 characters.
  final String? name;

  /// The name servers Cloudflare assigns to a zone.
  final List<String>? nameServers;

  /// DNS host at the time of switching to Cloudflare.
  final String? originalDnshost;

  /// Original name servers before moving to Cloudflare.
  final List<String>? originalNameServers;

  /// Registrar for the domain at the time of switching to Cloudflare.
  final String? originalRegistrar;

  /// The owner of the zone.
  final ZoneOwner? owner;

  /// Indicates whether the zone is only using Cloudflare DNS services. A true
  /// value means the zone will not receive security or performance benefits.
  final bool? paused;

  /// Legacy permissions based on legacy user membership information.
  final List<String>? permissions;

  /// A Zones subscription information.
  final ZonePlan? plan;

  /// The zone status on Cloudflare. Allowed values: `initializing`, `pending`,
  /// `active`, `moved`.
  final String? status;

  /// The root organizational unit that this zone belongs to (such as a tenant or
  /// organization).
  final ZoneTenant? tenant;

  /// The immediate parent organizational unit that this zone belongs to (such as
  /// under a tenant or sub-organization).
  final ZoneTenantUnit? tenantUnit;

  /// A full zone implies that DNS is hosted with Cloudflare. A partial zone is
  /// typically a partner-hosted zone or a CNAME setup. Allowed values: `full`,
  /// `partial`, `secondary`, `internal`.
  final String? type_;

  /// An array of domains used for custom name servers. This is only available for
  /// Business and Enterprise plans.
  final List<String>? vanityNameServers;

  /// Verification key for partial zone setup.
  final String? verificationKey;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'account',
    'activated_on',
    'cname_suffix',
    'created_on',
    'development_mode',
    'id',
    'meta',
    'modified_on',
    'name',
    'name_servers',
    'original_dnshost',
    'original_name_servers',
    'original_registrar',
    'owner',
    'paused',
    'permissions',
    'plan',
    'status',
    'tenant',
    'tenant_unit',
    'type',
    'vanity_name_servers',
    'verification_key',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (account != null) 'account': account!.toJson(),
    if (activatedOn != null) 'activated_on': activatedOn!,
    if (cnameSuffix != null) 'cname_suffix': cnameSuffix!,
    if (createdOn != null) 'created_on': createdOn!,
    if (developmentMode != null) 'development_mode': developmentMode!,
    if (id != null) 'id': id!,
    if (meta != null) 'meta': meta!.toJson(),
    if (modifiedOn != null) 'modified_on': modifiedOn!,
    if (name != null) 'name': name!,
    if (nameServers != null) 'name_servers': nameServers!,
    if (originalDnshost != null) 'original_dnshost': originalDnshost!,
    if (originalNameServers != null)
      'original_name_servers': originalNameServers!,
    if (originalRegistrar != null) 'original_registrar': originalRegistrar!,
    if (owner != null) 'owner': owner!.toJson(),
    if (paused != null) 'paused': paused!,
    if (permissions != null) 'permissions': permissions!,
    if (plan != null) 'plan': plan!.toJson(),
    if (status != null) 'status': status!,
    if (tenant != null) 'tenant': tenant!.toJson(),
    if (tenantUnit != null) 'tenant_unit': tenantUnit!.toJson(),
    if (type_ != null) 'type': type_!,
    if (vanityNameServers != null) 'vanity_name_servers': vanityNameServers!,
    if (verificationKey != null) 'verification_key': verificationKey!,
  };

  Zone copyWith({
    ZoneAccount? account,
    String? activatedOn,
    String? cnameSuffix,
    String? createdOn,
    num? developmentMode,
    String? id,
    ZoneMeta? meta,
    String? modifiedOn,
    String? name,
    List<String>? nameServers,
    String? originalDnshost,
    List<String>? originalNameServers,
    String? originalRegistrar,
    ZoneOwner? owner,
    bool? paused,
    List<String>? permissions,
    ZonePlan? plan,
    String? status,
    ZoneTenant? tenant,
    ZoneTenantUnit? tenantUnit,
    String? type_,
    List<String>? vanityNameServers,
    String? verificationKey,
    Map<String, Object?>? extra,
  }) => Zone(
    account: account ?? this.account,
    activatedOn: activatedOn ?? this.activatedOn,
    cnameSuffix: cnameSuffix ?? this.cnameSuffix,
    createdOn: createdOn ?? this.createdOn,
    developmentMode: developmentMode ?? this.developmentMode,
    id: id ?? this.id,
    meta: meta ?? this.meta,
    modifiedOn: modifiedOn ?? this.modifiedOn,
    name: name ?? this.name,
    nameServers: nameServers ?? this.nameServers,
    originalDnshost: originalDnshost ?? this.originalDnshost,
    originalNameServers: originalNameServers ?? this.originalNameServers,
    originalRegistrar: originalRegistrar ?? this.originalRegistrar,
    owner: owner ?? this.owner,
    paused: paused ?? this.paused,
    permissions: permissions ?? this.permissions,
    plan: plan ?? this.plan,
    status: status ?? this.status,
    tenant: tenant ?? this.tenant,
    tenantUnit: tenantUnit ?? this.tenantUnit,
    type_: type_ ?? this.type_,
    vanityNameServers: vanityNameServers ?? this.vanityNameServers,
    verificationKey: verificationKey ?? this.verificationKey,
    extra: extra ?? this.extra,
  );
}

/// The account the zone belongs to.
class ZoneAccount {
  const ZoneAccount({
    this.id,
    this.name,
    this.extra = const <String, Object?>{},
  });

  factory ZoneAccount.fromJson(Map<String, Object?> json) => ZoneAccount(
    id: asString(json['id']),
    name: asString(json['name']),
    extra: extraOf(json, _knownKeys),
  );

  /// Identifier
  final String? id;

  /// The name of the account.
  final String? name;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'id', 'name'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (id != null) 'id': id!,
    if (name != null) 'name': name!,
  };

  ZoneAccount copyWith({
    String? id,
    String? name,
    Map<String, Object?>? extra,
  }) => ZoneAccount(
    id: id ?? this.id,
    name: name ?? this.name,
    extra: extra ?? this.extra,
  );
}

/// Metadata about the zone.
class ZoneMeta {
  const ZoneMeta({
    this.cdnOnly,
    this.customCertificateQuota,
    this.dnsOnly,
    this.foundationDns,
    this.pageRuleQuota,
    this.phishingDetected,
    this.step,
    this.extra = const <String, Object?>{},
  });

  factory ZoneMeta.fromJson(Map<String, Object?> json) => ZoneMeta(
    cdnOnly: asBool(json['cdn_only']),
    customCertificateQuota: asInt(json['custom_certificate_quota']),
    dnsOnly: asBool(json['dns_only']),
    foundationDns: asBool(json['foundation_dns']),
    pageRuleQuota: asInt(json['page_rule_quota']),
    phishingDetected: asBool(json['phishing_detected']),
    step: asInt(json['step']),
    extra: extraOf(json, _knownKeys),
  );

  /// The zone is only configured for CDN.
  final bool? cdnOnly;

  /// Number of Custom Certificates the zone can have.
  final int? customCertificateQuota;

  /// The zone is only configured for DNS.
  final bool? dnsOnly;

  /// The zone is setup with Foundation DNS.
  final bool? foundationDns;

  /// Number of Page Rules a zone can have.
  final int? pageRuleQuota;

  /// The zone has been flagged for phishing.
  final bool? phishingDetected;
  final int? step;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'cdn_only',
    'custom_certificate_quota',
    'dns_only',
    'foundation_dns',
    'page_rule_quota',
    'phishing_detected',
    'step',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (cdnOnly != null) 'cdn_only': cdnOnly!,
    if (customCertificateQuota != null)
      'custom_certificate_quota': customCertificateQuota!,
    if (dnsOnly != null) 'dns_only': dnsOnly!,
    if (foundationDns != null) 'foundation_dns': foundationDns!,
    if (pageRuleQuota != null) 'page_rule_quota': pageRuleQuota!,
    if (phishingDetected != null) 'phishing_detected': phishingDetected!,
    if (step != null) 'step': step!,
  };

  ZoneMeta copyWith({
    bool? cdnOnly,
    int? customCertificateQuota,
    bool? dnsOnly,
    bool? foundationDns,
    int? pageRuleQuota,
    bool? phishingDetected,
    int? step,
    Map<String, Object?>? extra,
  }) => ZoneMeta(
    cdnOnly: cdnOnly ?? this.cdnOnly,
    customCertificateQuota:
        customCertificateQuota ?? this.customCertificateQuota,
    dnsOnly: dnsOnly ?? this.dnsOnly,
    foundationDns: foundationDns ?? this.foundationDns,
    pageRuleQuota: pageRuleQuota ?? this.pageRuleQuota,
    phishingDetected: phishingDetected ?? this.phishingDetected,
    step: step ?? this.step,
    extra: extra ?? this.extra,
  );
}

/// The owner of the zone.
class ZoneOwner {
  const ZoneOwner({
    this.id,
    this.name,
    this.type_,
    this.extra = const <String, Object?>{},
  });

  factory ZoneOwner.fromJson(Map<String, Object?> json) => ZoneOwner(
    id: asString(json['id']),
    name: asString(json['name']),
    type_: asString(json['type']),
    extra: extraOf(json, _knownKeys),
  );

  /// Identifier
  final String? id;

  /// Name of the owner.
  final String? name;

  /// The type of owner.
  final String? type_;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'id', 'name', 'type'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (id != null) 'id': id!,
    if (name != null) 'name': name!,
    if (type_ != null) 'type': type_!,
  };

  ZoneOwner copyWith({
    String? id,
    String? name,
    String? type_,
    Map<String, Object?>? extra,
  }) => ZoneOwner(
    id: id ?? this.id,
    name: name ?? this.name,
    type_: type_ ?? this.type_,
    extra: extra ?? this.extra,
  );
}

/// A Zones subscription information.
class ZonePlan {
  const ZonePlan({
    this.canSubscribe,
    this.currency,
    this.externallyManaged,
    this.frequency,
    this.id,
    this.isSubscribed,
    this.legacyDiscount,
    this.legacyId,
    this.name,
    this.price,
    this.extra = const <String, Object?>{},
  });

  factory ZonePlan.fromJson(Map<String, Object?> json) => ZonePlan(
    canSubscribe: asBool(json['can_subscribe']),
    currency: asString(json['currency']),
    externallyManaged: asBool(json['externally_managed']),
    frequency: asString(json['frequency']),
    id: asString(json['id']),
    isSubscribed: asBool(json['is_subscribed']),
    legacyDiscount: asBool(json['legacy_discount']),
    legacyId: asString(json['legacy_id']),
    name: asString(json['name']),
    price: asNum(json['price']),
    extra: extraOf(json, _knownKeys),
  );

  /// States if the subscription can be activated.
  final bool? canSubscribe;

  /// The denomination of the customer.
  final String? currency;

  /// If this Zone is managed by another company.
  final bool? externallyManaged;

  /// How often the customer is billed.
  final String? frequency;

  /// Identifier
  final String? id;

  /// States if the subscription active.
  final bool? isSubscribed;

  /// If the legacy discount applies to this Zone.
  final bool? legacyDiscount;

  /// The legacy name of the plan.
  final String? legacyId;

  /// Name of the owner.
  final String? name;

  /// How much the customer is paying.
  final num? price;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'can_subscribe',
    'currency',
    'externally_managed',
    'frequency',
    'id',
    'is_subscribed',
    'legacy_discount',
    'legacy_id',
    'name',
    'price',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (canSubscribe != null) 'can_subscribe': canSubscribe!,
    if (currency != null) 'currency': currency!,
    if (externallyManaged != null) 'externally_managed': externallyManaged!,
    if (frequency != null) 'frequency': frequency!,
    if (id != null) 'id': id!,
    if (isSubscribed != null) 'is_subscribed': isSubscribed!,
    if (legacyDiscount != null) 'legacy_discount': legacyDiscount!,
    if (legacyId != null) 'legacy_id': legacyId!,
    if (name != null) 'name': name!,
    if (price != null) 'price': price!,
  };

  ZonePlan copyWith({
    bool? canSubscribe,
    String? currency,
    bool? externallyManaged,
    String? frequency,
    String? id,
    bool? isSubscribed,
    bool? legacyDiscount,
    String? legacyId,
    String? name,
    num? price,
    Map<String, Object?>? extra,
  }) => ZonePlan(
    canSubscribe: canSubscribe ?? this.canSubscribe,
    currency: currency ?? this.currency,
    externallyManaged: externallyManaged ?? this.externallyManaged,
    frequency: frequency ?? this.frequency,
    id: id ?? this.id,
    isSubscribed: isSubscribed ?? this.isSubscribed,
    legacyDiscount: legacyDiscount ?? this.legacyDiscount,
    legacyId: legacyId ?? this.legacyId,
    name: name ?? this.name,
    price: price ?? this.price,
    extra: extra ?? this.extra,
  );
}

class ZonePurgeBody {
  const ZonePurgeBody({
    this.tags,
    this.hosts,
    this.prefixes,
    this.purgeEverything,
    this.files,
    this.extra = const <String, Object?>{},
  });

  factory ZonePurgeBody.fromJson(Map<String, Object?> json) => ZonePurgeBody(
    tags: asPrimitiveList<String>(json['tags'], asString),
    hosts: asPrimitiveList<String>(json['hosts'], asString),
    prefixes: asPrimitiveList<String>(json['prefixes'], asString),
    purgeEverything: asBool(json['purge_everything']),
    files: asModelList(json['files'], ZonePurgeBodyFilesItem.fromJson),
    extra: extraOf(json, _knownKeys),
  );

  /// For more information on cache tags and purging by tags, please refer to
  /// [purge by cache-tags documentation
  /// page](https://developers.cloudflare.com/cache/how-to/purge-cache/purge-by-tags/).
  final List<String>? tags;

  /// For more information purging by hostnames, please refer to [purge by
  /// hostname documentation
  /// page](https://developers.cloudflare.com/cache/how-to/purge-cache/purge-by-hostname/).
  final List<String>? hosts;

  /// For more information on purging by prefixes, please refer to [purge by
  /// prefix documentation
  /// page](https://developers.cloudflare.com/cache/how-to/purge-cache/purge_by_prefix/).
  final List<String>? prefixes;

  /// For more information, please refer to [purge everything documentation
  /// page](https://developers.cloudflare.com/cache/how-to/purge-cache/purge-everything/).
  final bool? purgeEverything;

  /// For more information on purging files with URL and headers, please refer to
  /// [purge by single-file documentation
  /// page](https://developers.cloudflare.com/cache/how-to/purge-cache/purge-by-single-file/).
  final List<ZonePurgeBodyFilesItem>? files;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'tags',
    'hosts',
    'prefixes',
    'purge_everything',
    'files',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (tags != null) 'tags': tags!,
    if (hosts != null) 'hosts': hosts!,
    if (prefixes != null) 'prefixes': prefixes!,
    if (purgeEverything != null) 'purge_everything': purgeEverything!,
    if (files != null) 'files': files!.map((e) => e.toJson()).toList(),
  };

  ZonePurgeBody copyWith({
    List<String>? tags,
    List<String>? hosts,
    List<String>? prefixes,
    bool? purgeEverything,
    List<ZonePurgeBodyFilesItem>? files,
    Map<String, Object?>? extra,
  }) => ZonePurgeBody(
    tags: tags ?? this.tags,
    hosts: hosts ?? this.hosts,
    prefixes: prefixes ?? this.prefixes,
    purgeEverything: purgeEverything ?? this.purgeEverything,
    files: files ?? this.files,
    extra: extra ?? this.extra,
  );
}

class ZonePurgeBodyFilesItem {
  const ZonePurgeBodyFilesItem({
    this.headers,
    this.url,
    this.extra = const <String, Object?>{},
  });

  factory ZonePurgeBodyFilesItem.fromJson(Map<String, Object?> json) =>
      ZonePurgeBodyFilesItem(
        headers: asMap(json['headers']),
        url: asString(json['url']),
        extra: extraOf(json, _knownKeys),
      );

  final Map<String, Object?>? headers;
  final String? url;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'headers', 'url'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (headers != null) 'headers': headers!,
    if (url != null) 'url': url!,
  };

  ZonePurgeBodyFilesItem copyWith({
    Map<String, Object?>? headers,
    String? url,
    Map<String, Object?>? extra,
  }) => ZonePurgeBodyFilesItem(
    headers: headers ?? this.headers,
    url: url ?? this.url,
    extra: extra ?? this.extra,
  );
}

class ZonePurgeResult {
  const ZonePurgeResult({this.id, this.extra = const <String, Object?>{}});

  factory ZonePurgeResult.fromJson(Map<String, Object?> json) =>
      ZonePurgeResult(
        id: asString(json['id']),
        extra: extraOf(json, _knownKeys),
      );

  final String? id;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'id'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (id != null) 'id': id!,
  };

  ZonePurgeResult copyWith({String? id, Map<String, Object?>? extra}) =>
      ZonePurgeResult(id: id ?? this.id, extra: extra ?? this.extra);
}

class ZoneSettingsGetAllZoneSettingsItem {
  const ZoneSettingsGetAllZoneSettingsItem({
    this.editable,
    this.id,
    this.modifiedOn,
    this.value,
    this.timeRemaining,
    this.enabled,
    this.extra = const <String, Object?>{},
  });

  factory ZoneSettingsGetAllZoneSettingsItem.fromJson(
    Map<String, Object?> json,
  ) => ZoneSettingsGetAllZoneSettingsItem(
    editable: asBool(json['editable']),
    id: json['id'],
    modifiedOn: asString(json['modified_on']),
    value: asString(json['value']),
    timeRemaining: asNum(json['time_remaining']),
    enabled: asBool(json['enabled']),
    extra: extraOf(json, _knownKeys),
  );

  /// Whether or not this setting can be modified for this zone (based on your
  /// Cloudflare plan level). Allowed values: `true`, `false`.
  final bool? editable;

  /// ID of the zone setting. Allowed values: `websockets`.
  final Object? id;

  /// last time this setting was modified.
  final String? modifiedOn;

  /// Value of the zone setting. Allowed values: `off`, `on`.
  final String? value;

  /// Value of the zone setting. Notes: The interval (in seconds) from when
  /// development mode expires (positive integer) or last expired (negative
  /// integer) for the domain. If development mode has never been enabled, this
  /// value is false.
  final num? timeRemaining;

  /// ssl-recommender enrollment setting.
  final bool? enabled;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'editable',
    'id',
    'modified_on',
    'value',
    'time_remaining',
    'enabled',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (editable != null) 'editable': editable!,
    if (id != null) 'id': id!,
    if (modifiedOn != null) 'modified_on': modifiedOn!,
    if (value != null) 'value': value!,
    if (timeRemaining != null) 'time_remaining': timeRemaining!,
    if (enabled != null) 'enabled': enabled!,
  };

  ZoneSettingsGetAllZoneSettingsItem copyWith({
    bool? editable,
    Object? id,
    String? modifiedOn,
    String? value,
    num? timeRemaining,
    bool? enabled,
    Map<String, Object?>? extra,
  }) => ZoneSettingsGetAllZoneSettingsItem(
    editable: editable ?? this.editable,
    id: id ?? this.id,
    modifiedOn: modifiedOn ?? this.modifiedOn,
    value: value ?? this.value,
    timeRemaining: timeRemaining ?? this.timeRemaining,
    enabled: enabled ?? this.enabled,
    extra: extra ?? this.extra,
  );
}

class ZoneSettingsSingleRequest {
  const ZoneSettingsSingleRequest({
    this.enabled,
    this.value,
    this.extra = const <String, Object?>{},
  });

  factory ZoneSettingsSingleRequest.fromJson(Map<String, Object?> json) =>
      ZoneSettingsSingleRequest(
        enabled: asBool(json['enabled']),
        value: asModel(json['value'], SettingValue.fromJson),
        extra: extraOf(json, _knownKeys),
      );

  /// ssl-recommender enrollment setting.
  final bool? enabled;
  final SettingValue? value;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'enabled', 'value'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (enabled != null) 'enabled': enabled!,
    if (value != null) 'value': value!.toJson(),
  };

  ZoneSettingsSingleRequest copyWith({
    bool? enabled,
    SettingValue? value,
    Map<String, Object?>? extra,
  }) => ZoneSettingsSingleRequest(
    enabled: enabled ?? this.enabled,
    value: value ?? this.value,
    extra: extra ?? this.extra,
  );
}

/// The root organizational unit that this zone belongs to (such as a tenant or
/// organization).
class ZoneTenant {
  const ZoneTenant({
    this.id,
    this.name,
    this.extra = const <String, Object?>{},
  });

  factory ZoneTenant.fromJson(Map<String, Object?> json) => ZoneTenant(
    id: asString(json['id']),
    name: asString(json['name']),
    extra: extraOf(json, _knownKeys),
  );

  /// Identifier
  final String? id;

  /// The name of the Tenant account.
  final String? name;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'id', 'name'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (id != null) 'id': id!,
    if (name != null) 'name': name!,
  };

  ZoneTenant copyWith({
    String? id,
    String? name,
    Map<String, Object?>? extra,
  }) => ZoneTenant(
    id: id ?? this.id,
    name: name ?? this.name,
    extra: extra ?? this.extra,
  );
}

/// The immediate parent organizational unit that this zone belongs to (such as
/// under a tenant or sub-organization).
class ZoneTenantUnit {
  const ZoneTenantUnit({this.id, this.extra = const <String, Object?>{}});

  factory ZoneTenantUnit.fromJson(Map<String, Object?> json) => ZoneTenantUnit(
    id: asString(json['id']),
    extra: extraOf(json, _knownKeys),
  );

  /// Identifier
  final String? id;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'id'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (id != null) 'id': id!,
  };

  ZoneTenantUnit copyWith({String? id, Map<String, Object?>? extra}) =>
      ZoneTenantUnit(id: id ?? this.id, extra: extra ?? this.extra);
}

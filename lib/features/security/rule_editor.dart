import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/net/failure.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/failure_text.dart';
import 'security_providers.dart';

/// What a custom rule can do to a request, in the order a person reaches for.
///
/// Not every Ruleset Engine action — `execute`, `rewrite`, `route` and friends
/// configure managed rulesets and transforms, which need their own screens and
/// mean nothing without action parameters.
const List<(String, String)> kCustomRuleActions = [
  ('block', 'Block'),
  ('managed_challenge', 'Managed challenge'),
  ('js_challenge', 'JS challenge'),
  ('challenge', 'Interactive challenge'),
  ('log', 'Log only'),
  ('skip', 'Skip remaining rules'),
];

/// Creates a WAF custom rule or a rate-limiting rule.
///
/// The expression is a plain multi-line field. The Ruleset Engine language
/// deserves a real editor with field completion, and that is a project of its
/// own; until then Cloudflare validates server-side and the error comes back
/// as a ValidationFailure naming the problem, which beats a half-built editor
/// that quietly disagrees with the server.
class RuleEditorSheet extends ConsumerStatefulWidget {
  const RuleEditorSheet({
    required this.zoneId,
    required this.phase,
    required this.rulesetId,
    required this.isRateLimit,
    super.key,
  });

  final String zoneId;
  final String phase;

  /// Null when the phase has no ruleset yet — see [SecurityActions.createPhaseRule].
  final String? rulesetId;

  final bool isRateLimit;

  @override
  ConsumerState<RuleEditorSheet> createState() => _RuleEditorSheetState();
}

class _RuleEditorSheetState extends ConsumerState<RuleEditorSheet> {
  final _expression = TextEditingController();
  final _description = TextEditingController();
  final _requests = TextEditingController(text: '100');
  final _period = TextEditingController(text: '60');

  String _action = 'block';
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Rate limiting cannot "skip"; blocking is the only action that makes
    // sense as a default there.
    if (widget.isRateLimit) _action = 'block';
  }

  @override
  void dispose() {
    for (final c in [_expression, _description, _requests, _period]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        // Eagerly built, like the DNS editor: a lazily built form has fields
        // that do not exist until scrolled to, which breaks focus, validation
        // and anything typed into them.
        builder: (context, controller) => SingleChildScrollView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.isRateLimit
                          ? l.securityNewRateLimitRule
                          : l.securityNewCustomRule,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _description,
                decoration: InputDecoration(labelText: l.dnsComment),
                autocorrect: false,
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _expression,
                decoration: InputDecoration(
                  labelText: l.securityExpression,
                  hintText:
                      '(http.host eq "example.com" and ip.src.country ne "AZ")',
                  helperText: l.securityExpressionHelp,
                  helperMaxLines: 3,
                ),
                style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                maxLines: 5,
                minLines: 3,
                autocorrect: false,
                enableSuggestions: false,
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                initialValue: _action,
                decoration: InputDecoration(labelText: l.securityAction),
                isExpanded: true,
                items: [
                  for (final (id, label) in kCustomRuleActions)
                    if (!widget.isRateLimit || id != 'skip')
                      DropdownMenuItem(
                        value: id,
                        child: Text(label, overflow: TextOverflow.ellipsis),
                      ),
                ],
                onChanged: (v) => setState(() => _action = v ?? 'block'),
              ),

              if (widget.isRateLimit) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _requests,
                        decoration: InputDecoration(
                          labelText: l.securityRequests,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _period,
                        decoration: InputDecoration(
                          labelText: l.securityPeriod,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  l.securityRateLimitHelp,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],

              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),

              const SizedBox(height: 20),
              FilledButton(
                onPressed: _busy ? null : _save,
                child: Text(_busy ? '…' : l.commonSave),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    final l = L.of(context);
    final expression = _expression.text.trim();
    if (expression.isEmpty) {
      setState(() => _error = l.securityExpressionRequired);
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    final rule = <String, Object?>{
      'action': _action,
      'expression': expression,
      'enabled': true,
      if (_description.text.trim().isNotEmpty)
        'description': _description.text.trim(),
      if (widget.isRateLimit)
        'ratelimit': {
          // Counting per client IP is what a rate limit means to most people;
          // anything else is a dashboard-grade decision.
          'characteristics': ['ip.src', 'cf.colo.id'],
          'period': int.tryParse(_period.text.trim()) ?? 60,
          'requests_per_period': int.tryParse(_requests.text.trim()) ?? 100,
          'mitigation_timeout': int.tryParse(_period.text.trim()) ?? 60,
        },
    };

    try {
      await ref
          .read(securityActionsProvider)
          .createPhaseRule(
            zoneId: widget.zoneId,
            phase: widget.phase,
            rulesetId: widget.rulesetId,
            rule: rule,
          );
      if (mounted) Navigator.of(context).pop(true);
    } on CfFailure catch (e) {
      if (!mounted) return;
      setState(() => _error = failureMessage(context, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

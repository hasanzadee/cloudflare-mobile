import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/app_localizations.dart';
import '../data/token_template.dart';

/// The permissions the dashboard's token form cannot pre-select.
///
/// Cloudflare's template-URL format accepts 27 keys; the app needs 29 permission
/// groups. Zone WAF is one of the ones with no key, which is why a token made
/// from the "read + write" link still refused the Security tab.
///
/// Showing them beats silently under-delivering. The user ticks these in the
/// same form the link just opened, so it costs one scroll, not a second trip.
class ManualPermissions extends StatelessWidget {
  const ManualPermissions({required this.permissions, super.key});

  final List<CfPermission> permissions;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final manual = TokenTemplate.manualIn(permissions);
    if (manual.isEmpty) return const SizedBox.shrink();

    final scheme = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      color: scheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.checklist, size: 18, color: scheme.onSurfaceVariant),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l.authManualPermsTitle,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                IconButton(
                  tooltip: l.commonCopy,
                  icon: const Icon(Icons.copy_all_outlined, size: 18),
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(
                        text: TokenTemplate.manualChecklist(permissions),
                      ),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(l.commonCopied)));
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              l.authManualPermsBody,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 10),
            for (final p in manual)
              Padding(
                padding: const EdgeInsets.only(bottom: 6, right: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('•  ', style: TextStyle(color: scheme.primary)),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: p.group,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(text: '  ${p.level}'),
                            if (p.why != null)
                              TextSpan(
                                text: '   ${p.why}',
                                style: TextStyle(
                                  color: scheme.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

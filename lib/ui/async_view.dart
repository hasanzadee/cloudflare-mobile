import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/net/failure.dart';
import '../l10n/app_localizations.dart';
import 'failure_text.dart';

/// One widget for the four states every remote screen has.
///
/// The prototype rendered errors as `Text('$e')` in nine places, which is how
/// "your token lacks DNS: Edit" and "airplane mode" ended up looking the same.
/// Routing every async surface through here also makes `Text('$e')` an
/// obvious code smell in review.
class AsyncView<T> extends StatelessWidget {
  const AsyncView({
    required this.value,
    required this.builder,
    this.onRetry,
    this.empty,
    this.isEmpty,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) builder;
  final VoidCallback? onRetry;

  /// Shown instead of [builder] when [isEmpty] says the payload is empty.
  final Widget? empty;
  final bool Function(T data)? isEmpty;

  @override
  Widget build(BuildContext context) {
    return value.when(
      skipLoadingOnRefresh: false,
      loading: () => const _Skeleton(),
      error: (error, stack) =>
          FailureView(error: error, stack: stack, onRetry: onRetry),
      data: (data) {
        if (isEmpty?.call(data) ?? false) {
          return empty ?? const _EmptyState();
        }
        return builder(data);
      },
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    // A shimmerless skeleton: cheap, and it communicates layout rather than
    // "something is happening somewhere".
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, i) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _bar(context, widthFactor: 0.55),
                  const SizedBox(height: 8),
                  _bar(context, widthFactor: 0.3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bar(BuildContext context, {required double widthFactor}) =>
      FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: widthFactor,
        child: Container(
          height: 12,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Text(
        L.of(context).commonNothingHere,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    ),
  );
}

/// Error state with a human message, a retry, and redacted diagnostics.
class FailureView extends StatelessWidget {
  const FailureView({
    required this.error,
    this.stack,
    this.onRetry,
    this.onFixPermissions,
    super.key,
  });

  final Object error;
  final StackTrace? stack;
  final VoidCallback? onRetry;
  final VoidCallback? onFixPermissions;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final isPermission = error is PermissionFailure;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPermission ? Icons.key_off_outlined : Icons.cloud_off_outlined,
              size: 44,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              failureMessage(context, error),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              alignment: WrapAlignment.center,
              children: [
                if (onRetry != null)
                  FilledButton.tonalIcon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: Text(l.commonRetry),
                  ),
                if (isPermission && onFixPermissions != null)
                  FilledButton.icon(
                    onPressed: onFixPermissions,
                    icon: const Icon(Icons.vpn_key_outlined),
                    label: Text(l.permFixCta),
                  ),
                TextButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(text: failureDiagnostics(error, stack)),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(l.commonCopied)));
                    }
                  },
                  icon: const Icon(Icons.bug_report_outlined),
                  label: Text(l.commonDiagnostics),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

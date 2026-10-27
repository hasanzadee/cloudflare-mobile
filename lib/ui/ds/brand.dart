import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// The app's mark: an orange cloud on a rounded tile.
///
/// Not Cloudflare's logo — the app is unaffiliated and must not look like an
/// official client — just the orange cloud the dashboard uses for "proxied",
/// which is the one symbol every Cloudflare user already reads.
class BrandMark extends StatelessWidget {
  const BrandMark({this.size = 72, super.key});

  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: context.cf.proxied.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(size * 0.3),
    ),
    child: Icon(Icons.cloud, size: size * 0.55, color: context.cf.proxied),
  );
}

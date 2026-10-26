import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A tiny line chart with no axes, for "which way is this going".
///
/// Hand-painted rather than fl_chart: dozens of these sit in a scrolling list,
/// and each needs no touch handling, no titles and no animation. It also draws
/// straight segments, so it cannot overshoot below zero the way a smoothed
/// curve did on v1's analytics chart — traffic is never negative.
class Sparkline extends StatelessWidget {
  const Sparkline({
    required this.values,
    required this.color,
    this.secondary,
    this.secondaryColor,
    this.height = 36,
    this.strokeWidth = 2,
    this.fill = true,
    super.key,
  });

  final List<num> values;
  final Color color;

  /// A second series on the same scale, e.g. cached requests under requests.
  final List<num>? secondary;
  final Color? secondaryColor;

  final double height;
  final double strokeWidth;
  final bool fill;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    width: double.infinity,
    child: CustomPaint(
      painter: _SparklinePainter(
        values: values,
        color: color,
        secondary: secondary,
        secondaryColor: secondaryColor ?? color.withValues(alpha: 0.5),
        strokeWidth: strokeWidth,
        fill: fill,
      ),
    ),
  );
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({
    required this.values,
    required this.color,
    required this.secondary,
    required this.secondaryColor,
    required this.strokeWidth,
    required this.fill,
  });

  final List<num> values;
  final Color color;
  final List<num>? secondary;
  final Color secondaryColor;
  final double strokeWidth;
  final bool fill;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) {
      // A flat baseline says "nothing yet" better than an empty box.
      final paint = Paint()
        ..color = color.withValues(alpha: 0.35)
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      final y = size.height - strokeWidth;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      return;
    }

    final maxValue = [
      ...values,
      ...?secondary,
    ].fold<num>(0, (a, b) => math.max(a, b));
    final top = maxValue <= 0 ? 1.0 : maxValue.toDouble();
    final usable = size.height - strokeWidth;

    Path line(List<num> series) {
      final path = Path();
      for (var i = 0; i < series.length; i++) {
        final x = size.width * i / (series.length - 1);
        final y =
            usable - usable * (math.max(0, series[i]) / top) + strokeWidth / 2;
        i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
      }
      return path;
    }

    final main = line(values);
    if (fill) {
      final area = Path.from(main)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      canvas.drawPath(area, Paint()..color = color.withValues(alpha: 0.12));
    }

    final second = secondary;
    if (second != null && second.length >= 2) {
      canvas.drawPath(
        line(second),
        Paint()
          ..color = secondaryColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth * 0.8
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round,
      );
    }

    canvas.drawPath(
      main,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_SparklinePainter old) =>
      old.values != values ||
      old.secondary != secondary ||
      old.color != color ||
      old.secondaryColor != secondaryColor;
}

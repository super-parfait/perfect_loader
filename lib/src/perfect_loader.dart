import 'dart:math' as math;
import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';

/// Indeterminate progress: wavy ring + rotating segment (Play Store–like).
///
/// No assets; all drawing via [CustomPaint]. Safe with zero / tiny layout.
class PerfectLoader extends StatefulWidget {
  const PerfectLoader({
    super.key,
    this.size = 56,
    this.strokeWidth,
    this.activeColor = const Color(0xFF1A73E8),
    this.trackColor = const Color(0xFF8AB4F8),
    this.duration = const Duration(milliseconds: 1400),
    this.sweepFraction = 0.38,
    this.waveCount = 16,
  })  : assert(sweepFraction > 0 && sweepFraction <= 1),
        assert(waveCount > 2);

  /// Width and height of the square bounds.
  final double size;

  /// Stroke width; if null, derived from [size].
  final double? strokeWidth;

  /// Foreground arc color.
  final Color activeColor;

  /// Full ring (track) base color; painter applies extra opacity for contrast.
  final Color trackColor;

  /// One full rotation of the active segment.
  final Duration duration;

  /// Length of the highlighted arc as a fraction of perimeter (0–1].
  final double sweepFraction;

  /// Number of scallops around the ring.
  final int waveCount;

  @override
  State<PerfectLoader> createState() => _PerfectLoaderState();
}

class _PerfectLoaderState extends State<PerfectLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void didUpdateWidget(covariant PerfectLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sw = widget.strokeWidth ?? (widget.size * 0.055).clamp(2.5, 4.5);
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _WavyRingPainter(
              rotation: _controller.value,
              strokeWidth: sw,
              activeColor: widget.activeColor,
              trackColor: widget.trackColor,
              sweepFraction: widget.sweepFraction,
              waveCount: widget.waveCount,
            ),
          );
        },
      ),
    );
  }
}

class _WavyRingPainter extends CustomPainter {
  _WavyRingPainter({
    required this.rotation,
    required this.strokeWidth,
    required this.activeColor,
    required this.trackColor,
    required this.sweepFraction,
    required this.waveCount,
  });

  final double rotation;
  final double strokeWidth;
  final Color activeColor;
  final Color trackColor;
  final double sweepFraction;
  final int waveCount;

  Path _buildWavyCirclePath(Offset c, double baseRadius, double waveAmp) {
    const steps = 144;
    final path = Path();
    for (var i = 0; i <= steps; i++) {
      final t = (i / steps) * math.pi * 2;
      final r = baseRadius + waveAmp * math.sin(waveCount * t);
      final x = c.dx + r * math.cos(t);
      final y = c.dy + r * math.sin(t);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  /// [PathMetric.extractPath] uses absolute distance along contour for end, not length.
  Path _arcAlongContour(PathMetric metric, double startDist, double sweepDist) {
    final len = metric.length;
    if (len <= 0 || sweepDist <= 0) return Path();
    final start = startDist % len;
    final endAbs = start + sweepDist;
    if (endAbs <= len) {
      return metric.extractPath(start, endAbs);
    }
    final out = Path();
    out.addPath(metric.extractPath(start, len), Offset.zero);
    final overflow = endAbs - len;
    if (overflow > 1e-6) {
      out.addPath(metric.extractPath(0, overflow.clamp(0.0, len)), Offset.zero);
    }
    return out;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (!size.width.isFinite ||
        !size.height.isFinite ||
        size.width <= 0 ||
        size.height <= 0) {
      return;
    }

    final c = Offset(size.width / 2, size.height / 2);
    final minSide = math.min(size.width, size.height);
    final waveAmp = (minSide * 0.045).clamp(2.0, 5.0);
    final baseR = math.max(
      minSide / 2 - strokeWidth - waveAmp,
      4.0,
    );

    final path = _buildWavyCirclePath(c, baseR, waveAmp);
    PathMetric? metric;
    for (final m in path.computeMetrics(forceClosed: true)) {
      metric = m;
      break;
    }
    if (metric == null) {
      return;
    }

    final trackPaint = Paint()
      ..color = trackColor.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    canvas.drawPath(path, trackPaint);

    final len = metric.length;
    if (len <= 1e-6) {
      return;
    }
    final sweepLen = len * sweepFraction;
    final startDist = rotation * len;
    final activeSegment = _arcAlongContour(metric, startDist, sweepLen);
    canvas.drawPath(activeSegment, activePaint);
  }

  @override
  bool shouldRepaint(covariant _WavyRingPainter oldDelegate) {
    return oldDelegate.rotation != rotation ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.sweepFraction != sweepFraction ||
        oldDelegate.waveCount != waveCount;
  }
}

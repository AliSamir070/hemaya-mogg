import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/resources/color_manager.dart';

/// 270° radial gauge (Figma: "Gauge track" / "Gauge value" / "Gauge knob").
///
/// * The value arc sweeps in on first build and smoothly tweens to new values.
/// * The centre number counts up in sync with the arc.
/// * The knob has a soft "breathing" halo to signal the reading is live.
///
/// All motion is skipped when the platform requests reduced motion.
class RadialGauge extends StatefulWidget {
  const RadialGauge({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.color,
    required this.diameter,
    required this.unit,
    this.fractionDigits = 0,
  });

  final double value;
  final double min;
  final double max;
  final Color color;
  final double diameter;
  final String unit;
  final int fractionDigits;

  @override
  State<RadialGauge> createState() => _RadialGaugeState();
}

class _RadialGaugeState extends State<RadialGauge>
    with SingleTickerProviderStateMixin {
  static const _sweepDuration = Duration(milliseconds: 1400);

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _pulse.stop();
      _pulse.value = 0;
    } else if (!_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final diameter = widget.diameter;
    final value = widget.value.clamp(widget.min, widget.max).toDouble();

    return SizedBox.square(
      dimension: diameter,
      child: TweenAnimationBuilder<double>(
        // Starting at `min` makes the arc sweep in on first build; later
        // updates animate from the currently displayed value.
        tween: Tween(begin: widget.min, end: value),
        duration: reduceMotion ? Duration.zero : _sweepDuration,
        curve: Curves.easeOutCubic,
        builder: (context, animatedValue, _) {
          final progress =
              (animatedValue - widget.min) / (widget.max - widget.min);
          return CustomPaint(
            painter: _GaugePainter(progress: progress, color: widget.color),
            foregroundPainter: _KnobHaloPainter(
              progress: progress,
              color: widget.color,
              pulse: _pulse,
            ),
            child: _GaugeLabel(
              value: animatedValue.toStringAsFixed(widget.fractionDigits),
              unit: widget.unit,
              diameter: diameter,
            ),
          );
        },
      ),
    );
  }
}

class _GaugeLabel extends StatelessWidget {
  const _GaugeLabel({
    required this.value,
    required this.unit,
    required this.diameter,
  });

  final String value;
  final String unit;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    // Typography scales with the gauge (32 / 13 on a 120 gauge in Figma).
    // Text scaling is handled by FittedBox so large accessibility fonts
    // never overflow the ring.
    return Padding(
      padding: EdgeInsets.all(diameter * 0.2),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: diameter * 0.267,
                height: 1.1,
                fontWeight: FontWeight.w700,
                color: ColorManager.pureWhite,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            Text(
              unit,
              style: TextStyle(
                fontSize: diameter * 0.108,
                color: ColorManager.slate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shared arc geometry for the gauge painters.
class _GaugeGeometry {
  _GaugeGeometry(Size size, double progress)
    : stroke = size.width * 0.1,
      knobRadius = size.width * 0.058,
      progress = progress.clamp(0.0, 1.0) {
    arcRect = (Offset.zero & size).deflate(stroke / 2 + knobRadius * 0.3);
  }

  /// Arc starts bottom-left (135°) and sweeps 270° clockwise.
  static const double startAngle = 3 * math.pi / 4;
  static const double fullSweep = 3 * math.pi / 2;

  final double stroke;
  final double knobRadius;
  final double progress;
  late final Rect arcRect;

  double get sweep => fullSweep * progress;

  Offset get knobCenter {
    final angle = startAngle + sweep;
    final radius = arcRect.width / 2;
    return arcRect.center +
        Offset(math.cos(angle) * radius, math.sin(angle) * radius);
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final g = _GaugeGeometry(size, progress);

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = g.stroke
      ..color = ColorManager.surfaceLight.withValues(alpha: 0.9);
    canvas.drawArc(
      g.arcRect,
      _GaugeGeometry.startAngle,
      _GaugeGeometry.fullSweep,
      false,
      trackPaint,
    );

    if (g.progress <= 0) return;

    // Soft outer glow under the value arc.
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = g.stroke
      ..color = color.withValues(alpha: 0.35)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, g.stroke * 0.6);
    canvas.drawArc(
      g.arcRect,
      _GaugeGeometry.startAngle,
      g.sweep,
      false,
      glowPaint,
    );

    final valuePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = g.stroke
      ..color = color;
    canvas.drawArc(
      g.arcRect,
      _GaugeGeometry.startAngle,
      g.sweep,
      false,
      valuePaint,
    );

    // Knob at the tip of the value arc.
    final knob = g.knobCenter;
    canvas.drawCircle(knob, g.knobRadius, Paint()..color = color);
    canvas.drawCircle(
      knob,
      g.knobRadius * 0.55,
      Paint()..color = ColorManager.pureWhite,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

/// Breathing ring around the knob. Lives on its own layer so the blurred arc
/// isn't repainted on every pulse frame.
class _KnobHaloPainter extends CustomPainter {
  _KnobHaloPainter({
    required this.progress,
    required this.color,
    required this.pulse,
  }) : super(repaint: pulse);

  final double progress;
  final Color color;
  final Animation<double> pulse;

  @override
  void paint(Canvas canvas, Size size) {
    final g = _GaugeGeometry(size, progress);
    if (g.progress <= 0) return;

    final t = Curves.easeInOut.transform(pulse.value);
    final outer = g.knobRadius * (1.5 + 0.8 * t);
    final width = outer - g.knobRadius;
    canvas.drawCircle(
      g.knobCenter,
      g.knobRadius + width / 2,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..color = color.withValues(alpha: 0.32 * (1 - t) + 0.06),
    );
  }

  @override
  bool shouldRepaint(_KnobHaloPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

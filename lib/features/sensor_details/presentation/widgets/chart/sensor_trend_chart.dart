import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/resources/strings_manager.dart';
import '../../models/sensor_details_ui_model.dart';
import '../../utils/sensor_status_style.dart';

/// Dual-series (temperature + humidity) smooth line chart for the last 24h.
///
/// * Lines draw in from left to right on first build.
/// * "Now" end-points pulse to signal live data.
/// * Tap / drag (touch) or hover (mouse) to inspect any reading.
///
/// Each series is normalised to its own range (dual axis) so both trends are
/// readable in the same compact plot, as in the design.
class SensorTrendChart extends StatefulWidget {
  const SensorTrendChart({
    super.key,
    required this.samples,
    required this.plotHeight,
  });

  final List<SensorSample> samples;

  /// Height of the plotting area, excluding the time axis labels.
  final double plotHeight;

  @override
  State<SensorTrendChart> createState() => _SensorTrendChartState();
}

class _SensorTrendChartState extends State<SensorTrendChart>
    with TickerProviderStateMixin {
  late final AnimationController _reveal = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );
  late final Animation<double> _revealCurve = CurvedAnimation(
    parent: _reveal,
    curve: Curves.easeOutCubic,
  );
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  int? _selectedIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _reveal.value = 1;
      _pulse
        ..stop()
        ..value = 0;
    } else {
      if (_reveal.isDismissed) _reveal.forward();
      if (!_pulse.isAnimating) _pulse.repeat();
    }
  }

  @override
  void didUpdateWidget(SensorTrendChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    final index = _selectedIndex;
    if (index != null && index >= widget.samples.length) {
      _selectedIndex = null;
    }
  }

  @override
  void dispose() {
    _reveal.dispose();
    _pulse.dispose();
    super.dispose();
  }

  int _indexForDx(double dx, double width) {
    final n = widget.samples.length;
    final t = (dx / width).clamp(0.0, 1.0);
    return (t * (n - 1)).round();
  }

  void _select(double dx, double width) {
    final index = _indexForDx(dx, width);
    if (index != _selectedIndex) setState(() => _selectedIndex = index);
  }

  void _toggle(double dx, double width) {
    final index = _indexForDx(dx, width);
    setState(() => _selectedIndex = index == _selectedIndex ? null : index);
  }

  void _clear() {
    if (_selectedIndex != null) setState(() => _selectedIndex = null);
  }

  @override
  Widget build(BuildContext context) {
    final samples = widget.samples;
    if (samples.length < 2) {
      return SizedBox(
        height: widget.plotHeight,
        child: Center(
          child: Text(
            StringsManager.noReadings,
            style: TextStyle(fontSize: 12.sp, color: ColorManager.slate),
          ),
        ),
      );
    }

    final labelStyle = TextStyle(fontSize: 11.sp, color: ColorManager.slate);
    final textScaler = MediaQuery.textScalerOf(context);
    final labelBand = textScaler.scale(labelStyle.fontSize!) * 1.4 + 10.r;

    return Semantics(
      label: _semanticSummary(samples),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final geometry = _ChartGeometry(
            samples: samples,
            size: Size(width, widget.plotHeight),
          );
          final selected = _selectedIndex;

          return MouseRegion(
            onHover: (e) => _select(e.localPosition.dx, width),
            onExit: (_) => _clear(),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (d) => _toggle(d.localPosition.dx, width),
              onHorizontalDragStart: (d) => _select(d.localPosition.dx, width),
              onHorizontalDragUpdate: (d) => _select(d.localPosition.dx, width),
              child: SizedBox(
                height: widget.plotHeight + labelBand,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: RepaintBoundary(
                        child: CustomPaint(
                          painter: _TrendPainter(
                            geometry: geometry,
                            reveal: _revealCurve,
                            selectedIndex: selected,
                            labels: _timeLabels(samples),
                            labelStyle: labelStyle,
                            textScaler: textScaler,
                            textDirection: Directionality.of(context),
                          ),
                          foregroundPainter: _LivePulsePainter(
                            geometry: geometry,
                            pulse: _pulse,
                            reveal: _revealCurve,
                          ),
                        ),
                      ),
                    ),
                    if (selected != null)
                      _ChartTooltip(
                        sample: samples[selected],
                        anchorX: geometry.xAt(selected),
                        chartWidth: width,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static List<String> _timeLabels(List<SensorSample> samples) {
    final start = samples.first.time;
    final span = samples.last.time.difference(start);
    return [
      for (var i = 0; i < 4; i++) formatClock(start.add(span * (i / 4))),
      StringsManager.now,
    ];
  }

  static String _semanticSummary(List<SensorSample> samples) {
    final temps = samples.map((s) => s.temperature);
    final hums = samples.map((s) => s.humidity);
    return '${StringsManager.last24Hours}. '
        '${StringsManager.temperature} ${temps.reduce(math.min).toStringAsFixed(1)}'
        ' – ${temps.reduce(math.max).toStringAsFixed(1)} ${StringsManager.celsius}. '
        '${StringsManager.humidity} ${hums.reduce(math.min).round()}'
        ' – ${hums.reduce(math.max).round()}${StringsManager.percentRh}.';
  }
}

/// Maps samples to plot coordinates. Shared by both painters and the tooltip.
class _ChartGeometry {
  _ChartGeometry({required this.samples, required this.size})
    : _temp = _Range.of(samples.map((s) => s.temperature), minPad: 0.5),
      _hum = _Range.of(samples.map((s) => s.humidity), minPad: 2);

  final List<SensorSample> samples;

  /// Size of the plotting area (grid), excluding the label band.
  final Size size;
  final _Range _temp;
  final _Range _hum;

  // Figma: grid spans 80px, plot spans 70px starting 8px below the top line.
  double get _plotTop => size.height * 0.1;
  double get _plotBottom => size.height * 0.97;

  double xAt(int i) => size.width * i / (samples.length - 1);

  double _y(double t) => _plotBottom - (_plotBottom - _plotTop) * t;

  Offset tempAt(int i) =>
      Offset(xAt(i), _y(_temp.normalize(samples[i].temperature)));

  Offset humAt(int i) =>
      Offset(xAt(i), _y(_hum.normalize(samples[i].humidity)));

  List<Offset> get tempPoints =>
      List.generate(samples.length, tempAt, growable: false);

  List<Offset> get humPoints =>
      List.generate(samples.length, humAt, growable: false);
}

class _Range {
  const _Range(this.min, this.max);

  factory _Range.of(Iterable<double> values, {required double minPad}) {
    final lo = values.reduce(math.min);
    final hi = values.reduce(math.max);
    final pad = math.max((hi - lo) * 0.12, minPad);
    return _Range(lo - pad, hi + pad);
  }

  final double min;
  final double max;

  double normalize(double v) => ((v - min) / (max - min)).clamp(0.0, 1.0);
}

/// Smooth path through [points] using horizontal-tangent cubic segments
/// (no overshoot, unlike Catmull-Rom).
Path _smoothPath(List<Offset> points) {
  final path = Path()..moveTo(points.first.dx, points.first.dy);
  for (var i = 1; i < points.length; i++) {
    final p0 = points[i - 1];
    final p1 = points[i];
    final midX = (p0.dx + p1.dx) / 2;
    path.cubicTo(midX, p0.dy, midX, p1.dy, p1.dx, p1.dy);
  }
  return path;
}

class _TrendPainter extends CustomPainter {
  _TrendPainter({
    required this.geometry,
    required this.reveal,
    required this.selectedIndex,
    required this.labels,
    required this.labelStyle,
    required this.textScaler,
    required this.textDirection,
  }) : super(repaint: reveal);

  final _ChartGeometry geometry;
  final Animation<double> reveal;
  final int? selectedIndex;
  final List<String> labels;
  final TextStyle labelStyle;
  final TextScaler textScaler;
  final TextDirection textDirection;

  static const _tempColor = ColorManager.orange;
  static const _humColor = ColorManager.sky;

  @override
  void paint(Canvas canvas, Size size) {
    final plot = geometry.size;
    final progress = reveal.value;

    _paintGrid(canvas, plot);
    _paintLabels(canvas, plot);

    final tempPath = _smoothPath(geometry.tempPoints);
    final humPath = _smoothPath(geometry.humPoints);

    // Temperature area fill, revealed with a left-to-right clip.
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, plot.width * progress, plot.height));
    final area = Path.from(tempPath)
      ..lineTo(plot.width, plot.height)
      ..lineTo(0, plot.height)
      ..close();
    canvas.drawPath(
      area,
      Paint()
        ..shader = ui.Gradient.linear(Offset.zero, Offset(0, plot.height), [
          _tempColor.withValues(alpha: 0.28),
          _tempColor.withValues(alpha: 0.0),
        ]),
    );
    canvas.restore();

    _paintLine(canvas, humPath, _humColor, progress);
    _paintLine(canvas, tempPath, _tempColor, progress);

    final selected = selectedIndex;
    if (selected != null && progress >= 1) {
      _paintSelection(canvas, plot, selected);
    }
  }

  void _paintGrid(Canvas canvas, Size plot) {
    final paint = Paint()
      ..color = ColorManager.pureWhite.withValues(alpha: 0.06)
      ..strokeWidth = 1;
    for (final y in [0.5, plot.height / 2, plot.height - 0.5]) {
      canvas.drawLine(Offset(0, y), Offset(plot.width, y), paint);
    }
  }

  void _paintLabels(Canvas canvas, Size plot) {
    final top = plot.height + 10.r;
    final last = labels.length - 1;
    for (var i = 0; i <= last; i++) {
      final tp = TextPainter(
        text: TextSpan(text: labels[i], style: labelStyle),
        textDirection: textDirection,
        textScaler: textScaler,
        maxLines: 1,
      )..layout();
      final x = plot.width * i / last;
      // First label left-aligned, last right-aligned, others centred.
      final dx = i == 0
          ? 0.0
          : i == last
          ? x - tp.width
          : x - tp.width / 2;
      tp.paint(canvas, Offset(dx, top));
      tp.dispose();
    }
  }

  void _paintLine(Canvas canvas, Path path, Color color, double progress) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = color;

    if (progress >= 1) {
      canvas.drawPath(path, paint);
      return;
    }
    for (final metric in path.computeMetrics()) {
      canvas.drawPath(metric.extractPath(0, metric.length * progress), paint);
      final tip = metric.getTangentForOffset(metric.length * progress);
      if (tip != null) _paintDot(canvas, tip.position, color);
    }
  }

  void _paintSelection(Canvas canvas, Size plot, int index) {
    final x = geometry.xAt(index);
    final guide = Paint()
      ..color = ColorManager.pureWhite.withValues(alpha: 0.35)
      ..strokeWidth = 1;
    const dash = 4.0;
    for (var y = 0.0; y < plot.height; y += dash * 2) {
      canvas.drawLine(
        Offset(x, y),
        Offset(x, math.min(y + dash, plot.height)),
        guide,
      );
    }
    _paintDot(canvas, geometry.humAt(index), _humColor);
    _paintDot(canvas, geometry.tempAt(index), _tempColor);
  }

  @override
  bool shouldRepaint(_TrendPainter old) =>
      old.geometry.samples != geometry.samples ||
      old.geometry.size != geometry.size ||
      old.selectedIndex != selectedIndex ||
      old.labelStyle != labelStyle ||
      old.textScaler != textScaler;
}

void _paintDot(Canvas canvas, Offset center, Color color) {
  canvas.drawCircle(center, 5, Paint()..color = color);
  canvas.drawCircle(
    center,
    5,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = ColorManager.surface,
  );
}

/// Pulsing "live" end-points. Kept on its own layer so the (static) chart
/// isn't repainted on every pulse frame.
class _LivePulsePainter extends CustomPainter {
  _LivePulsePainter({
    required this.geometry,
    required this.pulse,
    required this.reveal,
  }) : super(repaint: Listenable.merge([pulse, reveal]));

  final _ChartGeometry geometry;
  final Animation<double> pulse;
  final Animation<double> reveal;

  @override
  void paint(Canvas canvas, Size size) {
    if (reveal.value < 1) return;
    final last = geometry.samples.length - 1;
    final t = pulse.value;
    for (final (point, color) in [
      (geometry.humAt(last), ColorManager.sky),
      (geometry.tempAt(last), ColorManager.orange),
    ]) {
      canvas.drawCircle(
        point,
        5 + 9 * t,
        Paint()..color = color.withValues(alpha: 0.45 * (1 - t)),
      );
      _paintDot(canvas, point, color);
    }
  }

  @override
  bool shouldRepaint(_LivePulsePainter old) =>
      old.geometry.samples != geometry.samples ||
      old.geometry.size != geometry.size;
}

class _ChartTooltip extends StatelessWidget {
  const _ChartTooltip({
    required this.sample,
    required this.anchorX,
    required this.chartWidth,
  });

  final SensorSample sample;
  final double anchorX;
  final double chartWidth;

  @override
  Widget build(BuildContext context) {
    final width = 104.r;
    final left = (anchorX - width / 2).clamp(
      0.0,
      math.max(0.0, chartWidth - width),
    );
    return Positioned(
      left: left.toDouble(),
      top: -8.r,
      width: width,
      child: IgnorePointer(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 7.r),
          decoration: BoxDecoration(
            color: ColorManager.surfaceLight.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: ColorManager.pureWhite.withValues(alpha: 0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: ColorManager.black.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatClock(sample.time),
                style: TextStyle(fontSize: 10.sp, color: ColorManager.slate),
              ),
              SizedBox(height: 2.r),
              _TooltipValue(
                color: ColorManager.orange,
                text:
                    '${sample.temperature.toStringAsFixed(1)}'
                    '${StringsManager.celsius}',
              ),
              _TooltipValue(
                color: ColorManager.sky,
                text: '${sample.humidity.round()}${StringsManager.percentRh}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TooltipValue extends StatelessWidget {
  const _TooltipValue({required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6.r,
          height: 6.r,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6.r),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: ColorManager.pureWhite,
            ),
          ),
        ),
      ],
    );
  }
}

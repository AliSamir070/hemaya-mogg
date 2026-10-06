import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';
import '../common/sensor_card.dart';
import 'radial_gauge.dart';

/// Figma: "Temperature card" / "Humidity card".
///
/// [gaugeDiameter] is supplied by the parent (instead of a LayoutBuilder)
/// so the card can participate in intrinsic-height rows on wide layouts.
class GaugeCard extends StatelessWidget {
  const GaugeCard({
    super.key,
    required this.title,
    required this.badgeGlyph,
    required this.accent,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    required this.statusLabel,
    required this.statusColor,
    required this.gaugeDiameter,
    this.fractionDigits = 0,
  });

  final String title;
  final String badgeGlyph;
  final Color accent;
  final double value;
  final double min;
  final double max;
  final String unit;
  final String statusLabel;
  final Color statusColor;
  final double gaugeDiameter;
  final int fractionDigits;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label:
          '$title ${value.toStringAsFixed(fractionDigits)} $unit, '
          '$statusLabel',
      excludeSemantics: true,
      child: SensorCard(
        padding: EdgeInsets.fromLTRB(14.r, 14.r, 14.r, 18.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SensorIconBadge(color: accent, size: 30.r, glyph: badgeGlyph),
                SizedBox(width: 8.r),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: ColorManager.pureWhite,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.r),
            RadialGauge(
              value: value,
              min: min,
              max: max,
              color: accent,
              diameter: gaugeDiameter,
              unit: unit,
              fractionDigits: fractionDigits,
            ),
            // The gauge's open bottom leaves visual room; tuck the pill in.
            SizedBox(height: 4.r),
            SensorStatusPill(
              label: statusLabel,
              color: statusColor,
              minWidth: 101.r,
            ),
          ],
        ),
      ),
    );
  }
}

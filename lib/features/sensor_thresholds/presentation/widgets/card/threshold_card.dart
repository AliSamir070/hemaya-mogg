import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/resources/strings_manager.dart';
import '../../../../sensor_details/presentation/widgets/common/sensor_card.dart';

/// Interactive card allowing adjustment of a sensor limit threshold.
/// Figma node 48:23 (Temperature card) and 48:40 (Humidity card).
class ThresholdCard extends StatelessWidget {
  const ThresholdCard({
    super.key,
    required this.title,
    required this.badgeGlyph,
    required this.accentColor,
    required this.currentValueLabel,
    required this.thresholdValueLabel,
    required this.threshold,
    required this.min,
    required this.max,
    required this.minLabel,
    required this.maxLabel,
    required this.onChanged,
    required this.onIncrement,
    required this.onDecrement,
  });

  final String title;
  final String badgeGlyph;
  final Color accentColor;
  final String currentValueLabel;
  final String thresholdValueLabel;
  final double threshold;
  final double min;
  final double max;
  final String minLabel;
  final String maxLabel;
  final ValueChanged<double> onChanged;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return SensorCard(
      radius: 24.r,
      padding: EdgeInsets.symmetric(horizontal: 18.r, vertical: 18.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Row: Icon Badge + Title + Current Value Chip
          Row(
            children: [
              SensorIconBadge(
                color: accentColor,
                size: 32.r,
                glyph: badgeGlyph,
              ),
              SizedBox(width: 12.r),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorManager.pureWhite,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 5.r),
                decoration: BoxDecoration(
                  color: ColorManager.homeBackground.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(13.r),
                  border: Border.all(
                    color: ColorManager.pureWhite.withValues(alpha: 0.08),
                  ),
                ),
                child: Text(
                  'Now $currentValueLabel',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorManager.pureWhite,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.r),

          // Subtitle
          Text(
            StringsManager.thresholdAlertHint,
            style: TextStyle(
              fontSize: 12.sp,
              color: ColorManager.slate,
            ),
          ),
          SizedBox(height: 16.r),

          // Center Threshold Stepper Box
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.r, vertical: 10.r),
              decoration: BoxDecoration(
                color: ColorManager.homeBackground.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: ColorManager.pureWhite.withValues(alpha: 0.08),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        StringsManager.thresholdUppercase,
                        style: TextStyle(
                          fontSize: 10.sp,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w600,
                          color: ColorManager.slate,
                        ),
                      ),
                      SizedBox(height: 2.r),
                      Text(
                        thresholdValueLabel,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                          color: accentColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16.r),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _StepButton(
                        glyph: '−',
                        onTap: onDecrement,
                      ),
                      SizedBox(width: 8.r),
                      _StepButton(
                        glyph: '+',
                        onTap: onIncrement,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 18.r),

          // Slider & Range bounds
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 6.r,
              activeTrackColor: accentColor,
              inactiveTrackColor:
                  ColorManager.surfaceLight.withValues(alpha: 0.6),
              thumbColor: ColorManager.pureWhite,
              overlayColor: accentColor.withValues(alpha: 0.2),
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 13.r,
                elevation: 4,
              ),
              overlayShape: RoundSliderOverlayShape(
                overlayRadius: 22.r,
              ),
            ),
            child: Slider(
              value: threshold.clamp(min, max),
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  minLabel,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: ColorManager.slate,
                  ),
                ),
                Text(
                  maxLabel,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: ColorManager.slate,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.glyph,
    required this.onTap,
  });

  final String glyph;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: glyph,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.r),
          onTap: onTap,
          child: Container(
            width: 30.r,
            height: 30.r,
            decoration: BoxDecoration(
              color: ColorManager.surfaceLight,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: ColorManager.pureWhite.withValues(alpha: 0.1),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              glyph,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: ColorManager.pureWhite,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

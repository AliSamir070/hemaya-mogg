import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/resources/strings_manager.dart';

/// Header for "02 · Alarm Thresholds" screen.
/// Figma: Circle back button + "Alarm Thresholds" title + sensor name subtitle.
class SensorThresholdsHeader extends StatelessWidget {
  const SensorThresholdsHeader({
    super.key,
    required this.deviceName,
    required this.onBack,
  });

  final String deviceName;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Row(
      children: [
        Semantics(
          button: true,
          label: StringsManager.back,
          excludeSemantics: true,
          child: Material(
            color: ColorManager.surface,
            shape: CircleBorder(
              side: BorderSide(
                color: ColorManager.pureWhite.withValues(alpha: 0.08),
              ),
            ),
            child: InkWell(
              onTap: onBack,
              customBorder: const CircleBorder(),
              child: SizedBox.square(
                dimension: 44.r,
                child: Icon(
                  isRtl
                      ? Icons.chevron_right_rounded
                      : Icons.chevron_left_rounded,
                  color: ColorManager.pureWhite,
                  size: 26.r,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 14.r),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                header: true,
                child: Text(
                  StringsManager.setThresholds,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: ColorManager.pureWhite,
                  ),
                ),
              ),
              SizedBox(height: 2.r),
              Text(
                deviceName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: ColorManager.slate,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

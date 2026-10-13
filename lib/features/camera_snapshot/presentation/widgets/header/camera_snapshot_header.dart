import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/resources/strings_manager.dart';
import '../../../../sensor_details/presentation/widgets/common/sensor_card.dart';
import '../../../../sensor_details/presentation/widgets/header/sensor_details_header.dart';

/// Figma: "Back btn" + "Front Door Camera" + "eWeLink Smart Camera · Wi-Fi",
/// with the red "Live" pill on the trailing side.
class CameraSnapshotHeader extends StatelessWidget {
  const CameraSnapshotHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isOnline,
    required this.onBack,
  });

  final String title;
  final String subtitle;
  final bool isOnline;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final pillColor = isOnline ? ColorManager.error : ColorManager.slate;
    return Row(
      children: [
        _CircleBackButton(onPressed: onBack),
        SizedBox(width: 14.r),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                header: true,
                child: Text(
                  title,
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
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.sp, color: ColorManager.slate),
              ),
            ],
          ),
        ),
        SizedBox(width: 8.r),
        SensorStatusPill(
          label: isOnline ? StringsManager.live : StringsManager.offline,
          color: pillColor,
          leading: LiveDot(color: pillColor, animate: isOnline),
        ),
      ],
    );
  }
}

class _CircleBackButton extends StatelessWidget {
  const _CircleBackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Semantics(
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
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: SizedBox.square(
            // 40px in Figma; kept ≥ 44 logical px for touch accessibility.
            dimension: 44.r,
            child: Icon(
              isRtl ? Icons.chevron_right_rounded : Icons.chevron_left_rounded,
              color: ColorManager.pureWhite,
              size: 26.r,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/resources/strings_manager.dart';
import '../../models/device_ui_model.dart';
import '../../utils/device_style.dart';

/// Tappable card representing a single device (Figma: "… card — Navigate to …").
class DeviceCard extends StatelessWidget {
  const DeviceCard({super.key, required this.device, this.onTap});

  final DeviceUiModel device;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final accent = device.category.accentColor;
    final radius = BorderRadius.circular(24.r);

    return Semantics(
      button: true,
      label: '${device.name}, '
          '${device.isOnline ? StringsManager.online : StringsManager.offline}',
      hint: device.actionHint,
      excludeSemantics: true,
      child: Material(
        type: MaterialType.transparency,
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [ColorManager.surfaceLight, ColorManager.surface],
            ),
            borderRadius: radius,
            border: Border.all(
              color: accent.withValues(alpha: 0.45),
              width: 1.5,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: radius,
            splashColor: accent.withValues(alpha: 0.12),
            highlightColor: accent.withValues(alpha: 0.06),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.r, 18.r, 18.r, 8.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          _DeviceIconBadge(category: device.category),
                          SizedBox(width: 14.r),
                          Expanded(child: _DeviceInfo(device: device)),
                          // Leaves room for the status dot.
                          SizedBox(width: 16.r),
                        ],
                      ),
                      SizedBox(height: 8.r),
                      _ActionHint(text: device.actionHint, color: accent),
                    ],
                  ),
                ),
                PositionedDirectional(
                  top: 18.r,
                  end: 18.r,
                  child: _StatusDot(isOnline: device.isOnline),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DeviceIconBadge extends StatelessWidget {
  const _DeviceIconBadge({required this.category});

  final DeviceCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52.r,
      height: 52.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: category.iconGradient,
      ),
      child: Icon(category.icon, color: ColorManager.pureWhite, size: 24.r),
    );
  }
}

class _DeviceInfo extends StatelessWidget {
  const _DeviceInfo({required this.device});

  final DeviceUiModel device;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          device.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: ColorManager.pureWhite,
          ),
        ),
        SizedBox(height: 2.r),
        Text(
          device.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 11.sp, color: ColorManager.slate),
        ),
        if (device.metrics.isNotEmpty) ...[
          SizedBox(height: 7.r),
          Wrap(
            spacing: 8.r,
            runSpacing: 6.r,
            children: [
              for (final metric in device.metrics) _MetricChip(metric: metric),
            ],
          ),
        ],
      ],
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.metric});

  final DeviceMetricUiModel metric;

  @override
  Widget build(BuildContext context) {
    final color = metric.tone.color;
    return Container(
      constraints: BoxConstraints(minHeight: 22.r, minWidth: 58.r),
      padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 4.r),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(11.r),
      ),
      child: Text(
        metric.label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _ActionHint extends StatelessWidget {
  const _ActionHint({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 2.r),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
          Icon(
            Directionality.of(context) == TextDirection.rtl
                ? Icons.chevron_left_rounded
                : Icons.chevron_right_rounded,
            color: color,
            size: 22.r,
          ),
        ],
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.isOnline});

  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10.r,
      height: 10.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isOnline ? ColorManager.emerald : ColorManager.slate,
        border: Border.all(color: ColorManager.surfaceLight, width: 2),
      ),
    );
  }
}

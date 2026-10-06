import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';

/// Dark rounded surface used by every dashboard card in the design
/// (`#121A2E`, 7% white border).
class SensorCard extends StatelessWidget {
  const SensorCard({super.key, required this.child, this.padding, this.radius});

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(radius ?? 24.r),
        border: Border.all(
          color: ColorManager.pureWhite.withValues(alpha: 0.07),
        ),
      ),
      child: Padding(padding: padding ?? EdgeInsets.all(14.r), child: child),
    );
  }
}

/// Small tinted rounded square holding an icon or a short glyph.
class SensorIconBadge extends StatelessWidget {
  const SensorIconBadge({
    super.key,
    required this.color,
    required this.size,
    this.icon,
    this.glyph,
  }) : assert(icon != null || glyph != null);

  final Color color;
  final double size;
  final IconData? icon;
  final String? glyph;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(size * 0.38),
      ),
      child: icon != null
          ? Icon(icon, color: color, size: size * 0.5)
          : Text(
              glyph!,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
    );
  }
}

/// Pill showing a status label; colours cross-fade when the status changes.
class SensorStatusPill extends StatelessWidget {
  const SensorStatusPill({
    super.key,
    required this.label,
    required this.color,
    this.leading,
    this.minWidth,
  });

  final String label;
  final Color color;
  final Widget? leading;
  final double? minWidth;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      constraints: BoxConstraints(minHeight: 26.r, minWidth: minWidth ?? 0),
      padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 5.r),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leading != null) ...[leading!, SizedBox(width: 6.r)],
          Flexible(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                label,
                key: ValueKey(label),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Coloured dot + caption, used for chart legends.
class SensorLegendItem extends StatelessWidget {
  const SensorLegendItem({super.key, required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.r,
          height: 8.r,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 5.r),
        Text(
          label,
          style: TextStyle(fontSize: 11.sp, color: ColorManager.slate),
        ),
      ],
    );
  }
}

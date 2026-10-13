import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';

/// Figma: "Refresh btn" (gradient) / "Event History btn" (surface) —
/// icon stacked above a short label. Scales down slightly while pressed.
class SnapshotActionButton extends StatefulWidget {
  const SnapshotActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.primary = false,
    this.busy = false,
  });

  final String label;
  final IconData icon;

  /// `null` disables the button.
  final VoidCallback? onPressed;
  final bool primary;

  /// Spins the icon to signal work in progress.
  final bool busy;

  @override
  State<SnapshotActionButton> createState() => _SnapshotActionButtonState();
}

class _SnapshotActionButtonState extends State<SnapshotActionButton>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late final AnimationController _spin = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncSpin();
  }

  @override
  void didUpdateWidget(SnapshotActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncSpin();
  }

  void _syncSpin() {
    final spin = widget.busy && !MediaQuery.disableAnimationsOf(context);
    if (spin && !_spin.isAnimating) {
      _spin.repeat();
    } else if (!spin && _spin.isAnimating) {
      _spin
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final primary = widget.primary;
    final radius = BorderRadius.circular(20.r);
    final foreground = primary ? ColorManager.ink : ColorManager.pureWhite;
    final iconColor = primary ? ColorManager.ink : ColorManager.sky;
    final enabled = widget.onPressed != null;

    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.label,
      excludeSemantics: true,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 120),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: enabled || widget.busy ? 1 : 0.5,
          child: Material(
            type: MaterialType.transparency,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: radius,
                color: primary ? null : ColorManager.surface,
                gradient: primary ? ColorManager.primaryGradient : null,
                border: primary
                    ? null
                    : Border.all(
                        color: ColorManager.pureWhite.withValues(alpha: 0.07),
                      ),
                boxShadow: primary
                    ? [
                        BoxShadow(
                          color: ColorManager.sky.withValues(alpha: 0.25),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : null,
              ),
              child: InkWell(
                borderRadius: radius,
                onTap: widget.onPressed,
                onHighlightChanged: _setPressed,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 58.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.r,
                      vertical: 8.r,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RotationTransition(
                          turns: _spin,
                          child: Icon(widget.icon, size: 20.r, color: iconColor),
                        ),
                        SizedBox(height: 4.r),
                        Text(
                          widget.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: foreground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

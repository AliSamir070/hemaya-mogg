import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/resources/strings_manager.dart';
import '../common/sensor_card.dart';

/// Figma: "Back btn" + "Sensor" title + "Live · Updated just now",
/// with the "Online" pill on the trailing side.
class SensorDetailsHeader extends StatelessWidget {
  const SensorDetailsHeader({
    super.key,
    required this.title,
    required this.lastUpdated,
    required this.isOnline,
    required this.onBack,
  });

  final String title;
  final DateTime lastUpdated;
  final bool isOnline;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _BackButton(onPressed: onBack),
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
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  '${StringsManager.live} · ${_updatedLabel(lastUpdated)}',
                  key: ValueKey(lastUpdated),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp, color: ColorManager.slate),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8.r),
        SensorStatusPill(
          label: isOnline ? StringsManager.online : StringsManager.offline,
          color: isOnline ? ColorManager.emerald : ColorManager.slate,
          leading: LiveDot(
            color: isOnline ? ColorManager.emerald : ColorManager.slate,
            animate: isOnline,
          ),
        ),
      ],
    );
  }

  static String _updatedLabel(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inSeconds < 60) {
      return StringsManager.updatedJustNow;
    }
    if (diff.inMinutes < 60) {
      return StringsManager.updatedAgo('${diff.inMinutes}m');
    }
    return StringsManager.updatedAgo('${diff.inHours}h');
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed});

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

/// Small dot with an expanding ripple, signalling a live connection.
class LiveDot extends StatefulWidget {
  const LiveDot({super.key, required this.color, this.animate = true});

  final Color color;
  final bool animate;

  @override
  State<LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<LiveDot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(LiveDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  void _sync() {
    final shouldAnimate =
        widget.animate && !MediaQuery.disableAnimationsOf(context);
    if (shouldAnimate && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!shouldAnimate) {
      _controller
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = 8.r;
    return SizedBox.square(
      dimension: size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _controller.value;
          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              if (t > 0)
                Transform.scale(
                  scale: 1 + 1.6 * t,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color.withValues(alpha: 0.5 * (1 - t)),
                    ),
                  ),
                ),
              child!,
            ],
          );
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

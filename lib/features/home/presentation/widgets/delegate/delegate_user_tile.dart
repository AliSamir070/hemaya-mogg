import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';
import '../../models/delegate_user_ui_model.dart';

/// Selectable row representing a person who can receive delegated alerts.
class DelegateUserTile extends StatelessWidget {
  const DelegateUserTile({
    super.key,
    required this.user,
    required this.avatarColor,
    required this.isSelected,
    required this.onTap,
  });

  final DelegateUserUiModel user;
  final Color avatarColor;
  final bool isSelected;
  final VoidCallback onTap;

  static const _duration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(18.r);

    return Semantics(
      button: true,
      selected: isSelected,
      inMutuallyExclusiveGroup: true,
      label: '${user.fullName}, ${user.email}',
      excludeSemantics: true,
      child: Material(
        color: ColorManager.surface,
        animationDuration: _duration,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: isSelected
              ? BorderSide(
                  color: ColorManager.sky.withValues(alpha: 0.6),
                  width: 1.6,
                )
              : BorderSide(
                  color: ColorManager.pureWhite.withValues(alpha: 0.07),
                ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: ColorManager.sky.withValues(alpha: 0.1),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 60.r),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.r, 10.r, 14.r, 10.r),
              child: Row(
                children: [
                  _InitialsAvatar(initials: user.initials, color: avatarColor),
                  SizedBox(width: 12.r),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          user.fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorManager.pureWhite,
                          ),
                        ),
                        SizedBox(height: 2.r),
                        Text(
                          user.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: ColorManager.slate,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.r),
                  _SelectionIndicator(isSelected: isSelected),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({required this.initials, required this.color});

  final String initials;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.r,
      height: 36.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.6)]),
      ),
      child: Text(
        initials,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: ColorManager.ink,
        ),
      ),
    );
  }
}

class _SelectionIndicator extends StatelessWidget {
  const _SelectionIndicator({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: DelegateUserTile._duration,
      width: 22.r,
      height: 22.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? ColorManager.sky : Colors.transparent,
        border: isSelected
            ? null
            : Border.all(
                color: ColorManager.slate.withValues(alpha: 0.4),
                width: 1.5,
              ),
      ),
      child: AnimatedScale(
        duration: DelegateUserTile._duration,
        scale: isSelected ? 1 : 0,
        child: Icon(Icons.check_rounded, size: 14.r, color: ColorManager.ink),
      ),
    );
  }
}

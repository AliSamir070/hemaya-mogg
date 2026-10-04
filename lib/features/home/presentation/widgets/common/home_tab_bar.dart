import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/resources/strings_manager.dart';
import '../../utils/home_layout.dart';

enum HomeTab {
  devices(StringsManager.devicesTab),
  delegate(StringsManager.delegateTab);

  const HomeTab(this.label);

  final String label;
}

/// Floating pill-shaped segmented tab bar with a sliding gradient indicator.
class HomeTabBar extends StatelessWidget {
  const HomeTabBar({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  final HomeTab currentTab;
  final ValueChanged<HomeTab> onTabSelected;

  static const _animationDuration = Duration(milliseconds: 280);

  @override
  Widget build(BuildContext context) {
    final isFirst = currentTab.index == 0;

    return SafeArea(
      top: false,
      minimum: EdgeInsets.only(bottom: 16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: HomeLayout.gutter),
        child: Align(
          alignment: Alignment.bottomCenter,
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: HomeLayout.tabBarMaxWidth,
            ),
            child: Container(
              height: 64.r,
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: ColorManager.surface,
                borderRadius: BorderRadius.circular(32.r),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x66000000),
                    blurRadius: 24,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  AnimatedAlign(
                    duration: _animationDuration,
                    curve: Curves.easeOutCubic,
                    alignment: isFirst
                        ? AlignmentDirectional.centerStart
                        : AlignmentDirectional.centerEnd,
                    child: FractionallySizedBox(
                      widthFactor: 1 / HomeTab.values.length,
                      heightFactor: 1,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: ColorManager.primaryGradient,
                          borderRadius: BorderRadius.circular(22.r),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      for (final tab in HomeTab.values)
                        Expanded(
                          child: _TabItem(
                            label: tab.label,
                            isSelected: tab == currentTab,
                            duration: _animationDuration,
                            onTap: () => onTabSelected(tab),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.duration,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final Duration duration;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      child: InkWell(
        onTap: isSelected ? null : onTap,
        borderRadius: BorderRadius.circular(22.r),
        splashColor: ColorManager.sky.withValues(alpha: 0.1),
        highlightColor: Colors.transparent,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: duration,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? ColorManager.ink : ColorManager.slate,
            ),
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ),
      ),
    );
  }
}

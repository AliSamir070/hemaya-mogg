import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';

/// Labelled, tappable date box ("FROM" / "TO") opening a date picker.
class DelegationDateField extends StatelessWidget {
  const DelegationDateField({
    super.key,
    required this.label,
    required this.date,
    required this.onTap,
  });

  final String label;
  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final formattedDate = MaterialLocalizations.of(context).formatShortDate(date);
    final radius = BorderRadius.circular(16.r);

    return Semantics(
      button: true,
      label: '$label, $formattedDate',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(fontSize: 10.sp, color: ColorManager.slate),
          ),
          SizedBox(height: 6.r),
          Material(
            color: ColorManager.surface,
            shape: RoundedRectangleBorder(
              borderRadius: radius,
              side: BorderSide(
                color: ColorManager.pureWhite.withValues(alpha: 0.08),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              splashColor: ColorManager.sky.withValues(alpha: 0.1),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 50.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.r, vertical: 8.r),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16.r,
                        color: ColorManager.sky,
                      ),
                      SizedBox(width: 8.r),
                      Expanded(
                        child: Text(
                          formattedDate,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorManager.pureWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

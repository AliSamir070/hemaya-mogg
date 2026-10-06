import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/resources/strings_manager.dart';
import '../common/gradient_button.dart';

/// Figma: "00c · eWeLink Home — Delegate Tab (Date Picker)".
///
/// Custom bottom sheet for picking delegation start and end dates.
class DelegationDatePickerSheet extends StatefulWidget {
  const DelegationDatePickerSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  final String title;
  final String subtitle;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  static Future<DateTime?> show({
    required BuildContext context,
    required String title,
    required String subtitle,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DelegationDatePickerSheet(
        title: title,
        subtitle: subtitle,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
      ),
    );
  }

  @override
  State<DelegationDatePickerSheet> createState() =>
      _DelegationDatePickerSheetState();
}

class _DelegationDatePickerSheetState extends State<DelegationDatePickerSheet> {
  late DateTime _selectedDate;
  late DateTime _displayedMonth;

  static const List<String> _weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateUtils.dateOnly(widget.initialDate);
    _displayedMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  bool get _canGoToPreviousMonth {
    final prevMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1);
    final firstMonth = DateTime(widget.firstDate.year, widget.firstDate.month);
    return !prevMonth.isBefore(firstMonth);
  }

  bool get _canGoToNextMonth {
    final nextMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1);
    final lastMonth = DateTime(widget.lastDate.year, widget.lastDate.month);
    return !nextMonth.isAfter(lastMonth);
  }

  void _previousMonth() {
    if (_canGoToPreviousMonth) {
      setState(() {
        _displayedMonth = DateTime(
          _displayedMonth.year,
          _displayedMonth.month - 1,
        );
      });
    }
  }

  void _nextMonth() {
    if (_canGoToNextMonth) {
      setState(() {
        _displayedMonth = DateTime(
          _displayedMonth.year,
          _displayedMonth.month + 1,
        );
      });
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isDateSelectable(DateTime date) {
    final dayOnly = DateUtils.dateOnly(date);
    final firstDayOnly = DateUtils.dateOnly(widget.firstDate);
    final lastDayOnly = DateUtils.dateOnly(widget.lastDate);
    return !dayOnly.isBefore(firstDayOnly) && !dayOnly.isAfter(lastDayOnly);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final daysInMonth = DateUtils.getDaysInMonth(
      _displayedMonth.year,
      _displayedMonth.month,
    );
    final firstDayOfMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
      1,
    );
    // DateTime.weekday: Mon=1..Sun=7 -> map to Sun=0..Sat=6
    final startingWeekday = firstDayOfMonth.weekday % 7;
    final totalGridItems = startingWeekday + daysInMonth;

    return Container(
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        border: Border.all(
          color: ColorManager.pureWhite.withValues(alpha: 0.08),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.r, 12.r, 24.r, bottomInset + 16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Grabber
              Center(
                child: Container(
                  width: 48.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: ColorManager.slate.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.r),

              // Title & Subtitle
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.pureWhite,
                ),
              ),
              SizedBox(height: 4.r),
              Text(
                widget.subtitle,
                style: TextStyle(fontSize: 12.sp, color: ColorManager.slate),
              ),
              SizedBox(height: 20.r),

              // Month Navigator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _canGoToPreviousMonth ? _previousMonth : null,
                    icon: Icon(
                      Icons.chevron_left_rounded,
                      color: _canGoToPreviousMonth
                          ? ColorManager.pureWhite
                          : ColorManager.slate.withValues(alpha: 0.3),
                      size: 24.r,
                    ),
                  ),
                  Text(
                    '${_months[_displayedMonth.month - 1]} ${_displayedMonth.year}',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.pureWhite,
                    ),
                  ),
                  IconButton(
                    onPressed: _canGoToNextMonth ? _nextMonth : null,
                    icon: Icon(
                      Icons.chevron_right_rounded,
                      color: _canGoToNextMonth
                          ? ColorManager.pureWhite
                          : ColorManager.slate.withValues(alpha: 0.3),
                      size: 24.r,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.r),

              // Week Days Row
              Row(
                children: _weekDays
                    .map(
                      (day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorManager.slate,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 8.r),

              // Calendar Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: totalGridItems,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  if (index < startingWeekday) {
                    return const SizedBox.shrink();
                  }

                  final dayNumber = index - startingWeekday + 1;
                  final cellDate = DateTime(
                    _displayedMonth.year,
                    _displayedMonth.month,
                    dayNumber,
                  );
                  final isSelected = _isSameDay(cellDate, _selectedDate);
                  final isSelectable = _isDateSelectable(cellDate);

                  return GestureDetector(
                    onTap: isSelectable
                        ? () => setState(() => _selectedDate = cellDate)
                        : null,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? ColorManager.sky
                            : Colors.transparent,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$dayNumber',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isSelected
                              ? ColorManager.ink
                              : isSelectable
                              ? ColorManager.pureWhite
                              : ColorManager.slate.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20.r),

              // Confirm Button
              GradientButton(
                label: StringsManager.confirmDate,
                onPressed: () => Navigator.of(context).pop(_selectedDate),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

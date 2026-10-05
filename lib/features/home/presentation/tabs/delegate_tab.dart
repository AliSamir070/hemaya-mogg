import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/strings_manager.dart';
import '../models/delegate_user_ui_model.dart';
import '../utils/home_layout.dart';
import '../widgets/common/gradient_button.dart';
import '../widgets/common/home_texts.dart';
import '../widgets/delegate/delegate_user_tile.dart';
import '../widgets/delegate/delegation_date_field.dart';
import '../widgets/delegate/delegation_date_picker_sheet.dart';
import '../widgets/delegate/delegation_summary_card.dart';

/// Figma: "00b · eWeLink Home — Delegate Tab" & "00c · Date Picker".
///
/// Lets the user pick a person and a period to delegate their alerts to.
class DelegateTab extends StatefulWidget {
  const DelegateTab({
    super.key,
    required this.users,
    required this.onActivateDelegation,
  });

  final List<DelegateUserUiModel> users;
  final void Function(DelegateUserUiModel user, DateTimeRange period)
      onActivateDelegation;

  @override
  State<DelegateTab> createState() => _DelegateTabState();
}

class _DelegateTabState extends State<DelegateTab> {
  static const _avatarPalette = [
    ColorManager.sky,
    ColorManager.orange,
    ColorManager.indigo,
  ];
  static const _defaultPeriod = Duration(days: 7);
  static const _maxPeriodAhead = Duration(days: 365);

  String? _selectedUserId;
  late DateTime _from;
  late DateTime _to;

  @override
  void initState() {
    super.initState();
    _from = DateUtils.dateOnly(DateTime.now());
    _to = _from.add(_defaultPeriod);
  }

  DelegateUserUiModel? get _selectedUser {
    for (final user in widget.users) {
      if (user.id == _selectedUserId) return user;
    }
    return null;
  }

  Future<void> _pickFromDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final picked = await DelegationDatePickerSheet.show(
      context: context,
      title: StringsManager.selectFromDate,
      subtitle: StringsManager.delegationBeginHint,
      initialDate: _from,
      firstDate: today,
      lastDate: today.add(_maxPeriodAhead),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _from = picked;
      if (_to.isBefore(_from)) _to = _from.add(_defaultPeriod);
    });
  }

  Future<void> _pickToDate() async {
    final picked = await DelegationDatePickerSheet.show(
      context: context,
      title: StringsManager.selectToDate,
      subtitle: StringsManager.delegationEndHint,
      initialDate: _to,
      firstDate: _from,
      lastDate: _from.add(_maxPeriodAhead),
    );
    if (picked == null || !mounted) return;
    setState(() => _to = picked);
  }

  String _summary(DelegateUserUiModel? user) {
    if (user == null) return StringsManager.choosePersonHint;
    final localizations = MaterialLocalizations.of(context);
    return StringsManager.delegationSummary(
      user.fullName,
      localizations.formatShortMonthDay(_from),
      localizations.formatShortMonthDay(_to),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedUser = _selectedUser;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontal = HomeLayout.horizontalPadding(
          constraints.maxWidth,
          HomeLayout.delegateMaxContentWidth,
        );

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(horizontal, 14.r, horizontal, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HomeTabTitle(StringsManager.delegate),
                    SizedBox(height: 21.r),
                    const SectionLabel(StringsManager.chooseAPerson),
                    SizedBox(height: 10.r),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: horizontal),
              sliver: widget.users.isEmpty
                  ? SliverToBoxAdapter(child: _EmptyUsers())
                  : SliverList.separated(
                      itemCount: widget.users.length,
                      separatorBuilder: (_, _) => SizedBox(height: 10.r),
                      itemBuilder: (context, index) {
                        final user = widget.users[index];
                        return DelegateUserTile(
                          key: ValueKey(user.id),
                          user: user,
                          avatarColor:
                              _avatarPalette[index % _avatarPalette.length],
                          isSelected: user.id == _selectedUserId,
                          onTap: () =>
                              setState(() => _selectedUserId = user.id),
                        );
                      },
                    ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                horizontal,
                18.r,
                horizontal,
                bottomInset + 16.r,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SectionLabel(StringsManager.delegationPeriod),
                    SizedBox(height: 8.r),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: DelegationDateField(
                            label: StringsManager.from,
                            date: _from,
                            onTap: _pickFromDate,
                          ),
                        ),
                        SizedBox(width: 24.r),
                        Expanded(
                          child: DelegationDateField(
                            label: StringsManager.to,
                            date: _to,
                            onTap: _pickToDate,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.r),
                    DelegationSummaryCard(message: _summary(selectedUser)),
                    SizedBox(height: 16.r),
                    GradientButton(
                      label: StringsManager.activateDelegation,
                      onPressed: selectedUser == null
                          ? null
                          : () => widget.onActivateDelegation(
                                selectedUser,
                                DateTimeRange(start: _from, end: _to),
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EmptyUsers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.r),
      child: Text(
        StringsManager.noPeopleAvailable,
        style: TextStyle(fontSize: 13.sp, color: ColorManager.slate),
      ),
    );
  }
}

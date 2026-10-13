import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/DI/di.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/dialog_utils.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../../core/routes_manager/routes.dart';
import '../../../sensor_details/presentation/widgets/common/sensor_details_background.dart';
import '../models/sensor_active_alarm_ui_model.dart';
import '../models/sensor_alarm_ui_model.dart';
import '../utils/sensor_alarm_events_layout.dart';
import '../viewmodels/sensor_alarm_events/sensor_alarm_events_view_model_cubit.dart';
import '../widgets/filter/sensor_alarm_filter_tabs.dart';
import '../widgets/header/sensor_alarm_events_header.dart';
import '../widgets/item/sensor_alarm_card.dart';
import '../widgets/loading/sensor_alarm_events_shimmer.dart';

/// Screen displaying the sensor alarm events history.
/// Corresponds to Figma screen: "03 · Sensor Alarm Events".
class SensorAlarmEventsScreen extends StatelessWidget {
  const SensorAlarmEventsScreen({super.key, required this.args});

  final SensorAlarmEventsArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<SensorAlarmEventsViewModelCubit>()
        ..loadEvents(deviceId: args.deviceId, deviceName: args.deviceName),
      child: _SensorAlarmEventsView(args: args),
    );
  }
}

class _SensorAlarmEventsView extends StatefulWidget {
  const _SensorAlarmEventsView({required this.args});

  final SensorAlarmEventsArgs args;

  @override
  State<_SensorAlarmEventsView> createState() =>
      _SensorAlarmEventsViewState();
}

class _SensorAlarmEventsViewState extends State<_SensorAlarmEventsView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _playEntrance();
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  void _playEntrance() {
    if (!mounted) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _entrance.value = 1;
    } else if (_entrance.isDismissed) {
      _entrance.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: ColorManager.homeBackground,
        body: Stack(
          children: [
            const Positioned.fill(child: SensorDetailsBackground()),
            SafeArea(
              bottom: false,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final size = SensorAlarmEventsLayout.sizeFor(
                    constraints.maxWidth,
                  );
                  final horizontal =
                      SensorAlarmEventsLayout.horizontalPadding(
                    constraints.maxWidth,
                    SensorAlarmEventsLayout.maxContentWidth(size),
                  );
                  final bottomInset = MediaQuery.paddingOf(context).bottom;
                  final padding = EdgeInsets.fromLTRB(
                    horizontal,
                    12.r,
                    horizontal,
                    bottomInset + 24.r,
                  );

                  return BlocConsumer<
                    SensorAlarmEventsViewModelCubit,
                    SensorAlarmEventsViewModelState
                  >(
                    listener: (context, state) {
                      if (state is SensorAlarmEventsSuccess) {
                        _playEntrance();
                        if (state.acknowledgedEventId != null) {
                          DialogUtils.showToast(
                            StringsManager.alarmAcknowledgedToast,
                          );
                        }
                      }
                    },
                    builder: (context, state) => switch (state) {
                      SensorAlarmEventsInitial() ||
                      SensorAlarmEventsLoading() =>
                        SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: padding,
                          child: const SensorAlarmEventsShimmer(),
                        ),
                      SensorAlarmEventsError(:final message) => _ErrorView(
                        message: message,
                        onRetry: () => context
                            .read<SensorAlarmEventsViewModelCubit>()
                            .loadEvents(
                              deviceId: widget.args.deviceId,
                              deviceName: widget.args.deviceName,
                            ),
                      ),
                      SensorAlarmEventsSuccess(
                        :final filter,
                        :final filteredEvents,
                      ) =>
                        _buildContent(
                          context,
                          filter: filter,
                          events: filteredEvents,
                          padding: padding,
                          size: size,
                        ),
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context, {
    required SensorAlarmFilter filter,
    required List<SensorAlarmItemUiModel> events,
    required EdgeInsets padding,
    required SensorAlarmEventsLayoutSize size,
  }) {
    final cubit = context.read<SensorAlarmEventsViewModelCubit>();

    return RefreshIndicator(
      color: ColorManager.sky,
      backgroundColor: ColorManager.surface,
      onRefresh: cubit.refresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(padding.left, padding.top, padding.right, 0),
            sliver: SliverToBoxAdapter(
              child: StaggeredEntrance(
                animation: _entrance,
                index: 0,
                count: 4,
                child: SensorAlarmEventsHeader(
                  deviceName: widget.args.deviceName,
                  onBack: () => Navigator.of(context).maybePop(),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(padding.left, 20.r, padding.right, 0),
            sliver: SliverToBoxAdapter(
              child: StaggeredEntrance(
                animation: _entrance,
                index: 1,
                count: 4,
                child: SensorAlarmFilterTabs(
                  selectedFilter: filter,
                  onFilterChanged: cubit.setFilter,
                ),
              ),
            ),
          ),
          if (events.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.notifications_off_rounded,
                      size: 44.r,
                      color: ColorManager.slate,
                    ),
                    SizedBox(height: 12.r),
                    Text(
                      StringsManager.noAlarmEventsFound,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ColorManager.slate,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (size == SensorAlarmEventsLayoutSize.expanded)
            SliverPadding(
              padding: EdgeInsets.fromLTRB(padding.left, 18.r, padding.right, padding.bottom),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.r,
                  crossAxisSpacing: 12.r,
                  mainAxisExtent: 88.r,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = events[index];
                    return StaggeredEntrance(
                      animation: _entrance,
                      index: (index + 2).clamp(0, 8),
                      count: 9,
                      child: SensorAlarmCard(
                        event: item,
                        onAcknowledge: () => cubit.acknowledgeEvent(item.id),
                        onTap: () async {
                          if (!item.isAcknowledged) {
                            final acknowledged = await Navigator.of(context).pushNamed(
                              Routes.sensorActiveAlarmRoute,
                              arguments: SensorActiveAlarmArgs(
                                event: item,
                                deviceName: widget.args.deviceName,
                                thresholdValueLabel: item.subtitle,
                              ),
                            );
                            if (acknowledged == true) {
                              cubit.acknowledgeEvent(item.id);
                            }
                          }
                        },
                      ),
                    );
                  },
                  childCount: events.length,
                ),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(padding.left, 18.r, padding.right, padding.bottom),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = events[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.r),
                      child: StaggeredEntrance(
                        animation: _entrance,
                        index: (index + 2).clamp(0, 8),
                        count: 9,
                        child: SensorAlarmCard(
                          event: item,
                          onAcknowledge: () => cubit.acknowledgeEvent(item.id),
                          onTap: () async {
                            if (!item.isAcknowledged) {
                              final acknowledged = await Navigator.of(context).pushNamed(
                                Routes.sensorActiveAlarmRoute,
                                arguments: SensorActiveAlarmArgs(
                                  event: item,
                                  deviceName: widget.args.deviceName,
                                  thresholdValueLabel: item.subtitle,
                                ),
                              );
                              if (acknowledged == true) {
                                cubit.acknowledgeEvent(item.id);
                              }
                            }
                          },
                        ),
                      ),
                    );
                  },
                  childCount: events.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 40.r,
              color: ColorManager.slate,
            ),
            SizedBox(height: 12.r),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorManager.slate, fontSize: 14.sp),
            ),
            SizedBox(height: 16.r),
            TextButton(
              onPressed: onRetry,
              child: Text(
                StringsManager.retry,
                style: TextStyle(color: ColorManager.sky, fontSize: 14.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

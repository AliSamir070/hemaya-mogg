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
import '../models/camera_active_alarm_ui_model.dart';
import '../models/camera_event_ui_model.dart';
import '../utils/camera_event_history_layout.dart';
import '../viewmodels/camera_event_history/camera_event_history_view_model_cubit.dart';
import '../widgets/filter/camera_event_filter_tabs.dart';
import '../widgets/header/camera_event_history_header.dart';
import '../widgets/item/camera_event_card.dart';
import '../widgets/loading/camera_event_history_shimmer.dart';

/// Screen displaying the camera event snapshots history.
/// Corresponds to Figma screen: "05 · Camera Event History".
class CameraEventHistoryScreen extends StatelessWidget {
  const CameraEventHistoryScreen({super.key, required this.args});

  final CameraEventHistoryArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<CameraEventHistoryViewModelCubit>()
        ..loadEvents(deviceId: args.deviceId, deviceName: args.deviceName),
      child: _CameraEventHistoryView(args: args),
    );
  }
}

class _CameraEventHistoryView extends StatefulWidget {
  const _CameraEventHistoryView({required this.args});

  final CameraEventHistoryArgs args;

  @override
  State<_CameraEventHistoryView> createState() =>
      _CameraEventHistoryViewState();
}

class _CameraEventHistoryViewState extends State<_CameraEventHistoryView>
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
                  final size = CameraEventHistoryLayout.sizeFor(
                    constraints.maxWidth,
                  );
                  final horizontal =
                      CameraEventHistoryLayout.horizontalPadding(
                    constraints.maxWidth,
                    CameraEventHistoryLayout.maxContentWidth(size),
                  );
                  final bottomInset = MediaQuery.paddingOf(context).bottom;
                  final padding = EdgeInsets.fromLTRB(
                    horizontal,
                    12.r,
                    horizontal,
                    bottomInset + 24.r,
                  );

                  return BlocConsumer<
                    CameraEventHistoryViewModelCubit,
                    CameraEventHistoryViewModelState
                  >(
                    listener: (context, state) {
                      if (state is CameraEventHistorySuccess) {
                        _playEntrance();
                        if (state.acknowledgedEventId != null) {
                          DialogUtils.showToast(
                            StringsManager.eventAcknowledgedToast,
                          );
                        }
                      }
                    },
                    builder: (context, state) => switch (state) {
                      CameraEventHistoryInitial() ||
                      CameraEventHistoryLoading() =>
                        SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: padding,
                          child: const CameraEventHistoryShimmer(),
                        ),
                      CameraEventHistoryError(:final message) => _ErrorView(
                        message: message,
                        onRetry: () => context
                            .read<CameraEventHistoryViewModelCubit>()
                            .loadEvents(
                              deviceId: widget.args.deviceId,
                              deviceName: widget.args.deviceName,
                            ),
                      ),
                      CameraEventHistorySuccess(
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
    required CameraEventFilter filter,
    required List<CameraEventItemUiModel> events,
    required EdgeInsets padding,
    required CameraEventHistoryLayoutSize size,
  }) {
    final cubit = context.read<CameraEventHistoryViewModelCubit>();

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
                child: CameraEventHistoryHeader(
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
                child: CameraEventFilterTabs(
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
                      Icons.history_toggle_off_rounded,
                      size: 44.r,
                      color: ColorManager.slate,
                    ),
                    SizedBox(height: 12.r),
                    Text(
                      StringsManager.noEventsFound,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ColorManager.slate,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (size == CameraEventHistoryLayoutSize.expanded)
            SliverPadding(
              padding: EdgeInsets.fromLTRB(padding.left, 18.r, padding.right, padding.bottom),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.r,
                  crossAxisSpacing: 12.r,
                  mainAxisExtent: 96.r,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = events[index];
                    return StaggeredEntrance(
                      animation: _entrance,
                      index: (index + 2).clamp(0, 8),
                      count: 9,
                      child: CameraEventCard(
                        event: item,
                        onAcknowledge: () => cubit.acknowledgeEvent(item.id),
                        onTap: () async {
                          if (!item.isAcknowledged) {
                            final acknowledged = await Navigator.of(context).pushNamed(
                              Routes.cameraActiveAlarmRoute,
                              arguments: CameraActiveAlarmArgs(
                                event: item,
                                deviceName: widget.args.deviceName,
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
                        child: CameraEventCard(
                          event: item,
                          onAcknowledge: () => cubit.acknowledgeEvent(item.id),
                          onTap: () async {
                            if (!item.isAcknowledged) {
                              final acknowledged = await Navigator.of(context).pushNamed(
                                Routes.cameraActiveAlarmRoute,
                                arguments: CameraActiveAlarmArgs(
                                  event: item,
                                  deviceName: widget.args.deviceName,
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

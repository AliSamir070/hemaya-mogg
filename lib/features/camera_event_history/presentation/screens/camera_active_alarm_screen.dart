import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/DI/di.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/dialog_utils.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../sensor_alarm_events/presentation/widgets/active_alarm/active_alarm_header.dart';
import '../../../sensor_alarm_events/presentation/widgets/active_alarm/alarm_action_button.dart';
import '../../../sensor_alarm_events/presentation/widgets/active_alarm/sensor_active_alarm_shimmer.dart';
import '../../../sensor_details/presentation/widgets/common/sensor_details_background.dart';
import '../models/camera_active_alarm_ui_model.dart';
import '../models/camera_event_ui_model.dart';
import '../utils/camera_event_history_layout.dart';
import '../viewmodels/camera_active_alarm/camera_active_alarm_view_model_cubit.dart';
import '../widgets/active_alarm/camera_active_alarm_pulse.dart';
import '../widgets/active_alarm/camera_active_alarm_value_card.dart';

/// Screen displaying the active warning / alarm state for an unacknowledged camera event.
/// Corresponds to Figma screen: "08b · Active Alarm — Camera · Pulse 1".
class CameraActiveAlarmScreen extends StatelessWidget {
  const CameraActiveAlarmScreen({super.key, required this.args});

  final CameraActiveAlarmArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<CameraActiveAlarmViewModelCubit>()
        ..initAlarm(args),
      child: _CameraActiveAlarmView(args: args),
    );
  }
}

class _CameraActiveAlarmView extends StatefulWidget {
  const _CameraActiveAlarmView({required this.args});

  final CameraActiveAlarmArgs args;

  @override
  State<_CameraActiveAlarmView> createState() => _CameraActiveAlarmViewState();
}

class _CameraActiveAlarmViewState extends State<_CameraActiveAlarmView>
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
                    CameraActiveAlarmViewModelCubit,
                    CameraActiveAlarmViewModelState
                  >(
                    listener: (context, state) {
                      if (state is CameraActiveAlarmSuccess) {
                        _playEntrance();
                        if (state.isAcknowledgedSuccess) {
                          DialogUtils.showToast(
                            StringsManager.eventAcknowledgedToast,
                          );
                          Navigator.of(context).pop(true);
                        }
                      }
                    },
                    builder: (context, state) => switch (state) {
                      CameraActiveAlarmInitial() ||
                      CameraActiveAlarmLoading() =>
                        SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: padding,
                          child: const SensorActiveAlarmShimmer(),
                        ),
                      CameraActiveAlarmError(:final message) => _ErrorView(
                        message: message,
                        onRetry: () => context
                            .read<CameraActiveAlarmViewModelCubit>()
                            .initAlarm(widget.args),
                      ),
                      CameraActiveAlarmSuccess(
                        :final alarm,
                        :final isAcknowledging,
                      ) =>
                        _buildContent(
                          context,
                          alarm: alarm,
                          isAcknowledging: isAcknowledging,
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
    required CameraActiveAlarmUiModel alarm,
    required bool isAcknowledging,
    required EdgeInsets padding,
    required CameraEventHistoryLayoutSize size,
  }) {
    final cubit = context.read<CameraActiveAlarmViewModelCubit>();
    final isPerson = alarm.event.type == CameraEventType.person;

    final header = StaggeredEntrance(
      animation: _entrance,
      index: 0,
      count: 5,
      child: ActiveAlarmHeader(
        onClose: () => Navigator.of(context).maybePop(),
      ),
    );

    final sirenSection = StaggeredEntrance(
      animation: _entrance,
      index: 1,
      count: 5,
      child: CameraActiveAlarmPulse(isPerson: isPerson),
    );

    final textSection = StaggeredEntrance(
      animation: _entrance,
      index: 2,
      count: 5,
      child: Column(
        children: [
          Text(
            alarm.deviceName.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: ColorManager.slate,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 6.r),
          Text(
            alarm.event.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.w700,
              color: ColorManager.pureWhite,
            ),
          ),
          SizedBox(height: 6.r),
          Text(
            StringsManager.unrecognizedActivityNearDoor,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              color: ColorManager.slate,
            ),
          ),
        ],
      ),
    );

    final valueCard = StaggeredEntrance(
      animation: _entrance,
      index: 3,
      count: 5,
      child: CameraActiveAlarmValueCard(
        detectionType: alarm.detectionTypeLabel,
        detectionDetail: alarm.detectionDetailLabel,
      ),
    );

    final button = StaggeredEntrance(
      animation: _entrance,
      index: 4,
      count: 5,
      child: AlarmActionButton(
        label: isAcknowledging
            ? StringsManager.acknowledging
            : StringsManager.acknowledgeAlarm,
        isTemperature: true, // Uses red alarm gradient
        onPressed: isAcknowledging ? null : cubit.acknowledge,
      ),
    );

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header,
          SizedBox(height: 20.r),
          if (size == CameraEventHistoryLayoutSize.expanded) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: sirenSection),
                SizedBox(width: 24.r),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      textSection,
                      SizedBox(height: 24.r),
                      valueCard,
                      SizedBox(height: 24.r),
                      button,
                    ],
                  ),
                ),
              ],
            ),
          ] else ...[
            sirenSection,
            SizedBox(height: 18.r),
            textSection,
            SizedBox(height: 24.r),
            valueCard,
            SizedBox(height: 28.r),
            button,
          ],
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

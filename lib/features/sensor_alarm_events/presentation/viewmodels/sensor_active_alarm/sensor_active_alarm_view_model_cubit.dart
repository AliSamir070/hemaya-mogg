import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../camera_event_history/presentation/utils/camera_event_time_formatter.dart';
import '../../models/sensor_active_alarm_ui_model.dart';

part 'sensor_active_alarm_view_model_state.dart';

@injectable
class SensorActiveAlarmViewModelCubit
    extends Cubit<SensorActiveAlarmViewModelState> {
  SensorActiveAlarmViewModelCubit()
      : super(const SensorActiveAlarmInitial());

  SensorActiveAlarmUiModel? _current;

  void initAlarm(SensorActiveAlarmArgs args) {
    emit(const SensorActiveAlarmLoading());

    // Extract current reading and threshold comparison from subtitle or arguments.
    // e.g. "29.4°C — above 28°C max"
    final subtitleParts = args.event.subtitle.split('—');
    final readingStr = subtitleParts.isNotEmpty
        ? subtitleParts[0].trim()
        : (args.event.isTemperature ? '29.4°C' : '63% RH');

    final timeStr = CameraEventTimeFormatter.format(args.event.timestamp);
    final thresholdStr = args.thresholdValueLabel.isNotEmpty
        ? 'Threshold: ${args.thresholdValueLabel} · $timeStr'
        : 'Threshold: ${args.event.subtitle} · $timeStr';

    _current = SensorActiveAlarmUiModel(
      event: args.event,
      deviceName: args.deviceName,
      readingValueLabel: readingStr,
      thresholdDescriptionLabel: thresholdStr,
    );

    emit(SensorActiveAlarmSuccess(alarm: _current!));
  }

  Future<void> acknowledge() async {
    final current = _current;
    if (current == null) return;

    emit(SensorActiveAlarmSuccess(alarm: current, isAcknowledging: true));
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (isClosed) return;

    final updatedEvent = current.event.copyWith(isAcknowledged: true);
    _current = current.copyWith(event: updatedEvent);

    emit(
      SensorActiveAlarmSuccess(
        alarm: _current!,
        isAcknowledging: false,
        isAcknowledgedSuccess: true,
      ),
    );
  }
}

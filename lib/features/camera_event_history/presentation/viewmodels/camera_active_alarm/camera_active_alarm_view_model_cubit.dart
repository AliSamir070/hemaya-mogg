import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../models/camera_active_alarm_ui_model.dart';
import '../../models/camera_event_ui_model.dart';
import '../../utils/camera_event_time_formatter.dart';

part 'camera_active_alarm_view_model_state.dart';

@injectable
class CameraActiveAlarmViewModelCubit
    extends Cubit<CameraActiveAlarmViewModelState> {
  CameraActiveAlarmViewModelCubit()
      : super(const CameraActiveAlarmInitial());

  CameraActiveAlarmUiModel? _current;

  void initAlarm(CameraActiveAlarmArgs args) {
    emit(const CameraActiveAlarmLoading());

    final timeStr = CameraEventTimeFormatter.format(args.event.timestamp);

    // Node 63:67 = "Person" or "Motion"
    final detectionType = args.event.type == CameraEventType.person
        ? 'Person'
        : 'Motion';

    // Node 63:68 = "Detected at front door · Today · 14:40"
    final detectionDetail = 'Detected at front door · $timeStr';

    _current = CameraActiveAlarmUiModel(
      event: args.event,
      deviceName: args.deviceName,
      detectionTypeLabel: detectionType,
      detectionDetailLabel: detectionDetail,
    );

    emit(CameraActiveAlarmSuccess(alarm: _current!));
  }

  Future<void> acknowledge() async {
    final current = _current;
    if (current == null) return;

    emit(CameraActiveAlarmSuccess(alarm: current, isAcknowledging: true));
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (isClosed) return;

    final updatedEvent = current.event.copyWith(isAcknowledged: true);
    _current = current.copyWith(event: updatedEvent);

    emit(
      CameraActiveAlarmSuccess(
        alarm: _current!,
        isAcknowledging: false,
        isAcknowledgedSuccess: true,
      ),
    );
  }
}

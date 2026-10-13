import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../models/sensor_alarm_events_dummy_data.dart';
import '../../models/sensor_alarm_ui_model.dart';

part 'sensor_alarm_events_view_model_state.dart';

@injectable
class SensorAlarmEventsViewModelCubit
    extends Cubit<SensorAlarmEventsViewModelState> {
  SensorAlarmEventsViewModelCubit()
      : super(const SensorAlarmEventsInitial());

  List<SensorAlarmItemUiModel> _events = [];
  SensorAlarmFilter _filter = SensorAlarmFilter.all;

  Future<void> loadEvents({
    required String deviceId,
    required String deviceName,
  }) async {
    emit(const SensorAlarmEventsLoading());
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (isClosed) return;

    _events = SensorAlarmEventsDummyData.events();
    _filter = SensorAlarmFilter.all;
    emit(
      SensorAlarmEventsSuccess(
        events: List.unmodifiable(_events),
        filter: _filter,
      ),
    );
  }

  void setFilter(SensorAlarmFilter filter) {
    if (_filter == filter) return;
    _filter = filter;
    emit(
      SensorAlarmEventsSuccess(
        events: List.unmodifiable(_events),
        filter: _filter,
      ),
    );
  }

  Future<void> acknowledgeEvent(String eventId) async {
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index == -1 || _events[index].isAcknowledged) return;

    final updatedItem = _events[index].copyWith(isAcknowledged: true);
    final updatedList = List<SensorAlarmItemUiModel>.from(_events);
    updatedList[index] = updatedItem;
    _events = updatedList;

    emit(
      SensorAlarmEventsSuccess(
        events: List.unmodifiable(_events),
        filter: _filter,
        acknowledgedEventId: eventId,
      ),
    );
  }

  Future<void> refresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (isClosed) return;
    _events = SensorAlarmEventsDummyData.events();
    emit(
      SensorAlarmEventsSuccess(
        events: List.unmodifiable(_events),
        filter: _filter,
      ),
    );
  }
}

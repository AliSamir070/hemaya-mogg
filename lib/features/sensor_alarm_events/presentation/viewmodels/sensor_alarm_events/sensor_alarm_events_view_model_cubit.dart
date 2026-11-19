import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/resources/api_result.dart';
import '../../../domain/usecase/get_sensor_alarm_events_use_case.dart';
import '../../models/sensor_alarm_ui_model.dart';

part 'sensor_alarm_events_view_model_state.dart';

@injectable
class SensorAlarmEventsViewModelCubit
    extends Cubit<SensorAlarmEventsViewModelState> {
  final GetSensorAlarmEventsUseCase _getSensorAlarmEventsUseCase;

  SensorAlarmEventsViewModelCubit(this._getSensorAlarmEventsUseCase)
      : super(const SensorAlarmEventsInitial());

  List<SensorAlarmItemUiModel> _events = [];
  SensorAlarmFilter _filter = SensorAlarmFilter.all;
  String _currentDeviceId = '';

  Future<void> loadEvents({
    required String deviceId,
    required String deviceName,
  }) async {
    _currentDeviceId = deviceId;
    emit(const SensorAlarmEventsLoading());

    final params = <String, dynamic>{};
    if (deviceId.isNotEmpty) {
      params['deviceId'] = deviceId;
    }

    final result = await _getSensorAlarmEventsUseCase(params: params);
    if (isClosed) return;

    switch (result) {
      case Success(response: final entities):
        _events = entities
            .map((entity) => SensorAlarmItemUiModel.fromEntity(entity))
            .toList();
        _filter = SensorAlarmFilter.all;
        emit(
          SensorAlarmEventsSuccess(
            events: List.unmodifiable(_events),
            filter: _filter,
          ),
        );
      case Error(message: final errorMessage):
        emit(SensorAlarmEventsError(errorMessage));
    }
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
    final params = <String, dynamic>{};
    if (_currentDeviceId.isNotEmpty) {
      params['deviceId'] = _currentDeviceId;
    }

    final result = await _getSensorAlarmEventsUseCase(params: params);
    if (isClosed) return;

    switch (result) {
      case Success(response: final entities):
        _events = entities
            .map((entity) => SensorAlarmItemUiModel.fromEntity(entity))
            .toList();
        emit(
          SensorAlarmEventsSuccess(
            events: List.unmodifiable(_events),
            filter: _filter,
          ),
        );
      case Error(message: final errorMessage):
        emit(SensorAlarmEventsError(errorMessage));
    }
  }
}

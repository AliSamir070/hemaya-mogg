import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../models/camera_event_history_dummy_data.dart';
import '../../models/camera_event_ui_model.dart';

part 'camera_event_history_view_model_state.dart';

@injectable
class CameraEventHistoryViewModelCubit
    extends Cubit<CameraEventHistoryViewModelState> {
  CameraEventHistoryViewModelCubit()
      : super(const CameraEventHistoryInitial());

  List<CameraEventItemUiModel> _events = [];
  CameraEventFilter _filter = CameraEventFilter.all;

  Future<void> loadEvents({
    required String deviceId,
    required String deviceName,
  }) async {
    emit(const CameraEventHistoryLoading());
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (isClosed) return;

    _events = CameraEventHistoryDummyData.events();
    _filter = CameraEventFilter.all;
    emit(
      CameraEventHistorySuccess(
        events: List.unmodifiable(_events),
        filter: _filter,
      ),
    );
  }

  void setFilter(CameraEventFilter filter) {
    if (_filter == filter) return;
    _filter = filter;
    emit(
      CameraEventHistorySuccess(
        events: List.unmodifiable(_events),
        filter: _filter,
      ),
    );
  }

  Future<void> acknowledgeEvent(String eventId) async {
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index == -1 || _events[index].isAcknowledged) return;

    final updatedItem = _events[index].copyWith(isAcknowledged: true);
    final updatedList = List<CameraEventItemUiModel>.from(_events);
    updatedList[index] = updatedItem;
    _events = updatedList;

    emit(
      CameraEventHistorySuccess(
        events: List.unmodifiable(_events),
        filter: _filter,
        acknowledgedEventId: eventId,
      ),
    );
  }

  Future<void> refresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (isClosed) return;
    _events = CameraEventHistoryDummyData.events();
    emit(
      CameraEventHistorySuccess(
        events: List.unmodifiable(_events),
        filter: _filter,
      ),
    );
  }
}

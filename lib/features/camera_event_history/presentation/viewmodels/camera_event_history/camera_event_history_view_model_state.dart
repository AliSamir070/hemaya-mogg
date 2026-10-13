part of 'camera_event_history_view_model_cubit.dart';

sealed class CameraEventHistoryViewModelState {
  const CameraEventHistoryViewModelState();
}

final class CameraEventHistoryInitial extends CameraEventHistoryViewModelState {
  const CameraEventHistoryInitial();
}

final class CameraEventHistoryLoading extends CameraEventHistoryViewModelState {
  const CameraEventHistoryLoading();
}

final class CameraEventHistorySuccess extends CameraEventHistoryViewModelState {
  const CameraEventHistorySuccess({
    required this.events,
    required this.filter,
    this.acknowledgedEventId,
  });

  final List<CameraEventItemUiModel> events;
  final CameraEventFilter filter;
  final String? acknowledgedEventId;

  List<CameraEventItemUiModel> get filteredEvents {
    return switch (filter) {
      CameraEventFilter.all => events,
      CameraEventFilter.motion =>
        events.where((e) => e.type == CameraEventType.motion).toList(),
      CameraEventFilter.person =>
        events.where((e) => e.type == CameraEventType.person).toList(),
    };
  }
}

final class CameraEventHistoryError extends CameraEventHistoryViewModelState {
  const CameraEventHistoryError(this.message);

  final String message;
}

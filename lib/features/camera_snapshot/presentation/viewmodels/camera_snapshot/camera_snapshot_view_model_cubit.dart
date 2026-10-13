import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../models/camera_snapshot_dummy_data.dart';
import '../../models/camera_snapshot_ui_model.dart';

part 'camera_snapshot_view_model_state.dart';

@injectable
class CameraSnapshotViewModelCubit extends Cubit<CameraSnapshotViewModelState> {
  CameraSnapshotViewModelCubit() : super(const CameraSnapshotInitial());

  CameraSnapshotUiModel? _current;

  // TODO: replace dummy data with GetLastSnapshotUseCase once domain is ready.
  Future<void> loadSnapshot({
    required String deviceId,
    required String deviceName,
  }) async {
    emit(const CameraSnapshotLoading());
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (isClosed) return;
    _current = CameraSnapshotDummyData.snapshot(id: deviceId, name: deviceName);
    emit(CameraSnapshotSuccess(_current!));
  }

  /// Requests a fresh snapshot while keeping the current one on screen.
  Future<void> refreshSnapshot() async {
    final current = _current;
    if (current == null) return;
    final s = state;
    if (s is CameraSnapshotSuccess && s.isRefreshing) return;

    emit(CameraSnapshotSuccess(current, isRefreshing: true));
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (isClosed) return;
    _current = current.copyWith(capturedAt: DateTime.now());
    emit(CameraSnapshotSuccess(_current!));
  }

  void setMotionAlerts(bool enabled) {
    final current = _current;
    if (current == null || current.motionAlertsEnabled == enabled) return;
    _current = current.copyWith(motionAlertsEnabled: enabled);
    final s = state;
    emit(
      CameraSnapshotSuccess(
        _current!,
        isRefreshing: s is CameraSnapshotSuccess && s.isRefreshing,
      ),
    );
  }
}

part of 'camera_snapshot_view_model_cubit.dart';

sealed class CameraSnapshotViewModelState {
  const CameraSnapshotViewModelState();
}

final class CameraSnapshotInitial extends CameraSnapshotViewModelState {
  const CameraSnapshotInitial();
}

final class CameraSnapshotLoading extends CameraSnapshotViewModelState {
  const CameraSnapshotLoading();
}

final class CameraSnapshotSuccess extends CameraSnapshotViewModelState {
  const CameraSnapshotSuccess(this.snapshot, {this.isRefreshing = false});

  final CameraSnapshotUiModel snapshot;

  /// True while a new snapshot is being requested; the previous one stays
  /// visible underneath a shimmer.
  final bool isRefreshing;
}

final class CameraSnapshotError extends CameraSnapshotViewModelState {
  const CameraSnapshotError(this.message);

  final String message;
}

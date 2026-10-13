import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/DI/di.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../../core/routes_manager/routes.dart';
import '../../../camera_event_history/presentation/models/camera_event_ui_model.dart';
import '../../../sensor_details/presentation/widgets/common/sensor_details_background.dart';
import '../models/camera_snapshot_ui_model.dart';
import '../utils/camera_snapshot_layout.dart';
import '../viewmodels/camera_snapshot/camera_snapshot_view_model_cubit.dart';
import '../widgets/actions/motion_alerts_card.dart';
import '../widgets/actions/snapshot_action_button.dart';
import '../widgets/header/camera_snapshot_header.dart';
import '../widgets/loading/camera_snapshot_shimmer.dart';
import '../widgets/snapshot/snapshot_viewer.dart';

/// Figma: "04 · Camera Snapshot" — last snapshot captured by the camera.
///
/// * Compact (< 600): the Figma phone layout (portrait snapshot frame).
/// * Medium (600–839): centred column with a 4:3 snapshot.
/// * Expanded (≥ 840): snapshot on the left, controls on the right.
class CameraSnapshotScreen extends StatelessWidget {
  const CameraSnapshotScreen({super.key, required this.args});

  final CameraSnapshotArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<CameraSnapshotViewModelCubit>()
        ..loadSnapshot(deviceId: args.deviceId, deviceName: args.deviceName),
      child: _CameraSnapshotView(args: args),
    );
  }
}

class _CameraSnapshotView extends StatefulWidget {
  const _CameraSnapshotView({required this.args});

  final CameraSnapshotArgs args;

  @override
  State<_CameraSnapshotView> createState() => _CameraSnapshotViewState();
}

class _CameraSnapshotViewState extends State<_CameraSnapshotView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  void _playEntrance() {
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
                  final size = CameraSnapshotLayout.sizeFor(
                    constraints.maxWidth,
                  );
                  final horizontal = CameraSnapshotLayout.horizontalPadding(
                    constraints.maxWidth,
                    CameraSnapshotLayout.maxContentWidth(size),
                  );
                  final padding = EdgeInsets.fromLTRB(
                    horizontal,
                    12.r,
                    horizontal,
                    MediaQuery.paddingOf(context).bottom + 24.r,
                  );

                  return BlocConsumer<
                    CameraSnapshotViewModelCubit,
                    CameraSnapshotViewModelState
                  >(
                    listenWhen: (previous, current) =>
                        current is CameraSnapshotSuccess &&
                        previous is! CameraSnapshotSuccess,
                    listener: (context, state) => _playEntrance(),
                    builder: (context, state) => switch (state) {
                      CameraSnapshotInitial() || CameraSnapshotLoading() =>
                        SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: padding,
                          child: CameraSnapshotShimmer(size: size),
                        ),
                      CameraSnapshotError(:final message) => _ErrorView(
                        message: message,
                        onRetry: () => context
                            .read<CameraSnapshotViewModelCubit>()
                            .loadSnapshot(
                              deviceId: widget.args.deviceId,
                              deviceName: widget.args.deviceName,
                            ),
                      ),
                      CameraSnapshotSuccess(
                        :final snapshot,
                        :final isRefreshing,
                      ) =>
                        _buildContent(
                          context,
                          snapshot: snapshot,
                          isRefreshing: isRefreshing,
                          size: size,
                          padding: padding,
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
    required CameraSnapshotUiModel snapshot,
    required bool isRefreshing,
    required CameraLayoutSize size,
    required EdgeInsets padding,
  }) {
    final cubit = context.read<CameraSnapshotViewModelCubit>();
    final sections = _Sections(
      snapshot: snapshot,
      isRefreshing: isRefreshing,
      size: size,
      onBack: () => Navigator.of(context).maybePop(),
      onRefresh: cubit.refreshSnapshot,
      onEventHistory: () {
        Navigator.of(context).pushNamed(
          Routes.cameraEventHistoryRoute,
          arguments: CameraEventHistoryArgs(
            deviceId: snapshot.deviceId,
            deviceName: snapshot.name,
          ),
        );
      },
      onMotionAlertsChanged: cubit.setMotionAlerts,
    );

    final children = size == CameraLayoutSize.expanded
        ? _expandedLayout(sections)
        : _stackedLayout(sections);

    return RefreshIndicator(
      color: ColorManager.sky,
      backgroundColor: ColorManager.surface,
      onRefresh: cubit.refreshSnapshot,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < children.length; i++)
              StaggeredEntrance(
                animation: _entrance,
                index: i,
                count: children.length,
                child: children[i],
              ),
          ],
        ),
      ),
    );
  }

  /// Phone / small-tablet layout, following the Figma frame top-to-bottom.
  List<Widget> _stackedLayout(_Sections s) => [
    s.header(),
    Padding(padding: EdgeInsets.only(top: 22.r), child: s.viewer()),
    Padding(padding: EdgeInsets.only(top: 18.r), child: s.hint()),
    Padding(padding: EdgeInsets.only(top: 26.r), child: s.actions()),
    Padding(padding: EdgeInsets.only(top: 18.r), child: s.motionAlerts()),
  ];

  /// Desktop / large-tablet: snapshot gets the main column, controls sit
  /// beside it so everything stays above the fold.
  List<Widget> _expandedLayout(_Sections s) => [
    s.header(),
    Padding(
      padding: EdgeInsets.only(top: 22.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: s.viewer()),
          SizedBox(width: 24.r),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                s.hint(textAlign: TextAlign.start),
                SizedBox(height: 20.r),
                s.actions(),
                SizedBox(height: 16.r),
                s.motionAlerts(),
              ],
            ),
          ),
        ],
      ),
    ),
  ];
}

/// Builds each section once so layouts only decide placement.
class _Sections {
  const _Sections({
    required this.snapshot,
    required this.isRefreshing,
    required this.size,
    required this.onBack,
    required this.onRefresh,
    required this.onEventHistory,
    required this.onMotionAlertsChanged,
  });

  final CameraSnapshotUiModel snapshot;
  final bool isRefreshing;
  final CameraLayoutSize size;
  final VoidCallback onBack;
  final VoidCallback onRefresh;
  final VoidCallback onEventHistory;
  final ValueChanged<bool> onMotionAlertsChanged;

  Widget header() => CameraSnapshotHeader(
    title: snapshot.name,
    subtitle: snapshot.description,
    isOnline: snapshot.isOnline,
    onBack: onBack,
  );

  Widget viewer() => SnapshotViewer(
    imageUrl: snapshot.imageUrl,
    capturedAt: snapshot.capturedAt,
    eventLabel: snapshot.eventLabel,
    isRecording: snapshot.isRecording,
    isRefreshing: isRefreshing,
    aspectRatio: CameraSnapshotLayout.snapshotAspectRatio(size),
  );

  Widget hint({TextAlign textAlign = TextAlign.center}) => Text(
    StringsManager.lastSnapshotHint,
    textAlign: textAlign,
    style: TextStyle(fontSize: 12.sp, color: ColorManager.slate),
  );

  Widget actions() => LayoutBuilder(
    builder: (context, constraints) {
      final gap = 12.r;
      final refresh = SnapshotActionButton(
        label: isRefreshing
            ? StringsManager.refreshing
            : StringsManager.refreshSnapshot,
        icon: Icons.refresh_rounded,
        primary: true,
        busy: isRefreshing,
        onPressed: isRefreshing ? null : onRefresh,
      );
      final history = SnapshotActionButton(
        label: StringsManager.eventHistory,
        icon: Icons.event_note_rounded,
        onPressed: onEventHistory,
      );
      final sideBySide =
          (constraints.maxWidth - gap) / 2 >=
          CameraSnapshotLayout.minSideBySideButtonWidth;
      return sideBySide
          ? Row(
              children: [
                Expanded(child: refresh),
                SizedBox(width: gap),
                Expanded(child: history),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [refresh, SizedBox(height: gap), history],
            );
    },
  );

  Widget motionAlerts() => MotionAlertsCard(
    enabled: snapshot.motionAlertsEnabled,
    onChanged: onMotionAlertsChanged,
  );
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
              Icons.videocam_off_rounded,
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

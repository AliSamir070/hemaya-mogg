import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/DI/di.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/strings_manager.dart';
import '../models/sensor_details_ui_model.dart';
import '../utils/sensor_details_layout.dart';
import '../utils/sensor_status_style.dart';
import '../viewmodels/sensor_details/sensor_details_view_model_cubit.dart';
import '../widgets/actions/sensor_action_button.dart';
import '../widgets/actions/threshold_alerts_card.dart';
import '../widgets/chart/sensor_trend_chart.dart';
import '../widgets/common/sensor_card.dart';
import '../widgets/common/sensor_details_background.dart';
import '../widgets/gauges/gauge_card.dart';
import '../widgets/header/sensor_details_header.dart';

/// Figma: "01 · Dashboard" — live temperature & humidity sensor dashboard.
///
/// * Compact (< 600): the Figma phone layout.
/// * Medium (600–839): same structure, centred, with a taller chart.
/// * Expanded (≥ 840): gauges + controls in one row, wide chart below.
class SensorDetailsScreen extends StatelessWidget {
  const SensorDetailsScreen({super.key, required this.args});

  final SensorDetailsArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<SensorDetailsViewModelCubit>()
        ..loadSensor(deviceId: args.deviceId, deviceName: args.deviceName)
        ..startLiveUpdates(),
      child: _SensorDetailsView(args: args),
    );
  }
}

class _SensorDetailsView extends StatefulWidget {
  const _SensorDetailsView({required this.args});

  final SensorDetailsArgs args;

  @override
  State<_SensorDetailsView> createState() => _SensorDetailsViewState();
}

class _SensorDetailsViewState extends State<_SensorDetailsView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );

  // Pause the live feed while the app is in the background.
  late final AppLifecycleListener _lifecycle = AppLifecycleListener(
    onResume: () =>
        context.read<SensorDetailsViewModelCubit>().startLiveUpdates(),
    onPause: () =>
        context.read<SensorDetailsViewModelCubit>().stopLiveUpdates(),
  );

  @override
  void initState() {
    super.initState();
    _lifecycle; // Initialise eagerly.
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _entrance.value = 1;
    } else if (_entrance.isDismissed) {
      _entrance.forward();
    }
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _entrance.dispose();
    super.dispose();
  }

  void _showComingSoon(String feature) {
    // TODO: navigate to alarm events / thresholds screens once available.
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: ColorManager.surfaceLight,
          content: Text('$feature · ${StringsManager.comingSoon}'),
        ),
      );
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
              child:
                  BlocBuilder<
                    SensorDetailsViewModelCubit,
                    SensorDetailsViewModelState
                  >(
                    builder: (context, state) {
                      return switch (state) {
                        SensorDetailsInitial() ||
                        SensorDetailsLoading() => const Center(
                          child: CircularProgressIndicator(
                            color: ColorManager.sky,
                          ),
                        ),
                        SensorDetailsError(:final message) => Center(
                          child: Text(
                            message,
                            style: TextStyle(
                              color: ColorManager.slate,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        SensorDetailsSuccess(:final sensor) => _buildContent(
                          context,
                          sensor,
                        ),
                      };
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, SensorDetailsUiModel sensor) {
    final cubit = context.read<SensorDetailsViewModelCubit>();
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = SensorDetailsLayout.sizeFor(constraints.maxWidth);
        final horizontal = SensorDetailsLayout.horizontalPadding(
          constraints.maxWidth,
          SensorDetailsLayout.maxContentWidth(size),
        );
        final contentWidth = constraints.maxWidth - horizontal * 2;
        final bottomInset = MediaQuery.paddingOf(context).bottom;

        final sections = _Sections(
          sensor: sensor,
          onThresholdAlertsChanged: cubit.setThresholdAlerts,
          onBack: () => Navigator.of(context).maybePop(),
          onAlarmEvents: () => _showComingSoon(StringsManager.alarmEvents),
          onSetThresholds: () => _showComingSoon(StringsManager.setThresholds),
        );

        final children = size == SensorLayoutSize.expanded
            ? _expandedLayout(sections, contentWidth)
            : _stackedLayout(sections, contentWidth, size);

        return RefreshIndicator(
          color: ColorManager.sky,
          backgroundColor: ColorManager.surface,
          onRefresh: cubit.refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              horizontal,
              12.r,
              horizontal,
              bottomInset + 24.r,
            ),
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
      },
    );
  }

  /// Phone / small-tablet layout, following the Figma frame top-to-bottom.
  List<Widget> _stackedLayout(
    _Sections s,
    double contentWidth,
    SensorLayoutSize size,
  ) {
    final gap = 12.r;
    final cardWidth = (contentWidth - gap) / 2;
    final sideBySide = cardWidth >= SensorDetailsLayout.minSideBySideCardWidth;
    final buttonsSideBySide = cardWidth >= 150;
    final plotHeight = size == SensorLayoutSize.medium ? 150.r : 80.r;

    final gauges = sideBySide
        ? IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: s.temperatureCard(cardWidth)),
                SizedBox(width: gap),
                Expanded(child: s.humidityCard(cardWidth)),
              ],
            ),
          )
        : Column(
            children: [
              s.temperatureCard(contentWidth * 0.7),
              SizedBox(height: gap),
              s.humidityCard(contentWidth * 0.7),
            ],
          );

    final actions = buttonsSideBySide
        ? Row(
            children: [
              Expanded(child: s.alarmEventsButton()),
              SizedBox(width: gap),
              Expanded(child: s.setThresholdsButton()),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              s.alarmEventsButton(),
              SizedBox(height: gap),
              s.setThresholdsButton(),
            ],
          );

    return [
      s.header(),
      Padding(
        padding: EdgeInsets.only(top: 28.r),
        child: gauges,
      ),
      Padding(
        padding: EdgeInsets.only(top: 14.r),
        child: s.trendCard(plotHeight),
      ),
      Padding(
        padding: EdgeInsets.only(top: 22.r),
        child: s.alertsCard(),
      ),
      Padding(
        padding: EdgeInsets.only(top: 16.r),
        child: actions,
      ),
    ];
  }

  /// Desktop / large-tablet layout: gauges and controls share one row so
  /// the chart can use the full width.
  List<Widget> _expandedLayout(_Sections s, double contentWidth) {
    final gap = 16.r;
    final columnWidth = (contentWidth - gap * 2) / 3;

    return [
      s.header(),
      Padding(
        padding: EdgeInsets.only(top: 28.r),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: s.temperatureCard(columnWidth)),
              SizedBox(width: gap),
              Expanded(child: s.humidityCard(columnWidth)),
              SizedBox(width: gap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    s.alertsCard(),
                    SizedBox(height: gap),
                    const Spacer(),
                    s.alarmEventsButton(),
                    SizedBox(height: gap),
                    s.setThresholdsButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: gap),
        child: s.trendCard(220.r),
      ),
    ];
  }
}

/// Builds each dashboard section once so layouts only decide placement.
class _Sections {
  const _Sections({
    required this.sensor,
    required this.onThresholdAlertsChanged,
    required this.onBack,
    required this.onAlarmEvents,
    required this.onSetThresholds,
  });

  final SensorDetailsUiModel sensor;
  final ValueChanged<bool> onThresholdAlertsChanged;
  final VoidCallback onBack;
  final VoidCallback onAlarmEvents;
  final VoidCallback onSetThresholds;

  Widget header() => SensorDetailsHeader(
    title: sensor.name,
    lastUpdated: sensor.lastUpdated,
    isOnline: sensor.isOnline,
    onBack: onBack,
  );

  Widget temperatureCard(double cardWidth) {
    final status = sensor.temperatureStatus;
    return GaugeCard(
      title: StringsManager.temperature,
      badgeGlyph: StringsManager.celsius,
      accent: ColorManager.orange,
      value: sensor.temperature,
      min: SensorRanges.minTemperature,
      max: SensorRanges.maxTemperature,
      unit: StringsManager.celsius,
      fractionDigits: 1,
      statusLabel: status.label,
      statusColor: status.color,
      gaugeDiameter: SensorDetailsLayout.gaugeDiameter(cardWidth),
    );
  }

  Widget humidityCard(double cardWidth) {
    final status = sensor.humidityStatus;
    return GaugeCard(
      title: StringsManager.humidity,
      badgeGlyph: '%',
      accent: ColorManager.sky,
      value: sensor.humidity,
      min: SensorRanges.minHumidity,
      max: SensorRanges.maxHumidity,
      unit: StringsManager.percentRh,
      statusLabel: status.label,
      statusColor: status.color,
      gaugeDiameter: SensorDetailsLayout.gaugeDiameter(cardWidth),
    );
  }

  Widget trendCard(double plotHeight) => SensorCard(
    padding: EdgeInsets.fromLTRB(18.r, 16.r, 18.r, 12.r),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12.r,
          runSpacing: 6.r,
          children: [
            Semantics(
              header: true,
              child: Text(
                StringsManager.last24Hours,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorManager.pureWhite,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SensorLegendItem(
                  color: ColorManager.orange,
                  label: StringsManager.temp,
                ),
                SizedBox(width: 12.r),
                const SensorLegendItem(
                  color: ColorManager.sky,
                  label: StringsManager.humidity,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 20.r),
        SensorTrendChart(samples: sensor.history, plotHeight: plotHeight),
      ],
    ),
  );

  Widget alertsCard() => ThresholdAlertsCard(
    enabled: sensor.thresholdAlertsEnabled,
    onChanged: onThresholdAlertsChanged,
  );

  Widget alarmEventsButton() => SensorActionButton(
    title: StringsManager.alarmEvents,
    subtitle: StringsManager.viewHistory,
    icon: Icons.receipt_long_rounded,
    onPressed: onAlarmEvents,
  );

  Widget setThresholdsButton() => SensorActionButton(
    title: StringsManager.setThresholds,
    subtitle: StringsManager.tempAndHumidity,
    icon: Icons.tune_rounded,
    primary: true,
    onPressed: onSetThresholds,
  );
}

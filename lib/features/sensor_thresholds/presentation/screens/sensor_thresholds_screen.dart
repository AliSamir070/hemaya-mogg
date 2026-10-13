import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/DI/di.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/dialog_utils.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../home/presentation/widgets/common/gradient_button.dart';
import '../../../sensor_details/presentation/widgets/common/sensor_details_background.dart';
import '../models/sensor_thresholds_ui_model.dart';
import '../utils/sensor_thresholds_layout.dart';
import '../viewmodels/sensor_thresholds/sensor_thresholds_view_model_cubit.dart';
import '../widgets/card/threshold_card.dart';
import '../widgets/header/sensor_thresholds_header.dart';
import '../widgets/loading/sensor_thresholds_shimmer.dart';

/// Screen allowing configuration and updating of temperature & humidity thresholds.
/// Corresponds to Figma screen: "02 · Alarm Thresholds".
class SensorThresholdsScreen extends StatelessWidget {
  const SensorThresholdsScreen({super.key, required this.args});

  final SensorThresholdsArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<SensorThresholdsViewModelCubit>()
        ..initThresholds(args),
      child: _SensorThresholdsView(args: args),
    );
  }
}

class _SensorThresholdsView extends StatefulWidget {
  const _SensorThresholdsView({required this.args});

  final SensorThresholdsArgs args;

  @override
  State<_SensorThresholdsView> createState() => _SensorThresholdsViewState();
}

class _SensorThresholdsViewState extends State<_SensorThresholdsView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _playEntrance();
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  void _playEntrance() {
    if (!mounted) return;
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
                  final size = SensorThresholdsLayout.sizeFor(
                    constraints.maxWidth,
                  );
                  final horizontal =
                      SensorThresholdsLayout.horizontalPadding(
                    constraints.maxWidth,
                    SensorThresholdsLayout.maxContentWidth(size),
                  );
                  final bottomInset = MediaQuery.paddingOf(context).bottom;
                  final padding = EdgeInsets.fromLTRB(
                    horizontal,
                    12.r,
                    horizontal,
                    bottomInset + 24.r,
                  );

                  return BlocConsumer<
                    SensorThresholdsViewModelCubit,
                    SensorThresholdsViewModelState
                  >(
                    listener: (context, state) {
                      if (state is SensorThresholdsSuccess) {
                        _playEntrance();
                        if (state.isSaveSuccess) {
                          DialogUtils.showToast(
                            StringsManager.thresholdsSavedSuccessfully,
                          );
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    builder: (context, state) => switch (state) {
                      SensorThresholdsInitial() ||
                      SensorThresholdsLoading() =>
                        SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: padding,
                          child: const SensorThresholdsShimmer(),
                        ),
                      SensorThresholdsError(:final message) => _ErrorView(
                        message: message,
                        onRetry: () => context
                            .read<SensorThresholdsViewModelCubit>()
                            .initThresholds(widget.args),
                      ),
                      SensorThresholdsSuccess(
                        :final thresholds,
                        :final isSaving,
                      ) =>
                        _buildContent(
                          context,
                          thresholds: thresholds,
                          isSaving: isSaving,
                          padding: padding,
                          size: size,
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
    required SensorThresholdsUiModel thresholds,
    required bool isSaving,
    required EdgeInsets padding,
    required SensorThresholdsLayoutSize size,
  }) {
    final cubit = context.read<SensorThresholdsViewModelCubit>();

    final tempCard = ThresholdCard(
      title: StringsManager.temperature,
      badgeGlyph: StringsManager.celsius,
      accentColor: ColorManager.orange,
      currentValueLabel: '${thresholds.currentTemperature.toStringAsFixed(1)}°C',
      thresholdValueLabel: '${thresholds.temperatureThreshold.toStringAsFixed(0)}°C',
      threshold: thresholds.temperatureThreshold,
      min: thresholds.minTemperature,
      max: thresholds.maxTemperature,
      minLabel: '${thresholds.minTemperature.toStringAsFixed(0)}°C',
      maxLabel: '${thresholds.maxTemperature.toStringAsFixed(0)}°C',
      onChanged: cubit.updateTemperatureThreshold,
      onIncrement: () => cubit.adjustTemperatureThreshold(1.0),
      onDecrement: () => cubit.adjustTemperatureThreshold(-1.0),
    );

    final humidityCard = ThresholdCard(
      title: StringsManager.humidity,
      badgeGlyph: '%',
      accentColor: ColorManager.sky,
      currentValueLabel: '${thresholds.currentHumidity.toStringAsFixed(0)}%',
      thresholdValueLabel: '${thresholds.humidityThreshold.toStringAsFixed(0)}%',
      threshold: thresholds.humidityThreshold,
      min: thresholds.minHumidity,
      max: thresholds.maxHumidity,
      minLabel: '${thresholds.minHumidity.toStringAsFixed(0)}%',
      maxLabel: '${thresholds.maxHumidity.toStringAsFixed(0)}%',
      onChanged: cubit.updateHumidityThreshold,
      onIncrement: () => cubit.adjustHumidityThreshold(1.0),
      onDecrement: () => cubit.adjustHumidityThreshold(-1.0),
    );

    final saveButton = GradientButton(
      label: isSaving
          ? StringsManager.savingThresholds
          : StringsManager.saveThresholds,
      onPressed: isSaving ? null : cubit.saveThresholds,
    );

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StaggeredEntrance(
            animation: _entrance,
            index: 0,
            count: 4,
            child: SensorThresholdsHeader(
              deviceName: widget.args.deviceName,
              onBack: () => Navigator.of(context).maybePop(),
            ),
          ),
          SizedBox(height: 24.r),
          if (size == SensorThresholdsLayoutSize.expanded) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: StaggeredEntrance(
                    animation: _entrance,
                    index: 1,
                    count: 4,
                    child: tempCard,
                  ),
                ),
                SizedBox(width: 16.r),
                Expanded(
                  child: StaggeredEntrance(
                    animation: _entrance,
                    index: 2,
                    count: 4,
                    child: humidityCard,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.r),
            StaggeredEntrance(
              animation: _entrance,
              index: 3,
              count: 4,
              child: saveButton,
            ),
          ] else ...[
            StaggeredEntrance(
              animation: _entrance,
              index: 1,
              count: 4,
              child: tempCard,
            ),
            SizedBox(height: 16.r),
            StaggeredEntrance(
              animation: _entrance,
              index: 2,
              count: 4,
              child: humidityCard,
            ),
            SizedBox(height: 24.r),
            StaggeredEntrance(
              animation: _entrance,
              index: 3,
              count: 4,
              child: saveButton,
            ),
          ],
        ],
      ),
    );
  }
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
              Icons.error_outline_rounded,
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

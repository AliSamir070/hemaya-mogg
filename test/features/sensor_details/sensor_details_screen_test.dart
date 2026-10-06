import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hemaya_mogg/core/DI/di.dart';
import 'package:hemaya_mogg/core/resources/strings_manager.dart';
import 'package:hemaya_mogg/features/sensor_details/presentation/models/sensor_details_ui_model.dart';
import 'package:hemaya_mogg/features/sensor_details/presentation/screens/sensor_details_screen.dart';
import 'package:hemaya_mogg/features/sensor_details/presentation/viewmodels/sensor_details/sensor_details_view_model_cubit.dart';
import 'package:hemaya_mogg/features/sensor_details/presentation/widgets/actions/threshold_alerts_card.dart';

Widget _app() => ScreenUtilInit(
  designSize: const Size(390, 844),
  minTextAdapt: true,
  splitScreenMode: true,
  builder: (_, _) => const MaterialApp(
    home: SensorDetailsScreen(
      args: SensorDetailsArgs(deviceId: 'airguard-th', deviceName: 'Sensor'),
    ),
  ),
);

Future<void> _pumpAt(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(_app());
  // Let entrance, gauge sweep and chart reveal finish (repeating pulses
  // never settle, so pumpAndSettle can't be used).
  await tester.pump(const Duration(milliseconds: 2000));
}

Future<void> _disposeScreen(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
}

void main() {
  setUp(() {
    if (getIt.isRegistered<SensorDetailsViewModelCubit>()) {
      getIt.unregister<SensorDetailsViewModelCubit>();
    }
    getIt.registerFactory<SensorDetailsViewModelCubit>(
      () => SensorDetailsViewModelCubit(),
    );
  });

  tearDown(() {
    if (getIt.isRegistered<SensorDetailsViewModelCubit>()) {
      getIt.unregister<SensorDetailsViewModelCubit>();
    }
  });

  for (final (name, size) in [
    ('compact', const Size(390, 844)),
    ('narrow compact', const Size(280, 653)),
    ('medium', const Size(720, 1024)),
    ('expanded', const Size(1280, 800)),
  ]) {
    testWidgets('renders without overflow on $name width', (tester) async {
      await _pumpAt(tester, size);

      expect(tester.takeException(), isNull);
      expect(find.text(StringsManager.temperature), findsOneWidget);
      expect(find.text(StringsManager.last24Hours), findsOneWidget);
      expect(find.text(StringsManager.comfortable), findsOneWidget);

      await _disposeScreen(tester);
    });
  }

  testWidgets('threshold alerts toggle flips state', (tester) async {
    await _pumpAt(tester, const Size(390, 844));

    Switch alertSwitch() => tester.widget<Switch>(
      find.descendant(
        of: find.byType(ThresholdAlertsCard),
        matching: find.byType(Switch),
      ),
    );

    expect(alertSwitch().value, isTrue);
    await tester.ensureVisible(find.byType(ThresholdAlertsCard));
    await tester.tap(find.text(StringsManager.thresholdAlerts));
    await tester.pump(const Duration(milliseconds: 300));
    expect(alertSwitch().value, isFalse);

    await _disposeScreen(tester);
  });
}

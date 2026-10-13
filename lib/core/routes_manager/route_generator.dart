import 'package:flutter/material.dart';
import 'package:hemaya_mogg/core/routes_manager/routes.dart';
import '../../features/camera_event_history/presentation/models/camera_active_alarm_ui_model.dart';
import '../../features/camera_event_history/presentation/models/camera_event_ui_model.dart';
import '../../features/camera_event_history/presentation/screens/camera_active_alarm_screen.dart';
import '../../features/camera_event_history/presentation/screens/camera_event_history_screen.dart';
import '../../features/camera_snapshot/presentation/models/camera_snapshot_ui_model.dart';
import '../../features/camera_snapshot/presentation/screens/camera_snapshot_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/sensor_alarm_events/presentation/models/sensor_active_alarm_ui_model.dart';
import '../../features/sensor_alarm_events/presentation/models/sensor_alarm_ui_model.dart';
import '../../features/sensor_alarm_events/presentation/screens/sensor_active_alarm_screen.dart';
import '../../features/sensor_alarm_events/presentation/screens/sensor_alarm_events_screen.dart';
import '../../features/sensor_details/presentation/models/sensor_details_ui_model.dart';
import '../../features/sensor_details/presentation/screens/sensor_details_screen.dart';
import '../../features/sensor_thresholds/presentation/models/sensor_thresholds_ui_model.dart';
import '../../features/sensor_thresholds/presentation/screens/sensor_thresholds_screen.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.homeRoute:
        {
          return MaterialPageRoute(builder: (_) => const HomeScreen());
        }
      case Routes.sensorDetailsRoute:
        {
          final args = settings.arguments;
          if (args is! SensorDetailsArgs) return unDefinedRoute();
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => SensorDetailsScreen(args: args),
          );
        }
      case Routes.cameraSnapshotRoute:
        {
          final args = settings.arguments;
          if (args is! CameraSnapshotArgs) return unDefinedRoute();
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => CameraSnapshotScreen(args: args),
          );
        }
      case Routes.cameraEventHistoryRoute:
        {
          final args = settings.arguments;
          if (args is! CameraEventHistoryArgs) return unDefinedRoute();
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => CameraEventHistoryScreen(args: args),
          );
        }
      case Routes.sensorAlarmEventsRoute:
        {
          final args = settings.arguments;
          if (args is! SensorAlarmEventsArgs) return unDefinedRoute();
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => SensorAlarmEventsScreen(args: args),
          );
        }
      case Routes.sensorThresholdsRoute:
        {
          final args = settings.arguments;
          if (args is! SensorThresholdsArgs) return unDefinedRoute();
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => SensorThresholdsScreen(args: args),
          );
        }
      case Routes.sensorActiveAlarmRoute:
        {
          final args = settings.arguments;
          if (args is! SensorActiveAlarmArgs) return unDefinedRoute();
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => SensorActiveAlarmScreen(args: args),
          );
        }
      case Routes.cameraActiveAlarmRoute:
        {
          final args = settings.arguments;
          if (args is! CameraActiveAlarmArgs) return unDefinedRoute();
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => CameraActiveAlarmScreen(args: args),
          );
        }
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('No Route Found')),
        body: const Center(child: Text('No Route Found')),
      ),
    );
  }
}

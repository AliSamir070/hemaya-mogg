// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/camera_event_history/presentation/viewmodels/camera_active_alarm/camera_active_alarm_view_model_cubit.dart'
    as _i752;
import '../../features/camera_event_history/presentation/viewmodels/camera_event_history/camera_event_history_view_model_cubit.dart'
    as _i739;
import '../../features/camera_snapshot/presentation/viewmodels/camera_snapshot/camera_snapshot_view_model_cubit.dart'
    as _i435;
import '../../features/sensor_alarm_events/presentation/viewmodels/sensor_active_alarm/sensor_active_alarm_view_model_cubit.dart'
    as _i90;
import '../../features/sensor_alarm_events/presentation/viewmodels/sensor_alarm_events/sensor_alarm_events_view_model_cubit.dart'
    as _i576;
import '../../features/sensor_details/presentation/viewmodels/sensor_details/sensor_details_view_model_cubit.dart'
    as _i762;
import '../../features/sensor_thresholds/presentation/viewmodels/sensor_thresholds/sensor_thresholds_view_model_cubit.dart'
    as _i531;
import 'client_module.dart' as _i728;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final clientModule = _$ClientModule();
    gh.factory<_i752.CameraActiveAlarmViewModelCubit>(
      () => _i752.CameraActiveAlarmViewModelCubit(),
    );
    gh.factory<_i739.CameraEventHistoryViewModelCubit>(
      () => _i739.CameraEventHistoryViewModelCubit(),
    );
    gh.factory<_i435.CameraSnapshotViewModelCubit>(
      () => _i435.CameraSnapshotViewModelCubit(),
    );
    gh.factory<_i90.SensorActiveAlarmViewModelCubit>(
      () => _i90.SensorActiveAlarmViewModelCubit(),
    );
    gh.factory<_i576.SensorAlarmEventsViewModelCubit>(
      () => _i576.SensorAlarmEventsViewModelCubit(),
    );
    gh.factory<_i762.SensorDetailsViewModelCubit>(
      () => _i762.SensorDetailsViewModelCubit(),
    );
    gh.factory<_i531.SensorThresholdsViewModelCubit>(
      () => _i531.SensorThresholdsViewModelCubit(),
    );
    gh.singleton<_i361.Dio>(() => clientModule.buildDio());
    return this;
  }
}

class _$ClientModule extends _i728.ClientModule {}

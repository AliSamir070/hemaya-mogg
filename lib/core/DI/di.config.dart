// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dart_meteor/dart_meteor.dart' as _i195;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/api/auth_client.dart' as _i186;
import '../../features/auth/data/datasource/auth_dao.dart' as _i753;
import '../../features/auth/data/datasource_impl/auth_api_dao_impl.dart'
    as _i793;
import '../../features/auth/data/repo_impl/auth_repo_impl.dart' as _i279;
import '../../features/auth/domain/repo/auth_repo.dart' as _i170;
import '../../features/auth/domain/usecase/signup_use_case.dart' as _i164;
import '../../features/auth/presentation/viewmodels/signup/signup_view_model_cubit.dart'
    as _i836;
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
import '../remote/network/meteor_service.dart' as _i267;
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
    gh.singleton<_i195.MeteorClient>(() => clientModule.buildMeteorClient());
    gh.singleton<_i267.MeteorService>(
      () => _i267.MeteorService(gh<_i267.MeteorClient>()),
      dispose: (i) => i.dispose(),
    );
    gh.singleton<_i186.AuthClient>(
      () => _i186.AuthClient(gh<_i267.MeteorService>()),
    );
    gh.factory<_i753.AuthDao>(
      () => _i793.AuthApiDaoImpl(
        gh<_i186.AuthClient>(),
        gh<_i267.MeteorService>(),
      ),
    );
    gh.factory<_i170.AuthRepo>(() => _i279.AuthRepoImpl(gh<_i753.AuthDao>()));
    gh.singleton<_i164.SignupUseCase>(
      () => _i164.SignupUseCase(gh<_i170.AuthRepo>()),
    );
    gh.factory<_i836.SignupViewModelCubit>(
      () => _i836.SignupViewModelCubit(gh<_i164.SignupUseCase>()),
    );
    return this;
  }
}

class _$ClientModule extends _i728.ClientModule {}

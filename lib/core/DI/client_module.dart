import 'package:dart_meteor/dart_meteor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../resources/constants_manager.dart';

@module
abstract class ClientModule {
  @singleton
  Dio buildDio() {
    Dio dio = Dio(
      BaseOptions(
        validateStatus: (status) {
          if (status != null && status < 500) {
            return true;
          }
          return false;
        },
      ),
    );
    dio.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        request: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
      ),
    );
    return dio;
  }

  @singleton
  MeteorClient buildMeteorClient() {
    return MeteorClient.connect(
      url: AppConstants.meteorUrl,
      debug: kDebugMode,
      pingInterval: AppConstants.meteorPingInterval,
      pongTimeout: AppConstants.meteorPongTimeout,
      maxRetryInterval: AppConstants.meteorMaxRetryInterval,
      stalenessThreshold: AppConstants.meteorStalenessThreshold,
    );
  }
}

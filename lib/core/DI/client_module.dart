import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

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
}

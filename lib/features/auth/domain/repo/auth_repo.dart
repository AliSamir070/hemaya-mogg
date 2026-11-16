import '../../../../core/resources/api_result.dart';
import '../entity/auth_entity.dart';

abstract interface class AuthRepo {
  Future<ApiResult<AuthEntity>> signUp({
    required String name,
    required String fullName,
    required String phone,
    required String email,
    required String password,
  });

  Future<ApiResult<AuthEntity>> login({
    required String email,
    required String password,
  });
}

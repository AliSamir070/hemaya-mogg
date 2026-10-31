import '../../../../core/resources/api_result.dart';
import '../model/auth_response.dart';

abstract interface class AuthDao {
  Future<ApiResult<AuthResponse>> signUp({
    required Map<String, dynamic> body,
  });
}

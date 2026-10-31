import 'package:injectable/injectable.dart';

import '../../../../core/remote/network/meteor_service.dart';
import '../../../../core/resources/api_result.dart';
import '../../api/auth_client.dart';
import '../datasource/auth_dao.dart';
import '../model/auth_response.dart';

@Injectable(as: AuthDao)
class AuthApiDaoImpl implements AuthDao {
  final AuthClient _authClient;
  final MeteorService _meteorService;

  AuthApiDaoImpl(this._authClient, this._meteorService);

  @override
  Future<ApiResult<AuthResponse>> signUp({
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _authClient.signUp(body);
      if (response.statusMsg != null) {
        return Error(response.message ?? response.statusMsg!);
      }
      return Success(response);
    } catch (e) {
      return Error(_meteorService.formatError(e));
    }
  }
}

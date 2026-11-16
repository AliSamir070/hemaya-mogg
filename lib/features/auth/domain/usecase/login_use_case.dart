import 'package:injectable/injectable.dart';

import '../../../../core/resources/api_result.dart';
import '../entity/auth_entity.dart';
import '../repo/auth_repo.dart';

@singleton
class LoginUseCase {
  final AuthRepo _authRepo;

  LoginUseCase(this._authRepo);

  Future<ApiResult<AuthEntity>> call({
    required String email,
    required String password,
  }) {
    return _authRepo.login(
      email: email,
      password: password,
    );
  }
}

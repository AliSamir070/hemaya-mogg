import 'package:injectable/injectable.dart';

import '../../../../core/resources/api_result.dart';
import '../entity/auth_entity.dart';
import '../repo/auth_repo.dart';

@singleton
class SignupUseCase {
  final AuthRepo _authRepo;

  SignupUseCase(this._authRepo);

  Future<ApiResult<AuthEntity>> call({
    required String name,
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) {
    return _authRepo.signUp(
      name: name,
      fullName: fullName,
      phone: phone,
      email: email,
      password: password,
    );
  }
}

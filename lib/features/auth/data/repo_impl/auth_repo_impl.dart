import 'package:injectable/injectable.dart';

import '../../../../core/resources/api_result.dart';
import '../../../../core/resources/internet_checker.dart';
import '../../domain/entity/auth_entity.dart';
import '../../domain/repo/auth_repo.dart';
import '../datasource/auth_dao.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthDao _authDao;

  AuthRepoImpl(this._authDao);

  @override
  Future<ApiResult<AuthEntity>> signUp({
    required String name,
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    final bool isConnected = await InternetChecker.checkConnection();
    if (!isConnected) {
      return Error('No Internet Connection');
    }

    final result = await _authDao.signUp(
      body: {
        'name': name,
        'fullName': fullName,
        'phone': phone,
        'email': email,
        'password': password,
      },
    );

    switch (result) {
      case Success(response: final authResponse):
        return Success(authResponse.toEntity());
      case Error(message: final errorMessage):
        return Error(errorMessage);
    }
  }
}

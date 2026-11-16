import 'package:injectable/injectable.dart';

import '../../../core/remote/network/meteor_service.dart';
import '../data/model/auth_response.dart';

@singleton
class AuthClient {
  static const String createUserMethod = 'users.create';

  final MeteorService _meteorService;

  @factoryMethod
  AuthClient(this._meteorService);

  /// Calls the `users.create` Meteor method with the provided [body] map:
  /// ```json
  /// [
  ///   {
  ///     "name": "hooba",
  ///     "fullName": "Ihab Taher",
  ///     "phone": "01020304050",
  ///     "email": "hoobaa@gmail.com",
  ///     "password": "PlainPassword"
  ///   }
  /// ]
  /// ```
  Future<AuthResponse> signUp(Map<String, dynamic> body) async {
    final result = await _meteorService.call(
      createUserMethod,
      args: [body],
    );
    return AuthResponse.fromMeteorResult(result, requestBody: body);
  }

  /// Authenticates a user using Meteor's built-in accounts login (`loginWithPassword`).
  Future<AuthResponse> login(String email, String password) async {
    final loginResult = await _meteorService.loginWithPassword(
      email,
      password,
    );
    return AuthResponse(
      id: loginResult.userId,
      email: email,
      token: loginResult.token,
    );
  }
}

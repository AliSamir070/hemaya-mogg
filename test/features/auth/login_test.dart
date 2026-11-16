import 'package:flutter_test/flutter_test.dart';
import 'package:hemaya_mogg/core/resources/api_result.dart';
import 'package:hemaya_mogg/features/auth/domain/entity/auth_entity.dart';
import 'package:hemaya_mogg/features/auth/domain/repo/auth_repo.dart';
import 'package:hemaya_mogg/features/auth/domain/usecase/login_use_case.dart';
import 'package:hemaya_mogg/features/auth/presentation/viewmodels/login/login_view_model_cubit.dart';

class FakeAuthRepo implements AuthRepo {
  final ApiResult<AuthEntity> Function(String email, String password) onLogin;

  FakeAuthRepo({required this.onLogin});

  @override
  Future<ApiResult<AuthEntity>> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    return onLogin(email, password);
  }

  @override
  Future<ApiResult<AuthEntity>> signUp({
    required String name,
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  group('LoginViewModelCubit', () {
    test('emits [Loading, Success] when login succeeds', () async {
      final fakeRepo = FakeAuthRepo(
        onLogin: (email, password) => Success(
          const AuthEntity(id: 'user-123', email: 'test@example.com', token: 'token-abc'),
        ),
      );
      final loginUseCase = LoginUseCase(fakeRepo);
      final cubit = LoginViewModelCubit(loginUseCase);

      expect(cubit.state, isA<LoginViewModelInitial>());

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<LoginViewModelLoading>(),
          predicate<LoginViewModelSuccess>(
            (state) => state.authEntity.token == 'token-abc',
          ),
        ]),
      );

      await cubit.login(email: 'test@example.com', password: 'password123');
      await cubit.close();
    });

    test('emits [Loading, Error] when login fails', () async {
      final fakeRepo = FakeAuthRepo(
        onLogin: (email, password) => Error('Incorrect password'),
      );
      final loginUseCase = LoginUseCase(fakeRepo);
      final cubit = LoginViewModelCubit(loginUseCase);

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<LoginViewModelLoading>(),
          predicate<LoginViewModelError>(
            (state) => state.message == 'Incorrect password',
          ),
        ]),
      );

      await cubit.login(email: 'test@example.com', password: 'wrongpassword');
      await cubit.close();
    });
  });
}

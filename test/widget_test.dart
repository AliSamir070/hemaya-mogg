import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hemaya_mogg/core/DI/di.dart';
import 'package:hemaya_mogg/core/resources/api_result.dart';
import 'package:hemaya_mogg/core/resources/strings_manager.dart';
import 'package:hemaya_mogg/features/auth/domain/entity/auth_entity.dart';
import 'package:hemaya_mogg/features/auth/domain/repo/auth_repo.dart';
import 'package:hemaya_mogg/features/auth/domain/usecase/login_use_case.dart';
import 'package:hemaya_mogg/features/auth/presentation/screens/login_screen.dart';
import 'package:hemaya_mogg/features/auth/presentation/viewmodels/login/login_view_model_cubit.dart';

class _FakeAuthRepo implements AuthRepo {
  @override
  Future<ApiResult<AuthEntity>> login({
    required String email,
    required String password,
  }) async {
    return Success(const AuthEntity(id: '1', email: 'test@test.com'));
  }

  @override
  Future<ApiResult<AuthEntity>> signUp({
    required String name,
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    return Success(const AuthEntity(id: '1', email: 'test@test.com'));
  }
}

void main() {
  setUp(() {
    if (getIt.isRegistered<LoginViewModelCubit>()) {
      getIt.unregister<LoginViewModelCubit>();
    }
    getIt.registerFactory<LoginViewModelCubit>(
      () => LoginViewModelCubit(LoginUseCase(_FakeAuthRepo())),
    );
  });

  tearDown(() {
    if (getIt.isRegistered<LoginViewModelCubit>()) {
      getIt.unregister<LoginViewModelCubit>();
    }
  });

  testWidgets('Renders LoginScreen with email and password fields', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return const MaterialApp(
            home: LoginScreen(),
          );
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(StringsManager.welcomeBack), findsOneWidget);
    expect(find.text(StringsManager.login), findsOneWidget);
    expect(find.text(StringsManager.email), findsOneWidget);
    expect(find.text(StringsManager.password), findsOneWidget);
  });
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/resources/api_result.dart';
import '../../../domain/entity/auth_entity.dart';
import '../../../domain/usecase/login_use_case.dart';

part 'login_view_model_state.dart';

@injectable
class LoginViewModelCubit extends Cubit<LoginViewModelState> {
  final LoginUseCase _loginUseCase;

  LoginViewModelCubit(this._loginUseCase)
      : super(const LoginViewModelInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const LoginViewModelLoading());

    final result = await _loginUseCase(
      email: email,
      password: password,
    );

    if (isClosed) return;

    switch (result) {
      case Success(response: final authEntity):
        emit(LoginViewModelSuccess(authEntity));
      case Error(message: final errorMessage):
        emit(LoginViewModelError(errorMessage));
    }
  }
}

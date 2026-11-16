part of 'login_view_model_cubit.dart';

sealed class LoginViewModelState {
  const LoginViewModelState();
}

final class LoginViewModelInitial extends LoginViewModelState {
  const LoginViewModelInitial();
}

final class LoginViewModelLoading extends LoginViewModelState {
  const LoginViewModelLoading();
}

final class LoginViewModelSuccess extends LoginViewModelState {
  final AuthEntity authEntity;

  const LoginViewModelSuccess(this.authEntity);
}

final class LoginViewModelError extends LoginViewModelState {
  final String message;

  const LoginViewModelError(this.message);
}

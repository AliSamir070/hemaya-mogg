part of 'signup_view_model_cubit.dart';

sealed class SignupViewModelState {
  const SignupViewModelState();
}

final class SignupViewModelInitial extends SignupViewModelState {
  const SignupViewModelInitial();
}

final class SignupViewModelLoading extends SignupViewModelState {
  const SignupViewModelLoading();
}

final class SignupViewModelSuccess extends SignupViewModelState {
  final AuthEntity authEntity;

  const SignupViewModelSuccess(this.authEntity);
}

final class SignupViewModelError extends SignupViewModelState {
  final String message;

  const SignupViewModelError(this.message);
}

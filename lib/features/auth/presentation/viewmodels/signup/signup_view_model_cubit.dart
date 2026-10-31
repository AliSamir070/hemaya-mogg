import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/resources/api_result.dart';
import '../../../domain/entity/auth_entity.dart';
import '../../../domain/usecase/signup_use_case.dart';

part 'signup_view_model_state.dart';

@injectable
class SignupViewModelCubit extends Cubit<SignupViewModelState> {
  final SignupUseCase _signupUseCase;

  SignupViewModelCubit(this._signupUseCase)
      : super(const SignupViewModelInitial());

  Future<void> signUp({
    required String name,
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    emit(const SignupViewModelLoading());

    final result = await _signupUseCase(
      name: name,
      fullName: fullName,
      phone: phone,
      email: email,
      password: password,
    );

    if (isClosed) return;

    switch (result) {
      case Success(response: final authEntity):
        emit(SignupViewModelSuccess(authEntity));
      case Error(message: final errorMessage):
        emit(SignupViewModelError(errorMessage));
    }
  }
}

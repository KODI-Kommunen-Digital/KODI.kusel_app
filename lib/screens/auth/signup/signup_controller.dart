import 'package:domain/model/request_model/signup/singup_request_model.dart';
import 'package:domain/model/response_model/signup_model/singup_response_model.dart';
import 'package:domain/usecase/signup/signup_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/auth/signup/signup_state.dart';

final signUpScreenProvider =
    StateNotifierProvider.autoDispose<SignUpController, SignUpState>((ref) =>
        SignUpController(signUpUseCase: ref.read(signUpUseCaseProvider)));

class SignUpController extends StateNotifier<SignUpState> {
  SignUpUseCase signUpUseCase;

  SignUpController({required this.signUpUseCase}) : super(SignUpState.empty());

  updateShowPasswordStatus(bool status) {
    state = state.copyWith(showPassword: status);
  }

  Future<void> registerUser({
    required String userName,
    required String password,
    required String firstName,
    required String lastName,
    required String email,
    required void Function(String) onError,
    required void Function(String?) onSuccess,
  }) async {
    try {
      SignUpRequestModel signUpRequestModel = SignUpRequestModel(
          email: email,
          password: password,
          firstname: firstName,
          lastname: lastName,
          username: userName);
      SignUpResponseModel signUpResponseModel = SignUpResponseModel();

      final result =
          await signUpUseCase.call(signUpRequestModel, signUpResponseModel);

      result.fold((l) {
        onError("");
      }, (r) {
        onSuccess(null);
      });
    } catch (error) {
      debugPrint('register user exception : $error');
    }
  }
}

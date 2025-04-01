import 'package:domain/model/request_model/forgot_password/forgot_password_request_model.dart';
import 'package:domain/model/response_model/forgot_password_response_model/forgot_password_response_model.dart';
import 'package:domain/usecase/forgot_password/forgot_password_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/auth/forgot_password/forgot_password_state.dart';

final forgotPasswordProvider = StateNotifierProvider.autoDispose<
        ForgotPasswordController, ForgotPasswordState>(
    (ref) => ForgotPasswordController(
        forgotPasswordUseCase: ref.read(forgotPasswordUseCaseProvider)));

class ForgotPasswordController extends StateNotifier<ForgotPasswordState> {
  ForgotPasswordUseCase forgotPasswordUseCase;

  ForgotPasswordController({required this.forgotPasswordUseCase})
      : super(ForgotPasswordState.empty());

  sendForgotPasswordRequest({
    required String userNameOrEmail,
    required String language,
    required void Function(String) onError,
    required void Function() onSuccess,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      ForgotPasswordRequestModel requestModel = ForgotPasswordRequestModel(
          userNameOrEmail: userNameOrEmail, language: language);
      ForgotPasswordResponseModel responseModel = ForgotPasswordResponseModel();

      final response =
          await forgotPasswordUseCase.call(requestModel, responseModel);

      response.fold((l) {
        state = state.copyWith(isLoading: false);
        onError(l.toString());
        debugPrint('Forgot password fold exception = $l');
      }, (r) {
        state = state.copyWith(isLoading: false);
        final response = r as ForgotPasswordResponseModel;
        if (response.message != null) {
          onError(response.message ?? "");
        } else {
          onSuccess();
        }
      });
    } catch (error) {
      debugPrint("forgot password exception = $error");
      onError(error.toString());
      state = state.copyWith(isLoading: false);
    }
  }
}

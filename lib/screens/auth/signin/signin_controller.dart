import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:domain/model/request_model/sigin/signin_request_model.dart';
import 'package:domain/model/response_model/sigin_model/sigin_response_model.dart';
import 'package:domain/usecase/sigin/sigin_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/auth/signin/signin_state.dart';

final signInScreenProvider =
    StateNotifierProvider.autoDispose<SignInController, SignInState>((ref) =>
        SignInController(
            signInUseCase: ref.read(signInUseCaseProvider),
            sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class SignInController extends StateNotifier<SignInState> {
  SignInUseCase signInUseCase;
  SharedPreferenceHelper sharedPreferenceHelper;

  SignInController(
      {required this.signInUseCase, required this.sharedPreferenceHelper})
      : super(SignInState.empty());

  updateShowPassword(bool value) {
    state = state.copyWith(showPassword: value);
  }

  Future<void> sigInUser(
      {required String userName,
      required String password,
      required void Function() success,
      required void Function(String message) error}) async {
    try {
      state = state.copyWith(showLoading: true);
      SignInRequestModel sigInRequestModel =
          SignInRequestModel(username: userName, password: password);

      SignInResponseModel signInResponseModel = SignInResponseModel();

      final result =
          await signInUseCase.call(sigInRequestModel, signInResponseModel);

      result.fold((l) {
        state = state.copyWith(showLoading: false);
        error(l.toString());
        debugPrint('sign in user fold Exception = $l');
      }, (r) {
        state = state.copyWith(showLoading: false);
        final response = (r as SignInResponseModel);

        if (response.data != null) {
          final userId = response.data?.userId ?? 0;
          final token = response.data?.accessToken ?? "";
          final refreshToken = response.data?.refreshToken ?? "";
          final isOnboardingComplete = response.data?.isOnBoarded ?? false;

          sharedPreferenceHelper.setString(refreshTokenKey, refreshToken);
          sharedPreferenceHelper.setString(tokenKey, token);
          sharedPreferenceHelper.setInt(userIdKey, userId);
          sharedPreferenceHelper.setString(
              onboardingKey, isOnboardingComplete.toString());
          success();
        }
      });
    } catch (error) {
      state = state.copyWith(showLoading: false);
      debugPrint(' Exception = $error');
    }
  }

  bool isOnboardingDone() {
    String onBoardingStatus =
        sharedPreferenceHelper.getString(onboardingKey) ?? "false";
    bool isOnBoarded = onBoardingStatus == 'true';
    return isOnBoarded;
  }
}

import 'dart:ui';

import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:domain/model/request_model/user_score/user_score_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:kusel/providers/guest_user_login_provider.dart';
import 'package:kusel/screens/kusel_setting_screen/kusel_setting_state.dart';
import 'package:domain/usecase/user_score/user_score_usecase.dart';
import '../../locale/locale_constant.dart';
import 'package:domain/model/response_model/user_score/user_score_response_model.dart';
import 'package:package_info_plus/package_info_plus.dart';

final kuselSettingScreenProvider =
    StateNotifierProvider<KuselSettingScreenController, KuselSettingState>(
        (ref) => KuselSettingScreenController(
            localeManagerController: ref.read(localeManagerProvider.notifier),
            signInStatusController: ref.read(signInStatusProvider.notifier),
            sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
            guestUserLogin: ref.read(guestUserLoginProvider),
            userScoreUseCase: ref.read(userScoreUseCaseProvider)));

class KuselSettingScreenController extends StateNotifier<KuselSettingState> {
  LocaleManagerController localeManagerController;
  SignInStatusController signInStatusController;
  SharedPreferenceHelper sharedPreferenceHelper;
  GuestUserLogin guestUserLogin;
  UserScoreUseCase userScoreUseCase;

  KuselSettingScreenController(
      {required this.localeManagerController,
      required this.signInStatusController,
      required this.sharedPreferenceHelper,
      required this.guestUserLogin,
      required this.userScoreUseCase})
      : super(KuselSettingState.empty());

  void fetchCurrentLanguage() {
    final savedLanguageCode = sharedPreferenceHelper.getString(languageKey);

    if (savedLanguageCode != null) {
      if (savedLanguageCode == LocaleConstant.english.languageCode) {
        state = state.copyWith(
            selectedLanguage: LocaleConstant.english.displayName);
      } else if (savedLanguageCode == LocaleConstant.german.languageCode) {
        state =
            state.copyWith(selectedLanguage: LocaleConstant.german.displayName);
      }
    } else {
      final languageCode =
          localeManagerController.getSelectedLocale().languageCode;

      if (languageCode == LocaleConstant.english.languageCode) {
        state = state.copyWith(
            selectedLanguage: LocaleConstant.english.displayName);
      } else if (languageCode == LocaleConstant.german.languageCode) {
        state =
            state.copyWith(selectedLanguage: LocaleConstant.german.displayName);
      }
    }
  }

  changeLanguage({required String selectedLanguage}) async {
    String languageCode = "";
    String region = "";

    if (LocaleConstant.english.displayName == selectedLanguage) {
      languageCode = LocaleConstant.english.languageCode;
      region = LocaleConstant.english.region;
    } else if (LocaleConstant.german.displayName == selectedLanguage) {
      languageCode = LocaleConstant.german.languageCode;
      region = LocaleConstant.german.region;
    }
    localeManagerController.updateSelectedLocale(Locale(languageCode, region));

    state = state.copyWith(selectedLanguage: selectedLanguage);
  }

  isUserLoggedIn() async {
    final ans = await signInStatusController.isUserLoggedIn();

    state = state.copyWith(isUserLoggedIn: ans);
  }

  logoutUser(Future<void> Function() callBack,
      {VoidCallback? onSuccess}) async {
    state = state.copyWith(isLoading: true);
    await sharedPreferenceHelper.clear();
    await callBack();

    await guestUserLogin.getGuestUserToken();
    state = state.copyWith(isLoading: false);

    if (onSuccess != null) {
      onSuccess();
    }
  }

  getUserScore() async {
    try {
      state = state.copyWith(isLoading: true);
      UserScoreRequestModel requestModel = UserScoreRequestModel();
      UserScoreResponseModel responseModel = UserScoreResponseModel();

      final res = await userScoreUseCase.call(requestModel, responseModel);

      res.fold((l) {
        debugPrint('user score exception : $l');
        state = state.copyWith(isLoading: false);
      }, (r) {
        final result = r as UserScoreResponseModel;

        if (result.data != null) {
          state = state.copyWith(
              totalPoints: result.data?.totalPoints ?? 0,
              totalStamp: result.data?.stamp ?? 0);
        }
        state = state.copyWith(isLoading: false);
      });
    } catch (error) {
      debugPrint('user score exception : $error');
      state = state.copyWith(isLoading: false);
    }
  }

  getAppVersion()async{
    final obj = await PackageInfo.fromPlatform();

    final appVersion = obj.version;

    state = state.copyWith(appVersion: appVersion);

  }
}

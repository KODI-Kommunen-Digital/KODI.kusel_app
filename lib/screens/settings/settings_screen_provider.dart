import 'dart:ui';

import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:domain/usecase/edit_user_detail/edit_user_detail_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/locale/locale_constant.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:kusel/screens/home/home_screen_provider.dart';
import 'package:kusel/screens/settings/settings_screen_state.dart';

final settingsScreenProvider =
    StateNotifierProvider<SettingsScreenProvider, SettingsScreenState>((ref) =>
        SettingsScreenProvider(
            localeManagerController: ref.read(localeManagerProvider.notifier),
            sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
            editUserDetailUseCase: ref.read(editUserDetailUseCaseProvider),
            homeScreenProvider: ref.read(homeScreenProvider.notifier),
            signInStatusController: ref.read(signInStatusProvider.notifier)));

class SettingsScreenProvider extends StateNotifier<SettingsScreenState> {
  LocaleManagerController localeManagerController;
  SharedPreferenceHelper sharedPreferenceHelper;
  EditUserDetailUseCase editUserDetailUseCase;
  HomeScreenProvider homeScreenProvider;
  SignInStatusController signInStatusController;

  SettingsScreenProvider(
      {required this.localeManagerController,
      required this.sharedPreferenceHelper,
      required this.editUserDetailUseCase,
      required this.homeScreenProvider,
      required this.signInStatusController})
      : super(SettingsScreenState.empty());

  logoutUser(void Function() callBack) async {
    await sharedPreferenceHelper.clear();
    callBack();
    isLoggedIn();
    homeScreenProvider.getLoginStatus();
  }

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
    }
  }

  changeLanguage({required String selectedLanguage}) {
    state = state.copyWith(selectedLanguage: selectedLanguage);

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
  }

  Future<void> isLoggedIn() async{
    final status = await signInStatusController.isUserLoggedIn();
    state = state.copyWith(isLoggedIn: status);
  }
}

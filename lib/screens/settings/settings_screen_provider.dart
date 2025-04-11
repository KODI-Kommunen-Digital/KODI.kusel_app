import 'dart:ui';

import 'package:core/preference_manager/preference_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/locale/locale_constant.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:kusel/screens/settings/settings_screen_state.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';

final settingsScreenProvider =
StateNotifierProvider<SettingsScreenProvider, SettingsScreenState>((ref) =>
    SettingsScreenProvider(
        localeManagerController: ref.read(localeManagerProvider.notifier),
        sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class SettingsScreenProvider extends StateNotifier<SettingsScreenState> {
  LocaleManagerController localeManagerController;
  SharedPreferenceHelper sharedPreferenceHelper;

  SettingsScreenProvider(
      {required this.localeManagerController, required this.sharedPreferenceHelper})
      : super(SettingsScreenState.empty());

  logoutUser(void Function() callBack)async {
    await sharedPreferenceHelper.clear();
    callBack();
    getLoginStatus();

  }

  void getLoginStatus() {
    final token = sharedPreferenceHelper.getString(tokenKey);
    if (token == null) {
      state = state.copyWith(isSignupButtonVisible: true);
    } else {
      state = state.copyWith(isSignupButtonVisible: false);
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

    localeManagerController
        .updateCurrentSelectedLocale(Locale(languageCode, region));
  }
}

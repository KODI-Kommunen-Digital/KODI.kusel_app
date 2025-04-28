import 'dart:ui';

import 'package:core/preference_manager/preference_constant.dart';
import 'package:domain/model/request_model/edit_user_detail/edit_user_detail_request_model.dart';
import 'package:domain/model/response_model/edit_user_detail/edit_user_detail_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/locale/locale_constant.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:kusel/screens/settings/settings_screen_state.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:domain/usecase/edit_user_detail/edit_user_detail_usecase.dart';

final settingsScreenProvider =
    StateNotifierProvider<SettingsScreenProvider, SettingsScreenState>((ref) =>
        SettingsScreenProvider(
            localeManagerController: ref.read(localeManagerProvider.notifier),
            sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
            editUserDetailUseCase: ref.read(editUserDetailUseCaseProvider)));

class SettingsScreenProvider extends StateNotifier<SettingsScreenState> {
  LocaleManagerController localeManagerController;
  SharedPreferenceHelper sharedPreferenceHelper;
  EditUserDetailUseCase editUserDetailUseCase;

  SettingsScreenProvider(
      {required this.localeManagerController,
      required this.sharedPreferenceHelper,
      required this.editUserDetailUseCase})
      : super(SettingsScreenState.empty());

  logoutUser(void Function() callBack) async {
    await sharedPreferenceHelper.clear();
    callBack();
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
}

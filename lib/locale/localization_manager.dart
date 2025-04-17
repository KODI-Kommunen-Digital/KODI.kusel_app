import 'dart:ui';

import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/locale/locale_constant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final localeManagerProvider =
    StateNotifierProvider<LocaleManagerController, LocaleManagerState>(
  (ref) => LocaleManagerController(
      sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)),
);

class LocaleManagerController extends StateNotifier<LocaleManagerState> {
  SharedPreferenceHelper sharedPreferenceHelper;

  LocaleManagerController({required this.sharedPreferenceHelper})
      : super(LocaleManagerState.empty());

  void updateCurrentSelectedLocale(Locale updatedLocale) {
    final savedLanguageCode = sharedPreferenceHelper.getString(languageKey);

    Locale newLocale;

    if (savedLanguageCode != null &&
        savedLanguageCode == updatedLocale.languageCode) {
      newLocale = AppLocalizations.supportedLocales.firstWhere(
        (locale) => locale.languageCode == savedLanguageCode,
        orElse: () => updatedLocale,
      );
    } else {
      newLocale = AppLocalizations.supportedLocales.firstWhere(
        (locale) => locale.languageCode == updatedLocale.languageCode,
        orElse: () => const Locale('en', 'GB'),
      );
    }
    sharedPreferenceHelper.setString(languageKey, updatedLocale.languageCode);

    state = state.copyWith(currentLocale: newLocale);
  }
}

class LocaleManagerState {
  final Locale currentLocale;

  LocaleManagerState(this.currentLocale);

  factory LocaleManagerState.empty() {
    return LocaleManagerState(Locale(
        LocaleConstant.english.languageCode, LocaleConstant.english.region));
  }

  LocaleManagerState copyWith({Locale? currentLocale}) {
    return LocaleManagerState(currentLocale ?? this.currentLocale);
  }
}

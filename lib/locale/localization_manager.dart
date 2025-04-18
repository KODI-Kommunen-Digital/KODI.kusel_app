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

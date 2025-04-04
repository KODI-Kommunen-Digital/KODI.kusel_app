import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/locale/locale_constant.dart';

final localeManagerProvider =
    StateNotifierProvider<LocaleManagerController, LocaleManagerState>(
  (ref) => LocaleManagerController(),
);

class LocaleManagerController extends StateNotifier<LocaleManagerState> {
  LocaleManagerController() : super(LocaleManagerState.empty());

  void updateCurrentSelectedLocale(Locale locale) {
    state = state.copyWith(currentLocale: locale);
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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

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
    return LocaleManagerState(const Locale('en', 'GB'));
  }

  LocaleManagerState copyWith({Locale? currentLocale}) {
    return LocaleManagerState(currentLocale ?? this.currentLocale);
  }
}

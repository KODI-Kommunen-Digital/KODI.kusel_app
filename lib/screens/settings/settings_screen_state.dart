import 'package:kusel/locale/locale_constant.dart';

class SettingsScreenState {
  List<String> languageList;
  String selectedLanguage;
  bool isSignupButtonVisible;

  SettingsScreenState(
      this.languageList, this.selectedLanguage, this.isSignupButtonVisible);

  factory SettingsScreenState.empty() {
    return SettingsScreenState(
        [LocaleConstant.english.displayName, LocaleConstant.german.displayName],
        LocaleConstant.english.displayName,
        true);
  }

  SettingsScreenState copyWith(
      {List<String>? languageList,
      String? selectedLanguage,
      String? selectedLanguageCode,
      bool? isSignupButtonVisible}) {
    return SettingsScreenState(
        languageList ?? this.languageList,
        selectedLanguage ?? this.selectedLanguage,
        isSignupButtonVisible ?? this.isSignupButtonVisible);
  }
}

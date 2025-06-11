import 'package:kusel/locale/locale_constant.dart';

class SettingsScreenState {
  List<String> languageList;
  String selectedLanguage;
  bool isLoggedIn;

  SettingsScreenState(
      this.languageList, this.selectedLanguage, this.isLoggedIn);

  factory SettingsScreenState.empty() {
    return SettingsScreenState(
        [LocaleConstant.english.displayName, LocaleConstant.german.displayName],
        LocaleConstant.german.displayName,
        false);
  }

  SettingsScreenState copyWith(
      {List<String>? languageList,
      String? selectedLanguage,
      bool? isLoggedIn}) {
    return SettingsScreenState(
        languageList ?? this.languageList,
        selectedLanguage ?? this.selectedLanguage,
        isLoggedIn ?? this.isLoggedIn);
  }
}

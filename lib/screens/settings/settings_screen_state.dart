import 'package:kusel/locale/locale_constant.dart';

class SettingsScreenState {
  List<String> languageList;
  String selectedLanguage;

  SettingsScreenState(this.languageList, this.selectedLanguage);

  factory SettingsScreenState.empty() {
    return SettingsScreenState(
        [LocaleConstant.english.displayName, LocaleConstant.german.displayName],
        LocaleConstant.english.displayName);
  }

  SettingsScreenState copyWith(
      {List<String>? languageList,
      String? selectedLanguage,
      String? selectedLanguageCode}) {
    return SettingsScreenState(languageList ?? this.languageList,
        selectedLanguage ?? this.selectedLanguage);
  }
}

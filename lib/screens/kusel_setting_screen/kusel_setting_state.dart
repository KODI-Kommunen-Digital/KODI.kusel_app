import '../../locale/locale_constant.dart';

class KuselSettingState {
  List<String> languageList;
  String selectedLanguage;
  bool isUserLoggedIn;
  bool isLoading;
  int totalPoints;
  int totalStamp;

  KuselSettingState(this.languageList, this.selectedLanguage,
      this.isUserLoggedIn, this.isLoading, this.totalPoints, this.totalStamp);

  factory KuselSettingState.empty() {
    return KuselSettingState(
        [LocaleConstant.english.displayName, LocaleConstant.german.displayName],
        LocaleConstant.german.displayName,
        false,
        false,
        0,
        0);
  }

  KuselSettingState copyWith(
      {List<String>? languageList,
      String? selectedLanguage,
      bool? isUserLoggedIn,
      bool? isLoading,
      int? totalPoints,
      int? totalStamp}) {
    return KuselSettingState(
        languageList ?? this.languageList,
        selectedLanguage ?? this.selectedLanguage,
        isUserLoggedIn ?? this.isUserLoggedIn,
        isLoading ?? this.isLoading,
        totalPoints ?? this.totalPoints,
        totalStamp ?? this.totalStamp);
  }
}

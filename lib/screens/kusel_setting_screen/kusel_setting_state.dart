import 'package:domain/model/response_model/user_detail/user_detail_response_model.dart';

import '../../locale/locale_constant.dart';

class KuselSettingState {
  List<String> languageList;
  String selectedLanguage;
  bool isUserLoggedIn;
  bool isLoading;
  int totalPoints;
  int totalStamp;
  String appVersion;
  bool isLegalPolicyLoading;
  String legalPolicyData;
  bool isProfilePageLoading;
  List<UserDetailInterest> listOfUserInterest;
  String selectedOrt;

  String name;
  String email;
  String mobileNumber;
  String address;

  bool isLocationPermissionGranted;

  KuselSettingState(
      this.languageList,
      this.selectedLanguage,
      this.isUserLoggedIn,
      this.isLoading,
      this.totalPoints,
      this.totalStamp,
      this.appVersion,
      this.isLegalPolicyLoading,
      this.legalPolicyData,
      this.isProfilePageLoading,
      this.listOfUserInterest,
      this.selectedOrt,
      this.name,
      this.email,
      this.mobileNumber,
      this.address,
      this.isLocationPermissionGranted);

  factory KuselSettingState.empty() {
    return KuselSettingState(
        [LocaleConstant.english.displayName, LocaleConstant.german.displayName],
        LocaleConstant.german.displayName,
        false,
        false,
        0,
        0,
        '',
        false,
        '',
        false,
        [],
        '',
        '',
        '',
        '',
        '',
        false);
  }

  KuselSettingState copyWith(
      {List<String>? languageList,
      String? selectedLanguage,
      bool? isUserLoggedIn,
      bool? isLoading,
      int? totalPoints,
      int? totalStamp,
      String? appVersion,
      bool? isLegalPolicyLoading,
      String? legalPolicyData,
      bool? isProfilePageLoading,
      List<UserDetailInterest>? listOfUserInterest,
      String? selectedOrt,
      String? name,
      String? email,
      String? mobileNumber,
      String? address,
      bool? isLocationPermissionGranted}) {
    return KuselSettingState(
        languageList ?? this.languageList,
        selectedLanguage ?? this.selectedLanguage,
        isUserLoggedIn ?? this.isUserLoggedIn,
        isLoading ?? this.isLoading,
        totalPoints ?? this.totalPoints,
        totalStamp ?? this.totalStamp,
        appVersion ?? this.appVersion,
        isLegalPolicyLoading ?? this.isLegalPolicyLoading,
        legalPolicyData ?? this.legalPolicyData,
        isProfilePageLoading ?? this.isProfilePageLoading,
        listOfUserInterest ?? this.listOfUserInterest,
        selectedOrt ?? this.selectedOrt,
        name ?? this.name,
        email ?? this.email,
        mobileNumber ?? this.mobileNumber,
        address ?? this.address,
        isLocationPermissionGranted ?? this.isLocationPermissionGranted);
  }
}

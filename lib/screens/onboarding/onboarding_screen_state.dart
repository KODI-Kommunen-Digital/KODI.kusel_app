class OnboardingScreenState {
  int selectedPageIndex;
  String onBoardingButtonText;
  List<String> residenceList;
  String resident;
  String userNam;
  bool isLoading;

  OnboardingScreenState(this.selectedPageIndex, this.onBoardingButtonText,
      this.residenceList, this.resident, this.userNam, this.isLoading);

  factory OnboardingScreenState.empty() {
    return OnboardingScreenState(
        0, '', ['Option 1', 'Option 2', 'Option 3', 'Option 4'], '', '', false);
  }

  OnboardingScreenState copyWith(
      {int? selectedPageIndex,
      String? onBoardingButtonText,
      List<String>? residenceList,
      String? resident,
      String? userName,
      bool? isLoading}) {
    return OnboardingScreenState(
        selectedPageIndex ?? this.selectedPageIndex,
        onBoardingButtonText ?? this.onBoardingButtonText,
        residenceList ?? this.residenceList,
        resident ?? this.resident,
        userName ?? this.userNam,
        isLoading ?? this.isLoading);
  }
}

class OnboardingScreenState {
  int selectedPageIndex;
  String onBoardingButtonText;
  List<String> residenceList;
  String? resident;
  String userNam;
  bool isLoading;
  bool isTourist;
  bool isResident;
  double loadingPercentage;
  bool isSingle;
  bool isForTwo;
  bool isWithFamily;
  bool isWithDog;
  bool isBarrierearm;
  bool isErrorMsgVisible;

  OnboardingScreenState(
      this.selectedPageIndex,
      this.onBoardingButtonText,
      this.residenceList,
      this.resident,
      this.userNam,
      this.isLoading,
      this.isTourist,
      this.isResident,
      this.loadingPercentage,
      this.isSingle,
      this.isForTwo,
      this.isWithFamily,
      this.isWithDog,
      this.isBarrierearm,
      this.isErrorMsgVisible
      );

  factory OnboardingScreenState.empty() {
    return OnboardingScreenState(
      0,
      '',
      ['City 1', 'City 2', 'City 3', 'City 4'],
      null,
      '',
      false,
      false,
      false,
      0,
      false,
      false,
      false,
      false,
      false,
      false
    );
  }

  OnboardingScreenState copyWith({
    int? selectedPageIndex,
    String? onBoardingButtonText,
    List<String>? residenceList,
    String? resident,
    String? userName,
    bool? isLoading,
    bool? isTourist,
    bool? isResident,
    double? loadingPercentage,
    bool? isSingle,
    bool? isForTwo,
    bool? isWithFamily,
    bool? isWithDog,
    bool? isBarrierearm,
    bool? isErrorMsgVisible
  }) {
    return OnboardingScreenState(
        selectedPageIndex ?? this.selectedPageIndex,
        onBoardingButtonText ?? this.onBoardingButtonText,
        residenceList ?? this.residenceList,
        resident ?? this.resident,
        userName ?? this.userNam,
        isLoading ?? this.isLoading,
        isTourist ?? this.isTourist,
        isResident ?? this.isResident,
        loadingPercentage ?? this.loadingPercentage,
        isSingle ?? this.isSingle,
        isForTwo ?? this.isForTwo,
        isWithFamily ?? this.isWithFamily,
        isWithDog ?? this.isWithDog,
        isBarrierearm ?? this.isBarrierearm,
        isErrorMsgVisible ?? this.isErrorMsgVisible);
  }
}

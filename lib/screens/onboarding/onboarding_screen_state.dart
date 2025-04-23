class OnboardingScreenState {
  int selectedPageIndex;
  String onBoardingButtonText;
  List<String> residenceList;
  String resident;
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
      );

  factory OnboardingScreenState.empty() {
    return OnboardingScreenState(
      0,
      '',
      ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
      '',
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
    );
  }
}

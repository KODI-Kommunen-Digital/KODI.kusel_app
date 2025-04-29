class FilterScreenState {
  List<String> periodItems;
  List<String> targetGroupItems;
  List<String> ortItems;
  String periodValue;
  String targetGroupValue;
  String ortItemValue;
  double sliderValue;
  bool isActualityEnabled;
  bool isDistanceEnabled;
  Map<String, bool> toggleFiltersMap;

  FilterScreenState(
      this.periodItems,
      this.targetGroupItems,
      this.ortItems,
      this.periodValue,
      this.targetGroupValue,
      this.ortItemValue,
      this.sliderValue,
      this.isActualityEnabled,
      this.isDistanceEnabled,
      this.toggleFiltersMap);

  factory FilterScreenState.empty() {
    return FilterScreenState(
        ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
        ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
        ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
        'Select option',
        'Select option',
        'Select option',
        0,
        false,
        false,
        {
          'Dogs allowed': false,
          'Accessible': false,
          'Reachable by public transport': false,
          'Free of charge': false,
          'Bookable online': false,
          'Open air': false,
          'Card payment possible': false,
        });
  }

  FilterScreenState copyWith(
      {List<String>? periodItems,
      List<String>? targetGroupItems,
      List<String>? ortItems,
      String? periodValue,
      String? targetGroupValue,
      String? ortItemValue,
      double? sliderValue,
      bool? isActualityEnabled,
      bool? isDistanceEnabled,
      Map<String, bool>? toggleFiltersMap}) {
    return FilterScreenState(
        periodItems ?? this.periodItems,
        targetGroupItems ?? this.targetGroupItems,
        ortItems ?? this.ortItems,
        periodValue ?? this.periodValue,
        targetGroupValue ?? this.targetGroupValue,
        ortItemValue ?? this.ortItemValue,
        sliderValue ?? this.sliderValue,
        isActualityEnabled ?? this.isActualityEnabled,
        isDistanceEnabled ?? this.isDistanceEnabled,
        toggleFiltersMap ?? this.toggleFiltersMap);
  }
}

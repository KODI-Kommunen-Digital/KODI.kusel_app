class DashboardScreenState {
  int selectedIndex;
  bool isSignupButtonVisible;

  DashboardScreenState(this.selectedIndex, this.isSignupButtonVisible);

  factory DashboardScreenState.empty() {
    return DashboardScreenState(0, true);
  }

  DashboardScreenState copyWith({
    int? selectedIndex,
    bool? isSignupButtonVisible,
  }) {
    return DashboardScreenState(selectedIndex ?? this.selectedIndex,
        isSignupButtonVisible ?? this.isSignupButtonVisible);
  }
}

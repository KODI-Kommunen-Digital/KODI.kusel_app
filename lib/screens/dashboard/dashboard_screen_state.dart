class DashboardScreenState {
  int selectedIndex;

  DashboardScreenState(this.selectedIndex);

  factory DashboardScreenState.empty() {
    return DashboardScreenState(0);
  }

  DashboardScreenState copyWith({int? selectedIndex}) {
    return DashboardScreenState(selectedIndex ?? this.selectedIndex);
  }
}

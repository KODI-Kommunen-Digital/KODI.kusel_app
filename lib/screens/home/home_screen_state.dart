class HomeScreenState {
  int highlightCount;

  HomeScreenState(this.highlightCount);

  factory HomeScreenState.empty() {
    return HomeScreenState(0);
  }

  HomeScreenState copyWith({int? highlightCount}) {
    return HomeScreenState(highlightCount ?? this.highlightCount);
  }
}

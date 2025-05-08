class ExploreState {
  List<String> exploreTypeList;
  List<String> exploreTypeListImages;

  ExploreState(this.exploreTypeList, this.exploreTypeListImages);

  factory ExploreState.empty() {
    return ExploreState([], []);
  }

  ExploreState copyWith(
      {List<String>? exploreTypeList, List<String>? exploreTypeListImages}) {
    return ExploreState(exploreTypeList ?? this.exploreTypeList,
        exploreTypeListImages ?? this.exploreTypeListImages);
  }
}

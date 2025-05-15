class MobilityScreenState {
  bool isLoading;

  MobilityScreenState(this.isLoading);

  factory MobilityScreenState.empty() {
    return MobilityScreenState(false);
  }

  MobilityScreenState copyWith({bool? isLoading}) {
    return MobilityScreenState(isLoading ?? this.isLoading);
  }
}

class ParticipateScreenState {
  bool isLoading;

  ParticipateScreenState(this.isLoading);

  factory ParticipateScreenState.empty() {
    return ParticipateScreenState(false);
  }

  ParticipateScreenState copyWith({bool? isLoading}) {
    return ParticipateScreenState(isLoading ?? this.isLoading);
  }
}

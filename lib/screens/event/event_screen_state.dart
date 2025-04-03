class EventScreenState {
  String address;
  String error;
  bool loading;

  EventScreenState(this.address, this.error, this.loading);

  factory EventScreenState.empty() {
    return EventScreenState('', '', false);
  }

  EventScreenState copyWith({String? address, String? error, bool? loading}) {
    return EventScreenState(
        address ?? this.address, error ?? this.error, loading ?? this.loading);
  }
}

import 'package:domain/model/response_model/event_details/event_details_response_model.dart';

class EventScreenState {
  String address;
  String error;
  bool loading;
  EventData eventDetails;

  EventScreenState(this.address, this.error, this.loading, this.eventDetails);

  factory EventScreenState.empty() {
    return EventScreenState('', '', false, EventData());
  }

  EventScreenState copyWith(
      {String? address, String? error, bool? loading, EventData? eventDetails}) {
    return EventScreenState(address ?? this.address, error ?? this.error,
        loading ?? this.loading, eventDetails ?? this.eventDetails);
  }
}

import 'package:domain/model/response_model/event_details/event_details_response_model.dart';

class EventDetailScreenState {
  String address;
  String error;
  bool loading;
  EventData eventDetails;

  EventDetailScreenState(this.address, this.error, this.loading, this.eventDetails);

  factory EventDetailScreenState.empty() {
    return EventDetailScreenState('', '', false, EventData());
  }

  EventDetailScreenState copyWith(
      {String? address, String? error, bool? loading, EventData? eventDetails}) {
    return EventDetailScreenState(address ?? this.address, error ?? this.error,
        loading ?? this.loading, eventDetails ?? this.eventDetails);
  }
}

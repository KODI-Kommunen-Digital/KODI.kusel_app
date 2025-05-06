import 'package:domain/model/response_model/event_details/event_details_response_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';

class EventDetailScreenState {
  String address;
  String error;
  bool loading;
  EventData eventDetails;
  List<Listing> eventsList;
  Map<int, List<Listing>> groupedEvents;

  EventDetailScreenState(this.address, this.error, this.loading,
      this.eventDetails, this.eventsList, this.groupedEvents);

  factory EventDetailScreenState.empty() {
    return EventDetailScreenState('', '', false, EventData(), [], {});
  }

  EventDetailScreenState copyWith(
      {String? address,
      String? error,
      bool? loading,
      EventData? eventDetails,
      List<Listing>? eventsList,
      Map<int, List<Listing>>? groupedEvents}) {
    return EventDetailScreenState(
        address ?? this.address,
        error ?? this.error,
        loading ?? this.loading,
        eventDetails ?? this.eventDetails,
        eventsList ?? this.eventsList,
        groupedEvents ?? this.groupedEvents);
  }
}

import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';

class EventListScreenState {
  String address;
  String error;
  bool loading;
  List<Listing> eventsList;

  EventListScreenState(this.address, this.error, this.loading, this.eventsList);

  factory EventListScreenState.empty() {
    return EventListScreenState('', '', false, []);
  }

  EventListScreenState copyWith(
      {String? address, String? error, bool? loading, List<Listing>? list}) {
    return EventListScreenState(address ?? this.address, error ?? this.error,
        loading ?? this.loading, list ?? this.eventsList);
  }
}

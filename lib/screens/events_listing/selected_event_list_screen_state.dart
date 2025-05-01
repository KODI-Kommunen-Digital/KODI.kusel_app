import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';

class SelectedEventListScreenState {
  String address;
  String error;
  bool loading;
  List<Listing> eventsList;

  SelectedEventListScreenState(this.address, this.error, this.loading, this.eventsList);

  factory SelectedEventListScreenState.empty() {
    return SelectedEventListScreenState('', '', false, []);
  }

  SelectedEventListScreenState copyWith(
      {String? address, String? error, bool? loading, List<Listing>? list}) {
    return SelectedEventListScreenState(address ?? this.address, error ?? this.error,
        loading ?? this.loading, list ?? this.eventsList);
  }
}

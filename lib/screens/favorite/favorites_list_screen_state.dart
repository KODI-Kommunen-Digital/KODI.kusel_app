import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';

class FavoritesListScreenState {
  String address;
  String error;
  bool loading;
  List<Listing> eventsList;

  FavoritesListScreenState(this.address, this.error, this.loading, this.eventsList);

  factory FavoritesListScreenState.empty() {
    return FavoritesListScreenState('', '', false, []);
  }

  FavoritesListScreenState copyWith(
      {String? address, String? error, bool? loading, List<Listing>? list}) {
    return FavoritesListScreenState(address ?? this.address, error ?? this.error,
        loading ?? this.loading, list ?? this.eventsList);
  }
}

import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';

class HomeScreenState {
  int highlightCount;
  bool loading;
  String error;
  final List<Listing> listings;

  HomeScreenState(this.highlightCount, this.loading, this.error, this.listings);

  factory HomeScreenState.empty() {
    return HomeScreenState(0, false, '', []);
  }

  HomeScreenState copyWith(
      {int? highlightCount,
      bool? loading,
      String? error,
      List<Listing>? listings}) {
    return HomeScreenState(
        highlightCount ?? this.highlightCount,
        loading ?? this.loading,
        error ?? this.error,
        listings ?? this.listings);
  }
}

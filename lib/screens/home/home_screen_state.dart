import 'package:domain/model/response_model/favorites/get_favorites_response_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';

class HomeScreenState {
  int highlightCount;
  bool loading;
  String error;
  final List<Listing> highlightsList;
  final List<Listing> eventsList;
  String userName;
  final List<FavoritesItem> favoritesList;

  HomeScreenState(this.highlightCount, this.loading, this.error,
      this.highlightsList, this.eventsList, this.userName, this.favoritesList);

  factory HomeScreenState.empty() {
    return HomeScreenState(0, false, '', [], [], "", []);
  }

  HomeScreenState copyWith(
      {int? highlightCount,
      bool? loading,
      String? error,
      List<Listing>? highlightsList,
      List<Listing>? eventsList,
      String? userName,
      List<FavoritesItem>? favoritesList}) {
    return HomeScreenState(
        highlightCount ?? this.highlightCount,
        loading ?? this.loading,
        error ?? this.error,
        highlightsList ?? this.highlightsList,
        eventsList ?? this.eventsList,
        userName ?? this.userName,
        favoritesList ?? this.favoritesList);
  }
}

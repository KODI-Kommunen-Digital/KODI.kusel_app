import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';

class TourismScreenState {
  List<Listing> allEventList;
  List<Listing> nearByList;
  List<Listing> recommendationList;

  TourismScreenState(
      this.allEventList, this.nearByList, this.recommendationList);

  factory TourismScreenState.empty() {
    return TourismScreenState([], [], []);
  }

  TourismScreenState copyWith(
      {List<Listing>? allEventList,
      List<Listing>? nearByList,
      List<Listing>? recommendationList}) {
    return TourismScreenState(
        allEventList ?? this.allEventList,
        nearByList ?? this.nearByList,
        recommendationList ?? this.recommendationList);
  }
}

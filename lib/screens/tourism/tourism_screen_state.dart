import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';

class TourismScreenState {
  List<Listing> allEventList;
  List<Listing> nearByList;
  List<Listing> recommendationList;
  double lat;
  double long;
  bool isRecommendationLoading;

  TourismScreenState(
      this.allEventList,
      this.nearByList,
      this.recommendationList,
      this.lat,
      this.long,
      this.isRecommendationLoading);

  factory TourismScreenState.empty() {
    return TourismScreenState([], [], [], 0, 0, true);
  }

  TourismScreenState copyWith(
      {List<Listing>? allEventList,
      List<Listing>? nearByList,
      List<Listing>? recommendationList,
      double? lat,
      double? long,
      bool? isRecommendationLoading}) {
    return TourismScreenState(
        allEventList ?? this.allEventList,
        nearByList ?? this.nearByList,
        recommendationList ?? this.recommendationList,
        lat ?? this.lat,
        long ?? this.long,
        isRecommendationLoading ?? this.isRecommendationLoading);
  }
}

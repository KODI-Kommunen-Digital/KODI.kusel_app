import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';

class AllEventScreenState {
  List<Listing> listingList;
  bool isLoading;
  int? filterCount;
  bool isUserLoggedIn;

  AllEventScreenState(
      this.listingList, this.isLoading, this.filterCount, this.isUserLoggedIn);

  factory AllEventScreenState.empty() {
    return AllEventScreenState([], false, null, false);
  }

  AllEventScreenState copyWith(
      {List<Listing>? listingList,
      bool? isLoading,
      int? filterCount,
      bool? isUserLoggedIn}) {
    return AllEventScreenState(
        listingList ?? this.listingList,
        isLoading ?? this.isLoading,
        filterCount ?? this.filterCount,
        isUserLoggedIn ?? this.isUserLoggedIn);
  }
}

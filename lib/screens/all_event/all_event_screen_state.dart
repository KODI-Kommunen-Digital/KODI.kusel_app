import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';

class AllEventScreenState {
  List<Listing> listingList;
  bool isLoading;
  int? filterCount;

  AllEventScreenState(this.listingList, this.isLoading, this.filterCount);

  factory AllEventScreenState.empty() {
    return AllEventScreenState([], false, null);
  }

  AllEventScreenState copyWith(
      {List<Listing>? listingList, bool? isLoading, int? filterCount}) {
    return AllEventScreenState(listingList ?? this.listingList,
        isLoading ?? this.isLoading, filterCount ?? this.filterCount);
  }
}

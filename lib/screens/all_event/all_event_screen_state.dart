import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';

class AllEventScreenState {
  List<Listing> listingList;
  bool isLoading;

  AllEventScreenState(this.listingList, this.isLoading);

  factory AllEventScreenState.empty() {
    return AllEventScreenState([], false);
  }

  AllEventScreenState copyWith({List<Listing>? listingList, bool? isLoading}) {
    return AllEventScreenState(
        listingList ?? this.listingList, isLoading ?? this.isLoading);
  }
}

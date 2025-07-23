import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';

class AllEventScreenState {
  List<Listing> listingList;
  bool isLoading;
  int? filterCount;
  bool isUserLoggedIn;
  int currentPageNo;
  bool isMoreListLoading;
  bool isLoadMoreButtonEnabled;

  AllEventScreenState(this.listingList, this.isLoading, this.filterCount,
      this.isUserLoggedIn, this.currentPageNo, this.isMoreListLoading, this.isLoadMoreButtonEnabled);

  factory AllEventScreenState.empty() {
    return AllEventScreenState([], false, null, false, 1, false, true);
  }

  AllEventScreenState copyWith(
      {List<Listing>? listingList,
      bool? isLoading,
      int? filterCount,
      bool? isUserLoggedIn,
      int? currentPageNo,
      bool? isMoreListLoading,
      bool? isLoadMoreButtonEnabled
      }) {
    return AllEventScreenState(
        listingList ?? this.listingList,
        isLoading ?? this.isLoading,
        filterCount ?? this.filterCount,
        isUserLoggedIn ?? this.isUserLoggedIn,
        currentPageNo ?? this.currentPageNo,
        isMoreListLoading ?? this.isMoreListLoading,
        isLoadMoreButtonEnabled ?? this.isLoadMoreButtonEnabled
    );
  }
}

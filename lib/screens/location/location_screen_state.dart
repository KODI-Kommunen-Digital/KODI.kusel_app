import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';

import 'bottom_sheet_selected_ui_type.dart';

class LocationScreenState {
  List<Listing> allEventList;
  bool isLoading;
  BottomSheetSelectedUIType bottomSheetSelectedUIType;
  int? selectedCategoryId;
  int? selectedSubCategoryId;
  List<Listing> distinctCategoryList;

  LocationScreenState(
    this.allEventList,
    this.isLoading,
    this.bottomSheetSelectedUIType,
    this.selectedCategoryId,
    this.selectedSubCategoryId,
    this.distinctCategoryList,
  );

  factory LocationScreenState.empty() {
    return LocationScreenState(
        [], false, BottomSheetSelectedUIType.allEvent, null, null, []);
  }

  LocationScreenState copyWith({
    List<Listing>? allEventList,
    bool? isLoading,
    BottomSheetSelectedUIType? bottomSheetSelectedUIType,
    int? selectedCategoryId,
    int? selectedSubCategoryId,
    List<Listing>? distinctCategoryList,
  }) {
    return LocationScreenState(
        allEventList ?? this.allEventList,
        isLoading ?? this.isLoading,
        bottomSheetSelectedUIType ?? this.bottomSheetSelectedUIType,
        selectedCategoryId ?? this.selectedCategoryId,
        selectedSubCategoryId ?? this.selectedSubCategoryId,
        distinctCategoryList ?? this.distinctCategoryList);
  }
}

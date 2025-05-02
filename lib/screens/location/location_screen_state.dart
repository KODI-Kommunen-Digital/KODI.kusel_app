import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'bottom_sheet_selected_ui_type.dart';

class LocationScreenState {
  List<Listing> allEventList;

  BottomSheetSelectedUIType bottomSheetSelectedUIType;
  int? selectedCategoryId;
  String? selectedCategoryName;
  int? selectedSubCategoryId;
  List<Listing> distinctFilterCategoryList;
  Listing? selectedEvent;
  PanelController panelController;
  bool isSelectedFilterScreenLoading;

  LocationScreenState(
      this.allEventList,
      this.bottomSheetSelectedUIType,
      this.selectedCategoryId,
      this.selectedCategoryName,
      this.selectedSubCategoryId,
      this.distinctFilterCategoryList,
      this.selectedEvent,
      this.panelController,
      this.isSelectedFilterScreenLoading);

  factory LocationScreenState.empty() {
    return LocationScreenState([],  BottomSheetSelectedUIType.allEvent,
        null, null, null, [], null, PanelController(), false);
  }

  LocationScreenState copyWith(
      {List<Listing>? allEventList,
      BottomSheetSelectedUIType? bottomSheetSelectedUIType,
      int? selectedCategoryId,
      String? selectedCategoryName,
      int? selectedSubCategoryId,
      Listing? selectedEvent,
      List<Listing>? distinctFilterCategoryList,
      double? minHeight,
      double? maxHeight,
      double? openPosition,
      PanelController? panelController,
      bool? isSelectedFilterScreenLoading}) {
    return LocationScreenState(
        allEventList ?? this.allEventList,
        bottomSheetSelectedUIType ?? this.bottomSheetSelectedUIType,
        selectedCategoryId ?? this.selectedCategoryId,
        selectedCategoryName ?? this.selectedCategoryName,
        selectedSubCategoryId ?? this.selectedSubCategoryId,
        distinctFilterCategoryList ?? this.distinctFilterCategoryList,
        selectedEvent ?? this.selectedEvent,
        panelController ?? this.panelController,
        isSelectedFilterScreenLoading ?? this.isSelectedFilterScreenLoading);
  }
}

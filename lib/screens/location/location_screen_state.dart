import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'bottom_sheet_selected_ui_type.dart';

class LocationScreenState {
  List<Listing> allEventList;
  List<Listing> allEventCategoryWiseList;
  BottomSheetSelectedUIType bottomSheetSelectedUIType;
  int? selectedCategoryId;
  String? selectedCategoryName;
  int? selectedSubCategoryId;
  List<Listing> distinctFilterCategoryList;
  Listing? selectedEvent;
  PanelController panelController;
  bool isSelectedFilterScreenLoading;
  bool isUserLoggedIn;
  bool isSlidingUpPanelDragAllowed;
  int currentPageNo;
  bool isMoreListLoading;

  LocationScreenState(
      this.allEventList,
      this.allEventCategoryWiseList,
      this.bottomSheetSelectedUIType,
      this.selectedCategoryId,
      this.selectedCategoryName,
      this.selectedSubCategoryId,
      this.distinctFilterCategoryList,
      this.selectedEvent,
      this.panelController,
      this.isSelectedFilterScreenLoading,
      this.isUserLoggedIn,
      this.isSlidingUpPanelDragAllowed,
      this.currentPageNo,
      this.isMoreListLoading);

  factory LocationScreenState.empty() {
    return LocationScreenState([], [], BottomSheetSelectedUIType.allEvent, null,
        null, null, [], null, PanelController(), false, false, true, 1, false);
  }

  LocationScreenState copyWith(
      {List<Listing>? allEventList,
      List<Listing>? allEventCategoryWiseList,
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
      bool? isSelectedFilterScreenLoading,
      bool? isUserLoggedIn,
      bool? isSlidingUpPanelDragAllowed,
      int? currentPageNo,
      bool? isMoreListLoading}) {
    return LocationScreenState(
        allEventList ?? this.allEventList,
        allEventCategoryWiseList ?? this.allEventCategoryWiseList,
        bottomSheetSelectedUIType ?? this.bottomSheetSelectedUIType,
        selectedCategoryId ?? this.selectedCategoryId,
        selectedCategoryName ?? this.selectedCategoryName,
        selectedSubCategoryId ?? this.selectedSubCategoryId,
        distinctFilterCategoryList ?? this.distinctFilterCategoryList,
        selectedEvent ?? this.selectedEvent,
        panelController ?? this.panelController,
        isSelectedFilterScreenLoading ?? this.isSelectedFilterScreenLoading,
        isUserLoggedIn ?? this.isUserLoggedIn,
        isSlidingUpPanelDragAllowed ?? this.isSlidingUpPanelDragAllowed,
        currentPageNo ?? this.currentPageNo,
        isMoreListLoading ?? this.isMoreListLoading);
  }
}

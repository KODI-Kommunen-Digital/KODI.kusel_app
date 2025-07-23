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
  Listing? selectedEvent;
  PanelController panelController;
  bool isSelectedFilterScreenLoading;
  bool isUserLoggedIn;
  bool isSlidingUpPanelDragAllowed;
  int currentPageNo;
  bool isMoreListLoading;
  bool isLoadMoreButtonEnabled;

  LocationScreenState(
      this.allEventList,
      this.allEventCategoryWiseList,
      this.bottomSheetSelectedUIType,
      this.selectedCategoryId,
      this.selectedCategoryName,
      this.selectedSubCategoryId,
      this.selectedEvent,
      this.panelController,
      this.isSelectedFilterScreenLoading,
      this.isUserLoggedIn,
      this.isSlidingUpPanelDragAllowed,
      this.currentPageNo,
      this.isMoreListLoading,
      this.isLoadMoreButtonEnabled);

  factory LocationScreenState.empty() {
    return LocationScreenState([], [],
        BottomSheetSelectedUIType.allEvent,
        null,
        null,
        null,
        null,
        PanelController(),
        false,
        false,
        true,
        1,
        false,
        true);
  }

  LocationScreenState copyWith(
      {List<Listing>? allEventList,
      List<Listing>? allEventCategoryWiseList,
      BottomSheetSelectedUIType? bottomSheetSelectedUIType,
      int? selectedCategoryId,
      String? selectedCategoryName,
      int? selectedSubCategoryId,
      Listing? selectedEvent,
      double? minHeight,
      double? maxHeight,
      double? openPosition,
      PanelController? panelController,
      bool? isSelectedFilterScreenLoading,
      bool? isUserLoggedIn,
      bool? isSlidingUpPanelDragAllowed,
      int? currentPageNo,
      bool? isMoreListLoading,
      bool? isLoadMoreButtonEnabled}) {
    return LocationScreenState(
        allEventList ?? this.allEventList,
        allEventCategoryWiseList ?? this.allEventCategoryWiseList,
        bottomSheetSelectedUIType ?? this.bottomSheetSelectedUIType,
        selectedCategoryId ?? this.selectedCategoryId,
        selectedCategoryName ?? this.selectedCategoryName,
        selectedSubCategoryId ?? this.selectedSubCategoryId,
        selectedEvent ?? this.selectedEvent,
        panelController ?? this.panelController,
        isSelectedFilterScreenLoading ?? this.isSelectedFilterScreenLoading,
        isUserLoggedIn ?? this.isUserLoggedIn,
        isSlidingUpPanelDragAllowed ?? this.isSlidingUpPanelDragAllowed,
        currentPageNo ?? this.currentPageNo,
        isMoreListLoading ?? this.isMoreListLoading,
        isLoadMoreButtonEnabled ?? this.isLoadMoreButtonEnabled);
  }
}

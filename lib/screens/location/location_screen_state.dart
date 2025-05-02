import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:kusel/screens/location/bottom_sheet_screens/selected_event_screen.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'bottom_sheet_selected_ui_type.dart';

class LocationScreenState {
  List<Listing> allEventList;
  bool isLoading;
  BottomSheetSelectedUIType bottomSheetSelectedUIType;
  int? selectedCategoryId;
  String? selectedCategoryName;
  int? selectedSubCategoryId;
  List<Listing> distinctFilterCategoryList;
  Listing? selectedEvent;
  PanelController panelController;


  LocationScreenState(
    this.allEventList,
    this.isLoading,
    this.bottomSheetSelectedUIType,
    this.selectedCategoryId,
    this.selectedCategoryName,
    this.selectedSubCategoryId,
    this.distinctFilterCategoryList,
    this.selectedEvent,
    this.panelController,
  );

  factory LocationScreenState.empty() {
    return LocationScreenState([], false, BottomSheetSelectedUIType.allEvent,
        null, null, null, [], null, PanelController());
  }

  LocationScreenState copyWith(
      {List<Listing>? allEventList,
      bool? isLoading,
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
      }) {
    return LocationScreenState(
        allEventList ?? this.allEventList,
        isLoading ?? this.isLoading,
        bottomSheetSelectedUIType ?? this.bottomSheetSelectedUIType,
        selectedCategoryId ?? this.selectedCategoryId,
        selectedCategoryName ?? this.selectedCategoryName,
        selectedSubCategoryId ?? this.selectedSubCategoryId,
        distinctFilterCategoryList ?? this.distinctFilterCategoryList,
        selectedEvent ?? this.selectedEvent,
        panelController ?? this.panelController,
    );
  }
}

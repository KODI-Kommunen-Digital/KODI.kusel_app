import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:domain/model/request_model/listings/get_all_listings_request_model.dart';
import 'package:domain/model/request_model/listings/search_request_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/model/response_model/listings_model/search_listings_response_model.dart';
import 'package:domain/usecase/listings/listings_usecase.dart';
import 'package:domain/usecase/search/search_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:kusel/screens/location/bottom_sheet_selected_ui_type.dart';

import 'location_screen_state.dart';

final locationScreenProvider = StateNotifierProvider.autoDispose<
        LocationScreenProvider, LocationScreenState>(
    (ref) => LocationScreenProvider(
          listingsUseCase: ref.read(listingsUseCaseProvider),
          searchUseCase: ref.read(searchUseCaseProvider),
          signInStatusController: ref.read(signInStatusProvider.notifier),
          localeManagerController: ref.read(localeManagerProvider.notifier),
        ));

class LocationScreenProvider extends StateNotifier<LocationScreenState> {
  ListingsUseCase listingsUseCase;
  SearchUseCase searchUseCase;
  SignInStatusController signInStatusController;
  LocaleManagerController localeManagerController;

  LocationScreenProvider(
      {required this.listingsUseCase,
      required this.searchUseCase,
      required this.signInStatusController,
      required this.localeManagerController})
      : super(LocationScreenState.empty());

  Future<void> getAllEventList() async {
    try {

      Locale currentLocale = localeManagerController.getSelectedLocale();

      GetAllListingsRequestModel requestModel = GetAllListingsRequestModel(
          translate: "${currentLocale.languageCode}-${currentLocale.countryCode}"
      );
      GetAllListingsResponseModel responseModel = GetAllListingsResponseModel();

      state = state.copyWith(allEventList: []);
      final result = await listingsUseCase.call(requestModel, responseModel);

      result.fold((l) {
        debugPrint("Get all event list fold exception = $l");
      }, (r) {
        final response = r as GetAllListingsResponseModel;

        if (response.data != null) {
          List<int> categoryIdList = [];
          List<Listing> filterCategoryList = [];

          for (Listing listing in response.data!) {
            final categoryId = listing.categoryId;
            if (categoryId != null && !categoryIdList.contains(categoryId)) {
              filterCategoryList.add(listing);
              categoryIdList.add(categoryId);
            }
          }

          state = state.copyWith(
              allEventList: response.data,
              distinctFilterCategoryList: filterCategoryList);
        }
      });
    } catch (error) {
      debugPrint("Get all event list  exception = $error");
    }
  }

  Future<void> getAllEventListUsingCategoryId(String categoryId) async {
    try {
      state =
          state.copyWith(isSelectedFilterScreenLoading: true, allEventList: []);

      Locale currentLocale = localeManagerController.getSelectedLocale();

      GetAllListingsRequestModel requestModel =
          GetAllListingsRequestModel(categoryId: categoryId,
              translate: "${currentLocale.languageCode}-${currentLocale.countryCode}");
      GetAllListingsResponseModel responseModel = GetAllListingsResponseModel();

      final result = await listingsUseCase.call(requestModel, responseModel);

      result.fold((l) {
        state = state.copyWith(isSelectedFilterScreenLoading: false);
        debugPrint("Get all event list fold exception = $l");
      }, (r) {
        final response = r as GetAllListingsResponseModel;
        state = state.copyWith(
            isSelectedFilterScreenLoading: false, allEventList: response.data);
      });
    } catch (error) {
      state = state.copyWith(isSelectedFilterScreenLoading: false);
      debugPrint("Get all event list  exception = $error");
    }
  }

  updateBottomSheetSelectedUIType(BottomSheetSelectedUIType type) {
    state = state.copyWith(bottomSheetSelectedUIType: type);
    setSliderHeight(type);
  }

  updateSelectedCategory(int? selectedCategory, String? categoryName) {
    state = state.copyWith(
        selectedCategoryId: selectedCategory,
        selectedCategoryName: categoryName);
  }

  void setIsFavorite(bool isFavorite, int? id) {
    for (var listing in state.allEventList) {
      if (listing.id == id) {
        listing.isFavorite = isFavorite;
      }
    }
    state = state.copyWith(allEventList: state.allEventList);
  }

  void setEventItem(Listing event) {
    List<Listing> list = [];
    for (var item in state.allEventList) {
      if (item.id == event.id) list.add(item);
    }

    state = state.copyWith(selectedEvent: event, allEventList: list);
  }

  Future<List<Listing>> searchList({
    required String searchText,
    required void Function() success,
    required void Function(String message) error,
  }) async {
    try {
      Locale currentLocale = localeManagerController.getSelectedLocale();
      SearchRequestModel searchRequestModel = SearchRequestModel(
          searchQuery: searchText,
          translate:
              "${currentLocale.languageCode}-${currentLocale.countryCode}");
      SearchListingsResponseModel searchListingsResponseModel =
          SearchListingsResponseModel();

      final result = await searchUseCase.call(
          searchRequestModel, searchListingsResponseModel);
      return result.fold(
        (l) {
          debugPrint('Exception = $l');
          error(l.toString());
          return <Listing>[];
        },
        (r) {
          final listings = (r as SearchListingsResponseModel).data;
          debugPrint('>>>> returned = ${listings?.length}');
          success();
          return listings ?? <Listing>[];
        },
      );
    } catch (e) {
      debugPrint('>>>> Exception = $e');
      error(e.toString());
      return <Listing>[];
    }
  }

  void setHeight(double desiredHeight) {
    final maxHeight = 550.h;
    final position = desiredHeight.h / maxHeight;

    state.panelController.animatePanelToPosition(
      position,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void setSliderHeight(BottomSheetSelectedUIType type) {
    if (type == BottomSheetSelectedUIType.allEvent) {
      setHeight(100.h);
    } else if (type == BottomSheetSelectedUIType.eventList) {
      setHeight(500);
    } else {
      setHeight(400);
    }
  }

  updateCategoryId(int? categoryId, String? categoryName) {
    if (categoryId != null && categoryName != null) {
      state = state.copyWith(
          selectedCategoryId: categoryId, selectedCategoryName: categoryName);
    }
  }

  isUserLoggedIn() async {
    final status = await signInStatusController.isUserLoggedIn();

    state = state.copyWith(isUserLoggedIn: status);
  }

  updateIsFav(bool isFav, int? eventId) {
    final list = state.allEventList;
    for (var listing in list) {
      if (listing.id == eventId) {
        listing.isFavorite = isFav;
      }
    }
    state = state.copyWith(allEventList: list);
  }

  List<Listing> sortSuggestionList(String search, List<Listing> list) {
    search = search.toLowerCase();
    list.sort((a, b) {
      final aTitle = a.title?.toLowerCase() ?? '';
      final bTitle = b.title?.toLowerCase() ?? '';

      final aScore =
          aTitle.startsWith(search) ? 0 : (aTitle.contains(search) ? 1 : 2);
      final bScore =
          bTitle.startsWith(search) ? 0 : (bTitle.contains(search) ? 1 : 2);

      if (aScore != bScore) return aScore.compareTo(bScore);
      return aTitle.compareTo(bTitle);
    });

    return list;
  }

  updateSlidingUpPanelIsDragStatus(bool value)
  {
    state = state.copyWith(isSlidingUpPanelDragAllowed: value);
  }
}

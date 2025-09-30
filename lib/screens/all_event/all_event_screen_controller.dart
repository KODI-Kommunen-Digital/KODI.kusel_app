import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:domain/model/request_model/listings/get_all_listings_request_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/usecase/listings/listings_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/locale/localization_manager.dart';

import 'all_event_screen_state.dart';

final allEventScreenProvider = StateNotifierProvider.autoDispose<
        AllEventScreenController, AllEventScreenState>(
    (ref) => AllEventScreenController(
        listingsUseCase: ref.read(listingsUseCaseProvider),
        signInStatusController: ref.read(signInStatusProvider.notifier),
        localeManagerController: ref.read(localeManagerProvider.notifier)));

class AllEventScreenController extends StateNotifier<AllEventScreenState> {
  ListingsUseCase listingsUseCase;
  SignInStatusController signInStatusController;
  LocaleManagerController localeManagerController;

  AllEventScreenController(
      {required this.listingsUseCase,
      required this.signInStatusController,
      required this.localeManagerController})
      : super(AllEventScreenState.empty());

  Future<void> getEventsList(int pageNumber) async {
    try {
      if(pageNumber>1){
        state = state.copyWith(isMoreListLoading: true);
      } else {
        state = state.copyWith(isLoading: true);
      }
      Locale currentLocale = localeManagerController.getSelectedLocale();

      GetAllListingsRequestModel getAllListingsRequestModel =
          GetAllListingsRequestModel(
             categoryId: "3",
              sortByStartDate: true,
              translate:
                  "${currentLocale.languageCode}-${currentLocale.countryCode}",
              pageNo: pageNumber);
      GetAllListingsResponseModel getAllListResponseModel =
          GetAllListingsResponseModel();

      final result = await listingsUseCase.call(
          getAllListingsRequestModel, getAllListResponseModel);
      result.fold(
        (l) {
          debugPrint("get all event fold exception : $l");
          state = state.copyWith(isLoading: false);
        },
        (r) {
          var eventsList = (r as GetAllListingsResponseModel).data;
          bool isLoadMoreButtonEnabled;
          List<Listing> existingEventList = state.listingList;
          if(eventsList!=null && eventsList.isNotEmpty){
            existingEventList.addAll(eventsList);
            isLoadMoreButtonEnabled = true;
          } else {
            pageNumber--;
            isLoadMoreButtonEnabled = false;
          }

          state = state.copyWith(
              listingList: existingEventList,
              isLoading: false,
              isMoreListLoading: false,
              currentPageNo: pageNumber,
              isLoadMoreButtonEnabled: isLoadMoreButtonEnabled);
        },
      );
    } catch (error) {
      debugPrint("get all event  exception : $error");
      state = state.copyWith(isLoading: false);
    }
  }

  void setIsFavorite(bool isFavorite, int? id) {
    for (var listing in state.listingList) {
      if (listing.id == id) {
        listing.isFavorite = isFavorite;
        break;
      }
    }
    state = state.copyWith(listingList: state.listingList);
  }

  Future<void> applyFilter(
      {String? startAfterDate,
      String? endBeforeDate,
      int? cityId,
      int? pageNumber,
      int? categoryId,
      int? filterCount}) async {
    try {
      state = state.copyWith(isLoading: true);

      Locale currentLocale = localeManagerController.getSelectedLocale();
      GetAllListingsRequestModel getAllListingsRequestModel =
          GetAllListingsRequestModel(
              sortByStartDate: true,
              translate: "${currentLocale.languageCode}-${currentLocale.countryCode}"
          );
      if (startAfterDate != null) {
        getAllListingsRequestModel.startAfterDate = startAfterDate;
      }
      if (endBeforeDate != null) {
        getAllListingsRequestModel.endBeforeDate = endBeforeDate;
      }
      if (cityId != null) getAllListingsRequestModel.cityId = cityId.toString();
      if (pageNumber != null) getAllListingsRequestModel.pageNo = pageNumber;
      if (categoryId != null) {
        getAllListingsRequestModel.categoryId = categoryId.toString();
      }
      GetAllListingsResponseModel getAllListResponseModel =
          GetAllListingsResponseModel();

      final result = await listingsUseCase.call(
          getAllListingsRequestModel, getAllListResponseModel);
      result.fold(
        (l) {
          debugPrint("get filter event fold exception : $l");
          state = state.copyWith(isLoading: false);
        },
        (r) {
          var eventsList = (r as GetAllListingsResponseModel).data;
          state = state.copyWith(
              listingList: eventsList,
              isLoading: false,
              filterCount: filterCount);
        },
      );
    } catch (error) {
      debugPrint("get filter event  exception : $error");
      state = state.copyWith(isLoading: false);
    }
  }

  void onResetFilter() {
    state = state.copyWith(filterCount: null);
  }

  isUserLoggedIn() async {
    final status = await signInStatusController.isUserLoggedIn();
    state = state.copyWith(isUserLoggedIn: status);
  }

  updateIsFav(bool isFav, int? eventId) {
    final list = state.listingList;
    for (var listing in list) {
      if (listing.id == eventId) {
        listing.isFavorite = isFav;
      }
    }
    state = state.copyWith(listingList: list);
  }
  void onLoadMoreList(int currPageNo) async {
    int currPageNo = state.currentPageNo;
    currPageNo = currPageNo+1;
    await getEventsList(currPageNo);
  }
}

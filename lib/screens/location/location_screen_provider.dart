import 'package:domain/model/request_model/listings/get_all_listings_request_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/usecase/listings/listings_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/location/bottom_sheet_selected_ui_type.dart';

import 'location_screen_state.dart';

final locationScreenProvider = StateNotifierProvider.autoDispose<
        LocationScreenProvider, LocationScreenState>(
    (ref) => LocationScreenProvider(
        listingsUseCase: ref.read(listingsUseCaseProvider)));

class LocationScreenProvider extends StateNotifier<LocationScreenState> {
  ListingsUseCase listingsUseCase;

  LocationScreenProvider({required this.listingsUseCase})
      : super(LocationScreenState.empty());

  Future<void> getAllEventList() async {
    try {
      state = state.copyWith(isLoading: true);
      GetAllListingsRequestModel requestModel = GetAllListingsRequestModel();
      GetAllListingsResponseModel responseModel = GetAllListingsResponseModel();

      final result = await listingsUseCase.call(requestModel, responseModel);

      result.fold((l) {
        state = state.copyWith(isLoading: false);
        debugPrint("Get all event list fold exception = $l");
      }, (r) {
        final response = r as GetAllListingsResponseModel;

        if (response.data != null) {

          state = state.copyWith(allEventList: response.data);
        }

        state = state.copyWith(isLoading: false);
      });
    } catch (error) {
      state = state.copyWith(isLoading: false);
      debugPrint("Get all event list  exception = $error");
    }
  }


  Future<void> getAllEventListUsingCategoryId(String categoryId) async {
    try {
      state = state.copyWith(isLoading: true);
      GetAllListingsRequestModel requestModel = GetAllListingsRequestModel(
        categoryId: categoryId
      );
      GetAllListingsResponseModel responseModel = GetAllListingsResponseModel();

      final result = await listingsUseCase.call(requestModel, responseModel);

      result.fold((l) {
        state = state.copyWith(isLoading: false);
        debugPrint("Get all event list fold exception = $l");
      }, (r) {
        final response = r as GetAllListingsResponseModel;


        state = state.copyWith(isLoading: false);
      });
    } catch (error) {
      state = state.copyWith(isLoading: false);
      debugPrint("Get all event list  exception = $error");
    }
  }

  updateBottomSheetSelectedUIType(BottomSheetSelectedUIType type) {
    state = state.copyWith(bottomSheetSelectedUIType: type);
  }

  updateSelectedCategory(int? selectedCategory)
  {
    state = state.copyWith(selectedCategoryId: selectedCategory);
  }
}

import 'package:domain/model/request_model/city_details/get_city_details_request_model.dart';
import 'package:domain/model/request_model/filter/get_filter_request_model.dart';
import 'package:domain/model/response_model/city_details/get_city_details_response_model.dart';
import 'package:domain/model/response_model/explore_details/explore_details_response_model.dart';
import 'package:domain/model/response_model/filter/get_filter_response_model.dart';
import 'package:domain/usecase/city_details/get_city_details_usecase.dart';
import 'package:domain/usecase/filter/get_filter_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/new_filter_screen/new_filter_screen_state.dart';

final newFilterScreenControllerProvider = StateNotifierProvider.autoDispose<
        NewFilterScreenController, NewFilterScreenState>(
    (ref) => NewFilterScreenController(
        getFilterUseCase: ref.read(getFilterUseCaseProvider)));

class NewFilterScreenController extends StateNotifier<NewFilterScreenState> {
  GetFilterUseCase getFilterUseCase;

  NewFilterScreenController({required this.getFilterUseCase})
      : super(NewFilterScreenState.empty());

  updateSelectedCity(int cityId, String cityName) {
    if (cityId == state.selectedCityId) {
      state = state.copyWith(
          selectedCityId: 0, sliderValue: 0, selectedCityName: "");
    } else {
      state = state.copyWith(
          selectedCityId: cityId,
          sliderValue: state.sliderValue,
          selectedCityName: cityName);
    }
  }

  updateLocationAndDistanceAllValue() {
    state =
        state.copyWith(selectedCityId: 0, sliderValue: 0, selectedCityName: "");
  }

  updateSliderValue(double value) {
    state = state.copyWith(sliderValue: value);
  }

  updateSelectedCategoryList(FilterItem filterItem) {
    final nameList = state.selectedCategoryName;
    final idList = state.selectedCategoryId;

    if (nameList.contains(filterItem.name)) {
      nameList.remove(filterItem.name);
      idList.remove(filterItem.id);
    } else {
      nameList.add(filterItem.name!);
      idList.add(filterItem.id!);
    }

    state = state.copyWith(
        selectedCategoryName: nameList, selectedCategoryId: idList);
  }

  updateCategoryAllValue() {
    state = state.copyWith(selectedCategoryName: [], selectedCategoryId: []);
  }

  updateStartEndDate(DateTime startDate, DateTime endDate) {
    state = state.copyWith(startDate: startDate, endDate: endDate);
  }

  fetchFilterList(
      {required List<String> categoryNameList,
      required List<int> categoryIdList,
      required String selectedCityName,
      required int selectedCityId,
      required double radius,
      required DateTime endDate,
      required DateTime startDate}) async {
    try {
      state = state.copyWith(isLoading: true);
      GetFilterRequestModel requestModel = GetFilterRequestModel();

      GetFilterResponseModel responseModel = GetFilterResponseModel();

      final response = await getFilterUseCase.call(requestModel, responseModel);

      response.fold((l) {
        debugPrint('fetch filter list exception: $l');
        state = state.copyWith(isLoading: false);
      }, (r) {
        final res = r as GetFilterResponseModel;

        if (res.data != null) {
          state = state.copyWith(
              cityList: res.data?.cities?.data,
              categoryList: res.data?.categories?.data,
              selectedCityId: selectedCityId,
              selectedCityName: selectedCityName,
              sliderValue: radius,
              selectedCategoryId: categoryIdList,
              selectedCategoryName: categoryNameList,
              startDate: startDate,
              endDate: endDate);
        }

        state = state.copyWith(isLoading: false);
      });
    } catch (error) {
      debugPrint('fetch filter list exception: $error');
      state = state.copyWith(isLoading: false);
    }
  }
}

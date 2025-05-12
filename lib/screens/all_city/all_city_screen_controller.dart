import 'package:domain/model/request_model/city_details/get_city_details_request_model.dart';
import 'package:domain/model/response_model/city_details/get_city_details_response_model.dart';
import 'package:domain/usecase/city_details/get_city_details_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/all_city/all_city_screen_state.dart';

final allCityScreenProvider = StateNotifierProvider.autoDispose<
        AllCityScreenController, AllCityScreenState>(
    (ref) => AllCityScreenController(
        getCityDetailsUseCase: ref.read(getCityDetailsUseCaseProvider)));

class AllCityScreenController extends StateNotifier<AllCityScreenState> {
  GetCityDetailsUseCase getCityDetailsUseCase;

  AllCityScreenController({required this.getCityDetailsUseCase})
      : super(AllCityScreenState.empty());

  Future<void> fetchCities() async {
    try {
      state = state.copyWith(
        isLoading: true,
      );
      GetCityDetailsRequestModel requestModel =
      GetCityDetailsRequestModel(hasForum: false);
      GetCityDetailsResponseModel responseModel = GetCityDetailsResponseModel();
      final result =
      await getCityDetailsUseCase.call(requestModel, responseModel);

      result.fold((l) {
        debugPrint('get city details fold exception : $l');
      }, (r) async {
        final response = r as GetCityDetailsResponseModel;

        // final cityDetailsMap = <int, String>{};
        //
        // if (response.data != null) {
        //   for (var city in response.data!) {
        //     if (city.id != null && city.name != null) {
        //       cityDetailsMap[city.id!] = city.name!;
        //     }
        //   }
        // }
        state = state.copyWith(
          cityList: response.data,
          isLoading: false
        );
      });
    } catch (error) {
      debugPrint('get city details exception : $error');
    }
  }
}

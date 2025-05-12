import 'package:domain/model/request_model/city_details/get_city_details_request_model.dart';
import 'package:domain/model/request_model/listings/get_all_listings_request_model.dart';
import 'package:domain/model/request_model/municipal_party_detail/municipal_party_detail_request_model.dart';
import 'package:domain/model/response_model/city_details/get_city_details_response_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/model/response_model/municipal_party_detail/municipal_party_detail_response_model.dart';
import 'package:domain/usecase/city_details/get_city_details_usecase.dart';
import 'package:domain/usecase/listings/listings_usecase.dart';
import 'package:domain/usecase/municipal_party_detail/municipal_party_detail_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'municipal_detail_state.dart';

final municipalDetailControllerProvider = StateNotifierProvider.autoDispose<
        MunicipalDetailController, MunicipalDetailState>(
    (ref) => MunicipalDetailController(
        listingsUseCase: ref.read(listingsUseCaseProvider),
        municipalPartyDetailUseCase:
            ref.read(municipalPartyDetailUseCaseProvider),
      getCityDetailsUseCase: ref.read(getCityDetailsUseCaseProvider)
    ));

class MunicipalDetailController extends StateNotifier<MunicipalDetailState> {
  ListingsUseCase listingsUseCase;
  MunicipalPartyDetailUseCase municipalPartyDetailUseCase;
  GetCityDetailsUseCase getCityDetailsUseCase;

  MunicipalDetailController(
      {required this.listingsUseCase,
      required this.municipalPartyDetailUseCase,
      required this.getCityDetailsUseCase})
      : super(MunicipalDetailState.empty());

  getEventsUsingCityId({required String municipalId}) async {
    try {
      state = state.copyWith(showEventLoading: true);
      final id = "1" ?? municipalId;
      GetAllListingsRequestModel requestModel =
          GetAllListingsRequestModel(cityId: id, categoryId: '3');

      GetAllListingsResponseModel responseModel = GetAllListingsResponseModel();

      final response = await listingsUseCase.call(requestModel, responseModel);

      response.fold((l) {
        state = state.copyWith(showEventLoading: false);
        debugPrint("getEventsUsingCityId fold exception = ${l.toString()}");
      }, (r) {
        final result = r as GetAllListingsResponseModel;

        state = state.copyWith(eventList: result.data, showEventLoading: false);
      });
    } catch (e) {
      state = state.copyWith(showEventLoading: false);
      debugPrint("getEventsUsingCityId exception = $e");
    }
  }

  getNewsUsingCityId({required String municipalId}) async {
    try {
      state = state.copyWith(showNewsLoading: true);
      final id = "1" ?? municipalId;
      final categoryId = "1";
      GetAllListingsRequestModel requestModel =
          GetAllListingsRequestModel(cityId: id);

      GetAllListingsResponseModel responseModel = GetAllListingsResponseModel();

      final response = await listingsUseCase.call(requestModel, responseModel);

      response.fold((l) {
        state = state.copyWith(showNewsLoading: false);
        debugPrint("getNewsUsingCityId fold exception = ${l.toString()}");
      }, (r) {
        final result = r as GetAllListingsResponseModel;

        state = state.copyWith(newsList: result.data, showNewsLoading: false);
      });
    } catch (e) {
      state = state.copyWith(showNewsLoading: false);
      debugPrint("getNewsUsingCityId exception = $e");
    }
  }

  getMunicipalPartyDetailUsingId({required String id}) async {
    try {
      state = state.copyWith(isLoading: true);
      MunicipalPartyDetailRequestModel requestModel =
          MunicipalPartyDetailRequestModel(municipalId: id);
      MunicipalPartyDetailResponseModel responseModel =
          MunicipalPartyDetailResponseModel();

      final response =
          await municipalPartyDetailUseCase.call(requestModel, responseModel);

      response.fold((l) {
        state = state.copyWith(isLoading: false);
        debugPrint(
            "getMunicipalPartyDetailUsingId exception = ${l.toString()}");
      }, (r) {
        final result = r as MunicipalPartyDetailResponseModel;

        state = state.copyWith(
            isLoading: false, municipalPartyDetailDataModel: result.data);
      });
    } catch (e) {
      state = state.copyWith(isLoading: false);
      debugPrint("getMunicipalPartyDetailUsingId exception = $e");
    }
  }

  Future<void> fetchCities() async {
    try {
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
        );
      });
    } catch (error) {
      debugPrint('get city details exception : $error');
    }
  }
}

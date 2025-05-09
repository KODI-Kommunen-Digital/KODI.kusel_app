import 'package:domain/model/request_model/listings/get_all_listings_request_model.dart';
import 'package:domain/model/request_model/municipal_party_detail/municipal_party_detail_request_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/model/response_model/municipal_party_detail/municipal_party_detail_response_model.dart';
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
            ref.read(municipalPartyDetailUseCaseProvider)));

class MunicipalDetailController extends StateNotifier<MunicipalDetailState> {
  ListingsUseCase listingsUseCase;
  MunicipalPartyDetailUseCase municipalPartyDetailUseCase;

  MunicipalDetailController(
      {required this.listingsUseCase,
      required this.municipalPartyDetailUseCase})
      : super(MunicipalDetailState.empty());

  getEventsUsingCityId({required String municipalId}) async {
    try {
      state = state.copyWith(showEventLoading: true);
      GetAllListingsRequestModel requestModel =
          GetAllListingsRequestModel(cityId: municipalId, categoryId: '3');

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
      GetAllListingsRequestModel requestModel =
          GetAllListingsRequestModel(cityId: municipalId, categoryId: "1");

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
}

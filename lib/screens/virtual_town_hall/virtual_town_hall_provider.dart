import 'package:domain/model/empty_request.dart';
import 'package:domain/model/request_model/listings/get_all_listings_request_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/model/response_model/virtual_town_hall/virtual_town_hall_response_model.dart';
import 'package:domain/usecase/listings/listings_usecase.dart';
import 'package:domain/usecase/virtual_town_hall/virtual_town_hall_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/virtual_town_hall/virtual_town_hall_state.dart';

final virtualTownHallProvider =
    StateNotifierProvider<VirtualTownHallProvider, VirtualTownHallState>(
        (ref) => VirtualTownHallProvider(
            listingsUseCase: ref.read(listingsUseCaseProvider),
            virtualTownHallUseCase: ref.read(virtualTownHallUseCaseProvider)));

class VirtualTownHallProvider extends StateNotifier<VirtualTownHallState> {
  ListingsUseCase listingsUseCase;
  VirtualTownHallUseCase virtualTownHallUseCase;

  VirtualTownHallProvider(
      {required this.listingsUseCase, required this.virtualTownHallUseCase})
      : super(VirtualTownHallState.empty());

  updateCardIndex(int index) {
    state = state.copyWith(highlightCount: index);
  }

  Future<void> getEventsUsingCityId({required String cityId}) async {
    try {
      GetAllListingsRequestModel requestModel =
          GetAllListingsRequestModel(categoryId: '3');

      GetAllListingsResponseModel responseModel = GetAllListingsResponseModel();

      final response = await listingsUseCase.call(requestModel, responseModel);

      response.fold((l) {
        debugPrint("getEventsUsingCityId fold exception = ${l.toString()}");
      }, (r) {
        final result = r as GetAllListingsResponseModel;

        state = state.copyWith(eventList: result.data);
      });
    } catch (e) {
      debugPrint("getEventsUsingCityId exception = $e");
    }
  }

  Future<void> getNewsUsingCityId({required String cityId}) async {
    try {
      GetAllListingsRequestModel requestModel =
          GetAllListingsRequestModel(cityId: cityId, categoryId: "1");

      GetAllListingsResponseModel responseModel = GetAllListingsResponseModel();

      final response = await listingsUseCase.call(requestModel, responseModel);

      response.fold((l) {
        debugPrint("getEventsUsingCityId fold exception = ${l.toString()}");
      }, (r) {
        final result = r as GetAllListingsResponseModel;

        state = state.copyWith(newsList: result.data);
      });
    } catch (e) {
      debugPrint("getEventsUsingCityId exception = $e");
    }
  }

  Future<void> getVirtualTownHallDetails() async {
    try {
      state = state.copyWith(loading: true);

      EmptyRequest requestModel = EmptyRequest();

      VirtualTownHallResponseModel responseModel =
          VirtualTownHallResponseModel();

      final response = await virtualTownHallUseCase.call(requestModel, responseModel);

      response.fold((l) {
        debugPrint("getEventsUsingCityId fold exception = ${l.toString()}");
      }, (r) {
        final result = r as VirtualTownHallResponseModel;
        if(result.data!=null){
          state = state.copyWith(
            cityName : result.data?.name,
            cityId : result.data?.id.toString(),
            imageUrl : result.data?.image,
            description : result.data?.description ,
            address : result.data?.address,
            latitude : double.parse(result.data?.latitude ?? ''),
            longitude : double.parse(result.data?.longitude ?? ''),
            phoneNumber : result.data?.phone,
            email : result.data?.email,
            openUntil : result.data?.openUntil,
            websiteUrl: result.data?.websiteUrl,
            onlineServiceList : result.data?.onlineServices,
            municipalitiesList : result.data?.municipalities,
            loading : false,
          );
          getEventsUsingCityId(cityId: state.cityId ?? '1');
          getNewsUsingCityId(cityId: state.cityId ?? '1');
        }
      });
    } catch (e) {
      debugPrint("getEventsUsingCityId exception = $e");
    }
  }
}

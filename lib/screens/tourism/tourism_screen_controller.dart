import 'package:domain/model/request_model/listings/get_all_listings_request_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/usecase/listings/listings_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/common_widgets/get_current_location.dart';
import 'package:kusel/screens/tourism/tourism_screen_state.dart';

final tourismScreenControllerProvider = StateNotifierProvider.autoDispose<
        TourismScreenController, TourismScreenState>(
    (ref) => TourismScreenController(
        listingsUseCase: ref.read(listingsUseCaseProvider)));

class TourismScreenController extends StateNotifier<TourismScreenState> {
  ListingsUseCase listingsUseCase;

  TourismScreenController({required this.listingsUseCase})
      : super(TourismScreenState.empty());

  getAllEvents() async {
    try {
      final categoryId = "3";

      GetAllListingsResponseModel responseModel = GetAllListingsResponseModel();
      GetAllListingsRequestModel requestModel =
          GetAllListingsRequestModel(categoryId: categoryId);

      final response = await listingsUseCase.call(requestModel, responseModel);

      response.fold((left) {
        debugPrint(" get all events fold exception : ${left.toString()}");
      }, (right) {
        final r = right as GetAllListingsResponseModel;

        state = state.copyWith(allEventList: r.data);
      });
    } catch (error) {
      debugPrint(" get all events exception:$error");
    }
  }

  getNearByListing() async {
    try {
      final position = await getLatLong();

      debugPrint(
          "user coordinates [ lat : ${position.latitude}, long: ${position.longitude} ");

      final lat = position.latitude;
      final long = position.longitude;
      GetAllListingsResponseModel responseModel = GetAllListingsResponseModel();
      GetAllListingsRequestModel requestModel = GetAllListingsRequestModel(
          centerLatitude: lat, centerLongitude: long,radius: 20);

      final response = await listingsUseCase.call(requestModel, responseModel);

      response.fold((left) {
        debugPrint(" getNearByEvents fold exception : ${left.toString()}");
      }, (right) {});
    } catch (error) {
      debugPrint(" getNearByEvents exception:$error");
    }
  }

  getRecommendationListing() async {
    try {
      GetAllListingsResponseModel responseModel = GetAllListingsResponseModel();
      GetAllListingsRequestModel requestModel = GetAllListingsRequestModel();

      final response = await listingsUseCase.call(requestModel, responseModel);

      response.fold((left) {
        debugPrint(
            " getRecommendationListing fold exception : ${left.toString()}");
      }, (right) {
        final r = right as GetAllListingsResponseModel;

        state = state.copyWith(recommendationList: r.data);
      });
    } catch (error) {
      debugPrint(" getRecommendationListing exception:$error");
    }
  }
}

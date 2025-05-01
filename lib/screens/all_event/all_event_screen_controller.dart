import 'package:domain/model/request_model/listings/get_all_listings_request_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/usecase/listings/listings_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'all_event_screen_state.dart';

final allEventScreenProvider = StateNotifierProvider.autoDispose<
        AllEventScreenController, AllEventScreenState>(
    (ref) => AllEventScreenController(
        listingsUseCase: ref.read(listingsUseCaseProvider)));

class AllEventScreenController extends StateNotifier<AllEventScreenState> {
  ListingsUseCase listingsUseCase;

  AllEventScreenController({required this.listingsUseCase})
      : super(AllEventScreenState.empty());

  Future<void> getEventsList() async {
    try {
      state = state.copyWith(isLoading: true);

      GetAllListingsRequestModel getAllListingsRequestModel =
          GetAllListingsRequestModel();
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
          state = state.copyWith(listingList: eventsList, isLoading: false);
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
    state = state.copyWith(
        listingList: state.listingList);
  }
}

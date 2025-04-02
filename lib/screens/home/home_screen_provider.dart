import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/usecase/listings/listings_usecase.dart';

import 'home_screen_state.dart';
import 'package:domain/model/request_model/listings/get_all_listings_request_model.dart';

final homeScreenProvider =
    StateNotifierProvider.autoDispose<HomeScreenProvider, HomeScreenState>(
        (ref) => HomeScreenProvider(listingsUseCase: ref.read(listingsUseCaseProvider)));

class HomeScreenProvider extends StateNotifier<HomeScreenState> {
  ListingsUseCase listingsUseCase;
  HomeScreenProvider({required this.listingsUseCase}) : super(HomeScreenState.empty());

  Future<void> getListings() async {
    try {
      state = state.copyWith(loading: true, error: "");

      GetAllListingsRequestModel getAllListingsRequestModel = GetAllListingsRequestModel(
        pageNo: 1,
        pageSize: 10,
        sortByStartDate: true,
        statusId: "active",
        categoryId: "41",
        subcategoryId: "456",
        cityId: "789",
        translate: "en",
        startAfterDate: "2024-01-01",
        endBeforeDate: "2024-12-31",
      );

      GetAllListingsResponseModel getAllListingsResponseModel =
      GetAllListingsResponseModel();
      final result = await listingsUseCase.call(
          getAllListingsRequestModel, getAllListingsResponseModel);
      result.fold(
            (l) {
          state = state.copyWith(loading: false, error: l.toString());
        },
            (r) {
          var listings = (r as GetAllListingsResponseModel).data;
          state = state.copyWith(listings: listings, loading: false);
        },
      );
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }



  addCarouselListener(CarouselController carouselController) {
    final position = carouselController.position;
    final width = 317;
    if (position.hasPixels) {
      final index = (position.pixels / width).round();
      state = state.copyWith(highlightCount: index);
    }

    updateCarouselCard(int index) {
      state = state.copyWith(highlightCount: index);
    }
  }
}

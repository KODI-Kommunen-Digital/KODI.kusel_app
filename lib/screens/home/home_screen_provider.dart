import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:domain/model/request_model/listings/get_all_listings_request_model.dart';
import 'package:domain/model/request_model/listings/search_request_model.dart';
import 'package:domain/model/request_model/user_detail/user_detail_request_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/model/response_model/listings_model/search_listings_response_model.dart';
import 'package:domain/model/response_model/user_detail/user_detail_response_model.dart';
import 'package:domain/usecase/listings/listings_usecase.dart';
import 'package:domain/usecase/search/search_usecase.dart';
import 'package:domain/usecase/user_detail/user_detail_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:data/service/location_service/location_service.dart';
import 'home_screen_state.dart';

final homeScreenProvider =
    StateNotifierProvider.autoDispose<HomeScreenProvider, HomeScreenState>(
        (ref) => HomeScreenProvider(
              listingsUseCase: ref.read(listingsUseCaseProvider),
              searchUseCase: ref.read(searchUseCaseProvider),
              sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
              userDetailUseCase: ref.read(userDetailUseCaseProvider),
            ));

class HomeScreenProvider extends StateNotifier<HomeScreenState> {
  ListingsUseCase listingsUseCase;
  SearchUseCase searchUseCase;
  SharedPreferenceHelper sharedPreferenceHelper;
  UserDetailUseCase userDetailUseCase;

  HomeScreenProvider(
      {required this.listingsUseCase,
      required this.searchUseCase,
      required this.sharedPreferenceHelper,
      required this.userDetailUseCase})
      : super(HomeScreenState.empty());

  Future<void> getHighlights() async {
    try {
      state = state.copyWith(loading: true, error: "");

      GetAllListingsRequestModel getAllListingsRequestModel =
          GetAllListingsRequestModel(categoryId: "41");

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
          state = state.copyWith(highlightsList: listings, loading: false);
        },
      );
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  Future<void> getEvents() async {
    try {
      state = state.copyWith(loading: true, error: "");

      GetAllListingsRequestModel getAllListingsRequestModel =
          GetAllListingsRequestModel(categoryId: "3");

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
          state = state.copyWith(eventsList: listings, loading: false);
        },
      );
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  Future<void> getNearbyEvents() async {
    try {
      getLocation();
      state = state.copyWith(loading: true, error: "");

      GetAllListingsRequestModel getAllListingsRequestModel =
      GetAllListingsRequestModel(
        radius: 1,
        centerLatitude: state.latitude,
        centerLongitude: state.longitude
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
          state = state.copyWith(nearbyEventsList: listings, loading: false);
        },
      );
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  Future<List<Listing>> searchList({
    required String searchText,
    required void Function() success,
    required void Function(String message) error,
  }) async {
    try {
      state = state.copyWith(loading: true, error: "");
      SearchRequestModel searchRequestModel =
          SearchRequestModel(searchQuery: searchText);
      SearchListingsResponseModel searchListingsResponseModel =
          SearchListingsResponseModel();

      final result = await searchUseCase.call(
          searchRequestModel, searchListingsResponseModel);
      return result.fold(
        (l) {
          state = state.copyWith(loading: false);
          debugPrint('Exception = $l');
          error(l.toString());
          return <Listing>[];
        },
        (r) {
          state = state.copyWith(loading: false);
          final listings = (r as SearchListingsResponseModel).data;
          debugPrint('>>>> returned = ${listings?.length}');
          success();
          return listings ?? <Listing>[];
        },
      );
    } catch (e) {
      state = state.copyWith(loading: false);
      debugPrint('>>>> Exception = $e');
      error(e.toString());
      return <Listing>[];
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

  Future<void> getUserDetails() async {
    try {
      final userId = sharedPreferenceHelper.getInt(userIdKey);

      UserDetailRequestModel requestModel = UserDetailRequestModel(id: userId);
      UserDetailResponseModel responseModel = UserDetailResponseModel();
      final result = await userDetailUseCase.call(requestModel, responseModel);

      result.fold((l) {
        debugPrint('get user details fold exception : $l');
      }, (r) async {
        final response = r as UserDetailResponseModel;
        await sharedPreferenceHelper.setString(
            userNameKey, response.data?.username ?? "");
        state = state.copyWith(userName: response.data?.username ?? "");
      });
    } catch (error) {
      debugPrint('get user details exception : $error');
    }
  }

  Future<void> getLoginStatus() async {
    final token = sharedPreferenceHelper.getString(tokenKey);
    if (token == null) {
      state = state.copyWith(isSignupButtonVisible: true);
    } else {
      state = state.copyWith(isSignupButtonVisible: false);
    }
  }

  Future<void> getLocation() async {
    final position = await LocationService.getCurrentLocation();
    if (position != null) {
      print("lat long printing ${position.latitude}");
      state = state.copyWith(
          latitude: position.latitude, longitude: position.longitude);
    }
  }
}

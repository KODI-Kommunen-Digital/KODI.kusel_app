import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:data/service/location_service/location_service.dart';
import 'package:domain/model/request_model/listings/get_all_listings_request_model.dart';
import 'package:domain/model/request_model/listings/search_request_model.dart';
import 'package:domain/model/request_model/user_detail/user_detail_request_model.dart';
import 'package:domain/model/request_model/weather/weather_request_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/model/response_model/listings_model/search_listings_response_model.dart';
import 'package:domain/model/response_model/user_detail/user_detail_response_model.dart';
import 'package:domain/model/response_model/weather/weather_response_model.dart';
import 'package:domain/usecase/listings/listings_usecase.dart';
import 'package:domain/usecase/search/search_usecase.dart';
import 'package:domain/usecase/user_detail/user_detail_usecase.dart';
import 'package:domain/usecase/weather/weather_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/common_widgets/listing_id_enum.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

import 'home_screen_state.dart';

final homeScreenProvider =
    StateNotifierProvider<HomeScreenProvider, HomeScreenState>(
        (ref) => HomeScreenProvider(
              listingsUseCase: ref.read(listingsUseCaseProvider),
              searchUseCase: ref.read(searchUseCaseProvider),
              sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
              userDetailUseCase: ref.read(userDetailUseCaseProvider),
              weatherUseCase: ref.read(weatherUseCaseProvider),
            ));

class HomeScreenProvider extends StateNotifier<HomeScreenState> {
  ListingsUseCase listingsUseCase;
  SearchUseCase searchUseCase;
  SharedPreferenceHelper sharedPreferenceHelper;
  UserDetailUseCase userDetailUseCase;
  WeatherUseCase weatherUseCase;

  HomeScreenProvider(
      {required this.listingsUseCase,
      required this.searchUseCase,
      required this.sharedPreferenceHelper,
      required this.userDetailUseCase,
      required this.weatherUseCase})
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
          GetAllListingsRequestModel(categoryId: ListingCategoryId.event.eventId.toString());

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

      LatLong kuselLatLong = LatLong(49.53603477650214, 7.392734870386151);
      GetAllListingsRequestModel getAllListingsRequestModel =
      GetAllListingsRequestModel(
          radius: 1,
          centerLongitude: kuselLatLong.latitude,
          centerLatitude: kuselLatLong.longitude
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
      SearchRequestModel searchRequestModel =
          SearchRequestModel(searchQuery: searchText);
      SearchListingsResponseModel searchListingsResponseModel =
          SearchListingsResponseModel();

      final result = await searchUseCase.call(
          searchRequestModel, searchListingsResponseModel);
      return result.fold(
        (l) {
          debugPrint('fold Exception = $l');
          error(l.toString());
          return <Listing>[];
        },
        (r) {
          final listings = (r as SearchListingsResponseModel).data;
          success();
          return listings ?? <Listing>[];
        },
      );
    } catch (e) {
      state = state.copyWith(loading: false);
      debugPrint(' Exception = $e');
      error(e.toString());
      return <Listing>[];
    }
  }

  updateCardIndex(int index) {
    state = state.copyWith(highlightCount: index);
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
        state = state.copyWith(
            userName: response.data?.firstname ?? "");
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
    if (mounted && position != null) {
      state = state.copyWith(
          latitude: position.latitude, longitude: position.longitude);
    }
  }

  void setIsFavorite(bool isFavorite, int? id) {

    for (var listing in state.highlightsList) {
      if (listing.id == id) {
        listing.isFavorite = isFavorite;
      }
    }
    state = state.copyWith(
        highlightsList: state.highlightsList);
  }

  void setIsFavoriteEvent(bool isFavorite, int? id) {
    for (var listing in state.eventsList) {
      if (listing.id == id) {
        listing.isFavorite = isFavorite;
      }
    }
    state = state.copyWith(
        highlightsList: state.eventsList);
  }

  void setIsFavoriteHighlight(bool isFavorite, int? id) {
    for (var listing in state.highlightsList) {
      if (listing.id == id) {
        listing.isFavorite = isFavorite;
      }
    }
    state = state.copyWith(
        highlightsList: state.highlightsList);
  }

  Future<void> getWeather() async {
    try {
      WeatherRequestModel requestModel =
          WeatherRequestModel(days: 3, placeName: "kusel");
      WeatherResponseModel responseModel = WeatherResponseModel();

      final response = await weatherUseCase.call(requestModel, responseModel);

      response.fold((l) {
        debugPrint('get weather fold exception = $l');
      }, (r) {

        final result = r as WeatherResponseModel;

        state = state.copyWith(weatherResponseModel: result);

      });
    } catch (error) {
      debugPrint('get weather exception = $error');
    }
  }
}

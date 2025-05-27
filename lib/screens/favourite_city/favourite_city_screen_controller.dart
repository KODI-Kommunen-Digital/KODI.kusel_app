import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/request_model/refresh_token/refresh_token_request_model.dart';
import 'package:domain/model/response_model/refresh_token/refresh_token_response_model.dart';
import 'package:domain/usecase/refresh_token/refresh_token_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/model/request_model/favourite_city/favourite_city_request_model.dart';
import 'package:domain/model/response_model/favourite_city/favourite_city_response_model.dart';
import 'package:domain/usecase/favourite_city/get_favourite_cities_usecase.dart';
import 'package:kusel/screens/favourite_city/favourite_city_state.dart';

final favouriteCityScreenProvider = StateNotifierProvider<
        FavouriteCityScreenController, FavouriteCityScreenState>(
    (ref) => FavouriteCityScreenController(
      getFavouriteCitiesUseCase: ref.read(getFavouriteCitiesUseCaseProvider),
      sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
      tokenStatus: ref.read(tokenStatusProvider),
      refreshTokenUseCase: ref.read(refreshTokenUseCaseProvider),    )
);

class FavouriteCityScreenController extends StateNotifier<FavouriteCityScreenState> {
  GetFavouriteCitiesUseCase getFavouriteCitiesUseCase;
  SharedPreferenceHelper sharedPreferenceHelper;
  TokenStatus tokenStatus;
  RefreshTokenUseCase refreshTokenUseCase;

  FavouriteCityScreenController(
      {required this.getFavouriteCitiesUseCase,
      required this.sharedPreferenceHelper,
      required this.tokenStatus,
      required this.refreshTokenUseCase})
      : super(FavouriteCityScreenState.empty());

  Future<void> fetchFavouriteCities() async {
    try {
      state = state.copyWith(isLoading: true);
      final response = tokenStatus.isAccessTokenExpired();

      if (response) {
        final userId = sharedPreferenceHelper.getInt(userIdKey);

        RefreshTokenRequestModel requestModel =
        RefreshTokenRequestModel(userId: userId?.toString() ?? "");
        RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();

        final response =
        await refreshTokenUseCase.call(requestModel, responseModel);

        response.fold((left) {
          debugPrint('refresh token add fav cities fold exception : $left');
        }, (right) async {
          final res = right as RefreshTokenResponseModel;
          sharedPreferenceHelper.setString(
              tokenKey, res.data?.accessToken ?? "");
          sharedPreferenceHelper.setString(
              refreshTokenKey, res.data?.refreshToken ?? "");

          GetFavouriteCitiesRequestModel requestModel =
          GetFavouriteCitiesRequestModel(
              userId: sharedPreferenceHelper.getInt(userIdKey));

          GetFavouriteCitiesResponseModel responseModel =
          GetFavouriteCitiesResponseModel();

          final result = await getFavouriteCitiesUseCase.call(
              requestModel, responseModel);
          result.fold(
                (l) {
              debugPrint('add fav city fold exception : $l');
            },
                (r) {
                  final result = r as GetFavouriteCitiesResponseModel;
                  state = state.copyWith(cityList: result.data, isLoading: false);
            },
          );
        });
      } else {
        GetFavouriteCitiesRequestModel requestModel =
        GetFavouriteCitiesRequestModel(
            userId: sharedPreferenceHelper.getInt(userIdKey));

        GetFavouriteCitiesResponseModel responseModel =
        GetFavouriteCitiesResponseModel();

        final result = await getFavouriteCitiesUseCase.call(
            requestModel, responseModel);
        result.fold(
              (l) {
            debugPrint('add fav city fold exception : $l');
          },
              (r) {
            final result = r as GetFavouriteCitiesResponseModel;
            state = state.copyWith(cityList: result.data, isLoading: false);
            },
        );
      }
    } catch (error) {
      debugPrint("add fav city exception: $error");
    }
  }
}

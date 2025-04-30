import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/request_model/favorites/get_favorites_request_model.dart';
import 'package:domain/model/request_model/refresh_token/refresh_token_request_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/model/response_model/refresh_token/refresh_token_response_model.dart';
import 'package:domain/usecase/favorites/get_favorites_usecase.dart';
import 'package:domain/usecase/refresh_token/refresh_token_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'favorites_list_screen_state.dart';

final favoritesListScreenProvider = StateNotifierProvider.autoDispose<
        FavoritesListScreenController, FavoritesListScreenState>(
    (ref) => FavoritesListScreenController(
        getFavoritesUseCaseProvider: ref.read(getFavoritesUseCaseProvider),
        sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
        tokenStatus: ref.read(tokenStatusProvider),
        refreshTokenUseCase: ref.read(refreshTokenUseCaseProvider)));

class FavoritesListScreenController
    extends StateNotifier<FavoritesListScreenState> {
  FavoritesListScreenController(
      {required this.getFavoritesUseCaseProvider,
      required this.sharedPreferenceHelper,
      required this.tokenStatus,
      required this.refreshTokenUseCase})
      : super(FavoritesListScreenState.empty());
  GetFavoritesUseCase getFavoritesUseCaseProvider;
  SharedPreferenceHelper sharedPreferenceHelper;
  TokenStatus tokenStatus;
  RefreshTokenUseCase refreshTokenUseCase;

  Future<void> getFavoritesList() async {
    try {
      state = state.copyWith(loading: true, error: "");

      final response = tokenStatus.isAccessTokenExpired();

      if (response) {
        final userId = sharedPreferenceHelper.getInt(userIdKey);

        RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();
        RefreshTokenRequestModel requestModel =
            RefreshTokenRequestModel(userId: userId?.toString() ?? "");

        final result =
            await refreshTokenUseCase.call(requestModel, responseModel);

        result.fold((l) {
          state = state.copyWith(loading: false, error: l.toString());
        }, (r) async {
          final res = r as RefreshTokenResponseModel;
          sharedPreferenceHelper.setString(
              tokenKey, res.data?.accessToken ?? "");
          sharedPreferenceHelper.setString(
              refreshTokenKey, res.data?.refreshToken ?? "");

          GetFavoritesRequestModel getAllListingsRequestModel =
              GetFavoritesRequestModel(
                  userId: sharedPreferenceHelper.getInt(userIdKey).toString());
          GetAllListingsResponseModel getAllListResponseModel =
              GetAllListingsResponseModel();

          final result = await getFavoritesUseCaseProvider.call(
              getAllListingsRequestModel, getAllListResponseModel);
          result.fold(
            (l) {
              state = state.copyWith(loading: false, error: l.toString());
            },
            (r) {
              var eventsList = (r as GetAllListingsResponseModel).data;
              state = state.copyWith(list: eventsList, loading: false);
            },
          );
        });
      } else {
        GetFavoritesRequestModel getAllListingsRequestModel =
            GetFavoritesRequestModel(
                userId: sharedPreferenceHelper.getInt(userIdKey).toString());
        GetAllListingsResponseModel getAllListResponseModel =
            GetAllListingsResponseModel();

        final result = await getFavoritesUseCaseProvider.call(
            getAllListingsRequestModel, getAllListResponseModel);
        result.fold(
          (l) {
            state = state.copyWith(loading: false, error: l.toString());
          },
          (r) {
            var eventsList = (r as GetAllListingsResponseModel).data;
            state = state.copyWith(list: eventsList, loading: false);
          },
        );
      }
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  void removeFavorite(bool isFavorite, int? id) {
    if (id == null) return;

    for (var listing in state.eventsList) {
      if (listing.id == id) {
        listing.isFavorite = isFavorite;
      }
    }
    final updatedList =
        state.eventsList.where((listing) => listing.id != id).toList();
    state = state.copyWith(
      list: updatedList,
    );
  }
}

import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:domain/model/request_model/listings/get_all_listings_request_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/usecase/favorites/get_favorites_usecase.dart';
import 'package:domain/usecase/listings/listings_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/model/request_model/favorites/get_favorites_request_model.dart';
import 'package:kusel/screens/favorite/favorites_list_screen_parameter.dart';

import 'favorites_list_screen_state.dart';

final favoritesListScreenProvider = StateNotifierProvider.autoDispose<
    FavoritesListScreenController,
    FavoritesListScreenState>(
        (ref) =>
        FavoritesListScreenController(
            getFavoritesUseCaseProvider: ref.read(getFavoritesUseCaseProvider),
            sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)
        ));

class FavoritesListScreenController extends StateNotifier<FavoritesListScreenState> {
  FavoritesListScreenController({required this.getFavoritesUseCaseProvider, required this.sharedPreferenceHelper})
      : super(FavoritesListScreenState.empty());
  GetFavoritesUseCase getFavoritesUseCaseProvider;
  SharedPreferenceHelper sharedPreferenceHelper;

  Future<void> getFavoritesList() async {
    try {
      state = state.copyWith(loading: true, error: "");

      GetFavoritesRequestModel getAllListingsRequestModel =
      GetFavoritesRequestModel( userId: sharedPreferenceHelper.getInt(userIdKey).toString());
      GetAllListingsResponseModel getAllListResponseModel = GetAllListingsResponseModel();

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
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }
}

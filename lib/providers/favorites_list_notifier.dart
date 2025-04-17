import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:domain/model/response_model/favorites/get_favorites_response_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/usecase/favorites/get_favorites_usecase.dart';
import 'package:domain/usecase/favorites/add_favorite_usecase.dart';
import 'package:domain/usecase/favorites/delete_favorite_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/model/request_model/favorites/add_favorites_request_model.dart';
import 'package:domain/model/request_model/favorites/delete_favorites_request_model.dart';
import 'package:domain/model/response_model/favorites/add_favorites_response_model.dart';
import 'package:data/repo_impl/favorites/favorites_repo_impl.dart';

final favoritesListProvider =
    StateNotifierProvider<FavoritesListNotifier, List<Listing>>(
  (ref) => FavoritesListNotifier(
    addFavoriteUseCase: ref.read(addFavoritesUseCaseProvider),
    deleteFavoriteUsecase: ref.read(deleteFavoritesUseCaseProvider),
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
  ),
);

class FavoritesListNotifier extends StateNotifier<List<Listing>> {
  SharedPreferenceHelper sharedPreferenceHelper;
  AddFavoriteUseCase addFavoriteUseCase;
  DeleteFavoriteUsecase deleteFavoriteUsecase;

  FavoritesListNotifier({
    required this.addFavoriteUseCase,
    required this.deleteFavoriteUsecase,
    required this.sharedPreferenceHelper,
  }) : super([]);

  Future<void> addFavorite(Listing item, void Function({required bool isFavorite}) success)  async {
    try {
      print("adding to fav");
      AddFavoritesRequestModel getFavoritesRequestModel =
          AddFavoritesRequestModel(
              cityId: item.cityId.toString(),
              listingId: item.id.toString(),
              userId:
                  sharedPreferenceHelper.getInt(userIdKey).toString() ?? "");

      GetFavoritesResponseModel getFavoritesResponseModel =
          GetFavoritesResponseModel();

      final result = await addFavoriteUseCase.call(
          getFavoritesRequestModel, getFavoritesResponseModel);
      result.fold(
        (l) {
        },
        (r) {
          success(isFavorite: true);
        },
      );
    } catch (error) {
      print(">>>>>>>$error");
    }


  }

  Future<void> removeFavorite(int id, void Function({required bool isFavorite}) success) async {
    try {
      print("removing fav");
      DeleteFavoritesRequestModel getFavoritesRequestModel =
          DeleteFavoritesRequestModel(
          id: id,
          userId:
          sharedPreferenceHelper.getInt(userIdKey));

      GetFavoritesResponseModel getFavoritesResponseModel =
      GetFavoritesResponseModel();

      final result = await deleteFavoriteUsecase.call(
          getFavoritesRequestModel, getFavoritesResponseModel);
      result.fold(
            (l) {
        },
            (r) {
          success(isFavorite: false);
        },
      );
    } catch (error) {
      print(">>>>>>>$error");
    }
  }

  void toggleFavorite(Listing item, {required void Function({required bool isFavorite}) success,
      required void Function(String message) error}) {
    print(">>>> ${item.isFavorite == 1}");

    if (state.any((fav) => item.isFavorite != 1)) {
      removeFavorite(item.id ?? 0, success);
    } else {
      addFavorite(item, success);
    }
  }

}

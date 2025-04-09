import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:domain/model/response_model/favorites/get_favorites_response_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/usecase/favorites/get_favorites_usecase.dart';
import 'package:domain/usecase/favorites/add_favorite_usecase.dart';
import 'package:domain/usecase/favorites/delete_favorite_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/model/request_model/favorites/add_favorites_request_model.dart';
import 'package:domain/model/response_model/favorites/add_favorites_response_model.dart';
import 'package:data/repo_impl/favorites/favorites_repo_impl.dart';

final favoritesListProvider =
    StateNotifierProvider<FavoritesListNotifier, List<FavoritesItem>>(
  (ref) => FavoritesListNotifier(
    getFavoritesUseCase: GetFavoritesUseCase(
        favoritesRepo: ref.read(favoritesRepositoryProvider)),
    addFavoriteUseCase: ref.read(addFavoritesUseCaseProvider),
    deleteFavoriteUsecase: ref.read(deleteFavoritesUseCaseProvider),
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
  ),
);

class FavoritesListNotifier extends StateNotifier<List<FavoritesItem>> {
  GetFavoritesUseCase getFavoritesUseCase;
  SharedPreferenceHelper sharedPreferenceHelper;
  AddFavoriteUseCase addFavoriteUseCase;
  DeleteFavoriteUsecase deleteFavoriteUsecase;

  FavoritesListNotifier({
    required this.getFavoritesUseCase,
    required this.addFavoriteUseCase,
    required this.deleteFavoriteUsecase,
    required this.sharedPreferenceHelper,
  }) : super([]);

  Future<void> addFavorite(Listing item, void Function() success) async {
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
          state = [
            ...state,
            FavoritesItem(
                cityId: item.cityId, listingId: item.id, userId: item.userId)
          ];
          success();
        },
      );
    } catch (error) {
      print(">>>>>>>$error");
    }


  }

  void removeFavorite(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  void toggleFavorite(Listing item, {required void Function() success,
      required void Function(String message) error}) {
    if (state.any((fav) => fav.listingId == item.id)) {
      removeFavorite(item.id.toString());
    } else {
      addFavorite(item, success);
    }
  }

  void setFavorites(List<FavoritesItem> items) {
    state = items;
  }

  bool checkIsFavorite(Listing listing) {
    return state.any((fav) => fav.listingId == listing.id && fav.cityId == listing.cityId);
  }

}

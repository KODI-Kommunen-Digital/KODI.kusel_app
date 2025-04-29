import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/end_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoritesServiceProvider = Provider((ref) => FavoritesService(ref: ref));

class FavoritesService {
  Ref ref;

  FavoritesService({required this.ref});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final apiHelper = ref.read(apiHelperProvider);

    final userId = requestModel.toJson()["userId"];

    final result = await apiHelper.getRequest(
        path: gatFavoritesListingEndpoint(userId), create: () => responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }

  Future<Either<Exception, BaseModel>> addFavorite(
      BaseModel requestModel, BaseModel responseModel) async {
    final apiHelper = ref.read(apiHelperProvider);
    final userId = requestModel.toJson()["userId"];
    print("city id");
    print(requestModel.toJson()["cityId"]);
    final result = await apiHelper.postRequest(
        path: gatFavoritesEndpoint(userId), create: () => responseModel, body: requestModel.toJson());

    return result.fold((l) => Left(l), (r) => Right(r));
  }

  Future<Either<Exception, BaseModel>> deleteFavorite(
      BaseModel requestModel, BaseModel responseModel) async {
    print("delete fav serv");
    final apiHelper = ref.read(apiHelperProvider);
    final userId = requestModel.toJson()["userId"];
    final listingId = requestModel.toJson()["id"];
    print("delete fav serv 22");

    final result = await apiHelper.delete(
        path: deleteFavoritesEndpoint(userId.toString(), listingId.toString()), create: () => responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}

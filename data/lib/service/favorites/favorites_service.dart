import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/end_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network/src/api_helper.dart';

final favoritesServiceProvider = Provider((ref) => FavoritesService(
    apiHelper: ApiHelper(dioHelper: ref.read(dioHelperObjectProvider))));

class FavoritesService {
  ApiHelper apiHelper;

  FavoritesService({required this.apiHelper});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {

    final userId = requestModel.toJson()["userId"];
    print(">>>>>>>userId $userId");

    final result =
        await apiHelper.getRequest(path: gatFavoritesEndpoint(userId), create: () => responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }

  Future<Either<Exception, BaseModel>> addFavorite(
      BaseModel requestModel, BaseModel responseModel) async {

    final userId = requestModel.toJson()["userId"];
    print(">>>>>>>userId $userId");

    final result =
    await apiHelper.postRequest(path: gatFavoritesEndpoint(userId), create: () => responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }

  Future<Either<Exception, BaseModel>> deleteFavorite(
      BaseModel requestModel, BaseModel responseModel) async {

    final userId = requestModel.toJson()["userId"];
    print(">>>>>>>userId $userId");

    final result =
    await apiHelper.getRequest(path: gatFavoritesEndpoint(userId), create: () => responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}

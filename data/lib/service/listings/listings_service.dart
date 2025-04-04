import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/end_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network/src/api_helper.dart';

final listingServiceProvider = Provider((ref) => ListingsService(
    apiHelper: ApiHelper(dioHelper: ref.read(dioHelperObjectProvider))));

class ListingsService {
  ApiHelper apiHelper;

  ListingsService({required this.apiHelper});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {

    final queryParams = requestModel.toJson().entries
        .where((e) => e.value != null)
        .map((e) => "${e.key}=${Uri.encodeComponent(e.value.toString())}")
        .join("&");
    final path = "$listingsEndPoint?$queryParams";

    final result =
        await apiHelper.getRequest(path: path, create: () => responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}

import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/end_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network/src/api_helper.dart';

final exploreServiceProvider = Provider(
    (ref) => ExploreService(apiHelper: ApiHelper(dioHelper: ref.read(dioHelperObjectProvider))));

class ExploreService {
  ApiHelper apiHelper;

  ExploreService({required this.apiHelper});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await apiHelper.getRequest(
        path: exploreEndpoint, create: () => responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}

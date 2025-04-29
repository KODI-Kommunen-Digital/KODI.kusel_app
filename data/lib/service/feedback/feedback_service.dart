import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/end_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final feedBackServiceProvider = Provider((ref) => FeedBackService(ref: ref));

class FeedBackService {
  Ref ref;

  FeedBackService({required this.ref});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final apiHelper = ref.read(apiHelperProvider);

    final result = await apiHelper.postRequest(
        path: exploreEndpoint,
        create: () => responseModel,
        body: requestModel.toJson());

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}

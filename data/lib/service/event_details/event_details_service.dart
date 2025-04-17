import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/end_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventDetailsServiceProvider =
Provider((ref) => EventDetailsService(ref: ref));

class EventDetailsService {
  Ref ref;

  EventDetailsService({required this.ref});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final path =
        "$listingsEndPoint/${requestModel.toJson()["id"]}";
    final apiHelper = ref.read(apiHelperProvider);

    final result = await apiHelper.getRequest(
      path: path,
      create: () => responseModel,
    );

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}

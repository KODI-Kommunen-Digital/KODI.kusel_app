import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/end_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network/src/api_helper.dart';

final userDetailServiceProvider = Provider((ref) => UserDetailService(
    apiHelper: ApiHelper(dioHelper: ref.read(dioHelperObjectProvider))));

class UserDetailService {
  ApiHelper apiHelper;

  UserDetailService({required this.apiHelper});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final path = "$userDetailsEndPoint/${requestModel.toJson()["id"]}";

    final result = await apiHelper.getRequest(
      path: path,
      create: () => responseModel,
    );

    return result.fold((l) {
      return Left(l);
    } , (r) {
      return Right(r);
    } );
  }
}

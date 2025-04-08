import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/end_points.dart';
import 'package:data/params/listings_params.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network/src/api_helper.dart';

final searchServiceProvider = Provider(
    (ref) => SearchService(apiHelper: ApiHelper(dioHelper: ref.read(dioHelperObjectProvider))));

class SearchService {
  ApiHelper apiHelper;

  SearchService({required this.apiHelper});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {

    final endpoint = Uri.parse(searchEndPoint).replace(queryParameters: {
      'searchQuery': (requestModel.toJson()["searchQuery"] ?? "").toString(),
    });


    final result = await apiHelper.getRequest(
        path: endpoint.toString(),
        create: () => responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}

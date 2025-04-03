import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/end_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network/src/api_helper.dart';

final searchServiceProvider = Provider(
    (ref) => SearchService(searchQuery: "", apiHelper: ApiHelper(dioHelper: ref.read(dioHelperObjectProvider))));

class SearchService {
  ApiHelper apiHelper;
  String searchQuery;

  SearchService({required this.apiHelper, required this.searchQuery});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {

    final endpoint = "${listingsEndPoint}?search?&searchQuery=$searchQuery";

    final result = await apiHelper.getRequest(
        path: endpoint,
        create: () => responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}

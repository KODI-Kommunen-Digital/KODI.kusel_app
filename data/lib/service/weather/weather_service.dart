import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/end_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final weatherServiceProvider = Provider((ref) => WeatherService(ref: ref));

class WeatherService {
  Ref ref;

  WeatherService({required this.ref});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final json = requestModel.toJson();

    final path =
        "$weatherEndPoint?q=${json['placeName']}&days=${json['days']}&key=$weatherApiKey";
    final apiHelper = ref.read(apiHelperForWeatherProvider);

    final result = await apiHelper.getRequest(
      path: path,
      create: () => responseModel,
    );

    return result.fold((l) {
      return Left(l);
    }, (r) {
      return Right(r);
    });
  }
}

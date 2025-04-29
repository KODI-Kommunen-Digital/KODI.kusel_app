import 'package:core/base_model.dart';

class GetCityDetailsRequestModel  extends BaseModel<GetCityDetailsRequestModel>{
  final bool hasForum;

  GetCityDetailsRequestModel({required this.hasForum});

  @override
  Map<String, dynamic> toJson() {
    return {
      'hasForum': hasForum,
    };
  }

  @override
  GetCityDetailsRequestModel fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }
}

import 'package:core/base_model.dart';

class MobilityResponseModel implements BaseModel<MobilityResponseModel> {
  int? id;

  MobilityResponseModel({this.id});

  @override
  MobilityResponseModel fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {"id": id};
  }
}

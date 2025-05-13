import 'package:core/base_model.dart';

class OrtDetailRequestModel implements BaseModel<OrtDetailRequestModel> {
  String ortId;

  OrtDetailRequestModel({required this.ortId});

  @override
  OrtDetailRequestModel fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {"ortId": ortId};
  }
}

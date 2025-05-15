import 'package:core/base_model.dart';

class MobilityRequestModel implements BaseModel<MobilityRequestModel> {
  int? id;

  MobilityRequestModel({this.id});

  @override
  MobilityRequestModel fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {"id": id};
  }
}

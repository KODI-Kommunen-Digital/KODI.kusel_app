import 'package:core/base_model.dart';

class ParticipateResponseModel implements BaseModel<ParticipateResponseModel> {
  int? id;

  ParticipateResponseModel({this.id});

  @override
  ParticipateResponseModel fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {"id": id};
  }
}

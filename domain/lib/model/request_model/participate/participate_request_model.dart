import 'package:core/base_model.dart';

class ParticipateRequestModel implements BaseModel<ParticipateRequestModel> {
  int? id;

  ParticipateRequestModel({this.id});

  @override
  ParticipateRequestModel fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {"id": id};
  }
}

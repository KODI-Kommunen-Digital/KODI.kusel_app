import 'package:core/base_model.dart';

class GetEventDetailsRequestModel implements BaseModel<GetEventDetailsRequestModel> {
  int? id;

  GetEventDetailsRequestModel({this.id});

  @override
  GetEventDetailsRequestModel fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {"id": id};
  }
}

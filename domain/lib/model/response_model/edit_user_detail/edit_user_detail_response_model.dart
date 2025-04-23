import 'package:core/base_model.dart';

class EditUserDetailsResponseModel implements BaseModel<EditUserDetailsResponseModel> {
  String? status;

  EditUserDetailsResponseModel({this.status});

  @override
  EditUserDetailsResponseModel fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {"status": status};
  }
}

import 'package:core/base_model.dart';

class SignUpResponseModel extends BaseModel<SignUpResponseModel> {
  String? status;
  int? id;

  SignUpResponseModel({
    this.status,
    this.id,
  });

  @override
  SignUpResponseModel fromJson(Map<String, dynamic> json) {
    return SignUpResponseModel(
      status: json['status'] as String?,
      id: json['id'] as int?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'id': id,
    };
  }
}

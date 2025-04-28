import 'package:core/base_model.dart';

class EditUserImageRequestModel extends BaseModel<EditUserImageRequestModel> {
  int? id;
  String? imagePath;

  EditUserImageRequestModel({this.id, this.imagePath});

  @override
  EditUserImageRequestModel fromJson(Map<String, dynamic> json) {
    return EditUserImageRequestModel(
      id: json['id'],
      imagePath: json['image'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
    };
  }
}

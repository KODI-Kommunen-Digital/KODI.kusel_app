import 'package:core/base_model.dart';

class EditUserDetailRequestModel implements BaseModel<EditUserDetailRequestModel> {
  int? id;
  String? username;
  String? socialMedia;
  String? email;
  String? website;
  String? description;
  String? image;
  String? phoneNumber;
  String? firstname;
  String? lastname;
  int? roleId;

  EditUserDetailRequestModel({
    this.id,
    this.username,
    this.socialMedia,
    this.email,
    this.website,
    this.description,
    this.image,
    this.phoneNumber,
    this.firstname,
    this.lastname,
    this.roleId,
  });

  @override
  EditUserDetailRequestModel fromJson(Map<String, dynamic> json) {
    return EditUserDetailRequestModel(
      id: json['id'],
      username: json['username'],
      socialMedia: json['socialMedia'],
      email: json['email'],
      website: json['website'],
      description: json['description'],
      image: json['image'],
      phoneNumber: json['phoneNumber'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      roleId: json['roleId'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (username != null) data['username'] = username;
    if (socialMedia != null) data['socialMedia'] = socialMedia;
    if (email != null) data['email'] = email;
    if (website != null) data['website'] = website;
    if (description != null) data['description'] = description;
    if (image != null) data['image'] = image;
    if (phoneNumber != null) data['phoneNumber'] = phoneNumber;
    if (firstname != null) data['firstname'] = firstname;
    if (lastname != null) data['lastname'] = lastname;
    if (roleId != null) data['roleId'] = roleId;
    return data;
  }
}

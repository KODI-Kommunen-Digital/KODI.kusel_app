import 'package:core/base_model.dart';

class UserDetailResponseModel implements BaseModel<UserDetailResponseModel> {
   String? status;
   UserData? data;

  UserDetailResponseModel({
     this.status,
     this.data,
  });

  @override
  UserDetailResponseModel fromJson(Map<String, dynamic> json) {
    return UserDetailResponseModel(
      status: json['status'],
      data: json['data'] != null ? UserData().fromJson(json['data']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}

class UserData implements BaseModel<UserData> {
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

  UserData({
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
  UserData fromJson(Map<String, dynamic> json) {
    return UserData(
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
    return {
      'id': id,
      'username': username,
      'socialMedia': socialMedia,
      'email': email,
      'website': website,
      'description': description,
      'image': image,
      'phoneNumber': phoneNumber,
      'firstname': firstname,
      'lastname': lastname,
      'roleId': roleId,
    };
  }
}

import 'package:core/base_model.dart';
import 'package:flutter/material.dart';

class SignInRequestModel implements BaseModel<SignInRequestModel> {
  String? username;
  String? password;

  SignInRequestModel({this.username, this.password});

  @override
  SignInRequestModel fromJson(Map<String, dynamic> json) {
    return SignInRequestModel(
      username: json['username'],
      password: json['password'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

import 'package:core/base_model.dart';

class SignInResponseModel implements BaseModel<SignInResponseModel> {
  String? status;
  Data? data;

  SignInResponseModel({this.status, this.data});

  @override
  SignInResponseModel fromJson(Map<String, dynamic> json) {
    return SignInResponseModel(
      status: json['status'],
      data: json['data'] != null ? Data().fromJson(json['data']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.toJson(),
    };
  }
}

class Data implements BaseModel<Data> {
  String? accessToken;
  String? refreshToken;
  int? userId;
  List<CityUser>? cityUsers;

  Data({this.accessToken, this.refreshToken, this.userId, this.cityUsers});

  @override
  Data fromJson(Map<String, dynamic> json) {
    return Data(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userId: json['userId'],
      cityUsers: (json['cityUsers'] as List<dynamic>?)
          ?.map((e) => CityUser().fromJson(e))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'userId': userId,
      'cityUsers': cityUsers?.map((e) => e.toJson()).toList(),
    };
  }
}

class CityUser implements BaseModel<CityUser> {
  int? cityId;
  int? cityUserId;

  CityUser({this.cityId, this.cityUserId});

  @override
  CityUser fromJson(Map<String, dynamic> json) {
    return CityUser(
      cityId: json['cityId'],
      cityUserId: json['cityUserId'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'cityId': cityId,
      'cityUserId': cityUserId,
    };
  }
}

import 'package:core/base_model.dart';

class OrtDetailResponseModel implements BaseModel<OrtDetailResponseModel> {
  OrtDetailResponseModel({this.status, this.data});

  String? status;
  OrtDetailDataModel? data;

  @override
  OrtDetailResponseModel fromJson(Map<String, dynamic> json) {
    return OrtDetailResponseModel(
      status: json['status'] as String?,
      data: json['data'] != null
          ? OrtDetailDataModel().fromJson(json['data'])
          : null,
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

class OrtDetailDataModel implements BaseModel<OrtDetailDataModel> {
  int? id;
  String? name;
  String? type;
  String? connectionString;
  bool? isAdminListings;
  String? image;
  String? description;
  String? subtitle;
  String? address;
  String? latitude;
  String? longitude;
  String? phone;
  String? email;
  String? websiteUrl;
  String? openUntil;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  bool? inCityServer;
  bool? hasForum;
  int? parentId;
  List<dynamic>? onlineServices;
  List<dynamic>? topFiveCities;

  @override
  OrtDetailDataModel fromJson(Map<String, dynamic> json) {
    return OrtDetailDataModel()
      ..id = json['id'] as int?
      ..name = json['name'] as String?
      ..type = json['type'] as String?
      ..connectionString = json['connectionString'] as String?
      ..isAdminListings = json['isAdminListings'] as bool?
      ..image = json['image']
      ..description = json['description'] as String?
      ..subtitle = json['subtitle'] as String?
      ..address = json['address'] as String?
      ..latitude = json['latitude'] as String?
      ..longitude = json['longitude'] as String?
      ..phone = json['phone'] as String?
      ..email = json['email'] as String?
      ..websiteUrl = json['websiteUrl'] as String? ??"https://www.landkreis-kusel.de"
      ..openUntil = json['openUntil'] as String?
      ..isActive = json['isActive'] as int?
      ..createdAt = json['createdAt'] as String?
      ..updatedAt = json['updatedAt'] as String?
      ..inCityServer = json['inCityServer'] as bool?
      ..hasForum = json['hasForum'] as bool?
      ..parentId = json['parentId'] as int?
      ..onlineServices = json['onlineServices'] as List<dynamic>?
      ..topFiveCities = json['topFiveCities'] as List<dynamic>?;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'connectionString': connectionString,
      'isAdminListings': isAdminListings,
      'image': image,
      'description': description,
      'subtitle': subtitle,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'email': email,
      'websiteUrl': websiteUrl,
      'openUntil': openUntil,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'inCityServer': inCityServer,
      'hasForum': hasForum,
      'parentId': parentId,
      'onlineServices': onlineServices,
      'topFiveCities': topFiveCities,
    };
  }
}

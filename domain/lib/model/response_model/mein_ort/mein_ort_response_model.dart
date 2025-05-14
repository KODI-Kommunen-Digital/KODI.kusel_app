import 'package:core/base_model.dart';

    class MeinOrtResponseModel extends BaseModel<MeinOrtResponseModel> {
  final String? status;
  final List<Municipality>? data;

  MeinOrtResponseModel({this.status, this.data});

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }

  @override
  MeinOrtResponseModel fromJson(Map<String, dynamic> json) {
    return MeinOrtResponseModel(
      status: json['status'],
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Municipality.fromJson(e))
          .toList(),
    );
  }
}

class Municipality {
  final int? id;
  final String? name;
  final String? type;
  final String? mapImage;
  final String? connectionString;
  final bool? isAdminListings;
  final String? image;
  final String? description;
  final String? subtitle;
  final String? address;
  final String? latitude;
  final String? longitude;
  final String? phone;
  final String? email;
  final String? websiteUrl;
  final String? openUntil;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;
  final bool? inCityServer;
  final bool? hasForum;
  final int? parentId;
  final List<City>? topFiveCities;

  Municipality({
    this.id,
    this.mapImage,
    this.name,
    this.type,
    this.connectionString,
    this.isAdminListings,
    this.image,
    this.description,
    this.subtitle,
    this.address,
    this.latitude,
    this.longitude,
    this.phone,
    this.email,
    this.websiteUrl,
    this.openUntil,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.inCityServer,
    this.hasForum,
    this.parentId,
    this.topFiveCities,
  });

  factory Municipality.fromJson(Map<String, dynamic> json) {
    return Municipality(
      id: json['id'],
      mapImage: json['mapImage'],
      name: json['name'],
      type: json['type'],
      connectionString: json['connectionString'],
      isAdminListings: json['isAdminListings'],
      image: json['image'] ,
      description: json['description'],
      subtitle: json['subtitle'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      phone: json['phone'],
      email: json['email'],
      websiteUrl: json['websiteUrl'],
      openUntil: json['openUntil'],
      isActive: json['isActive'] == 1,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      inCityServer: json['inCityServer'],
      hasForum: json['hasForum'],
      parentId: json['parentId'],
      topFiveCities: (json['topFiveCities'] as List<dynamic>?)
          ?.map((e) => City.fromJson(e))
          .toList(),
    );
  }

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
      'isActive': isActive == true ? 1 : 0,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'inCityServer': inCityServer,
      'hasForum': hasForum,
      'parentId': parentId,
      'topFiveCities': topFiveCities?.map((e) => e.toJson()).toList(),
    };
  }
}

class City {
  final int? id;
  final String? name;
  final String? type;
  final String? connectionString;
  final bool? isAdminListings;
  final String? image;
  final String? description;
  final String? subtitle;
  final String? address;
  final String? latitude;
  final String? longitude;
  final String? phone;
  final String? email;
  final String? websiteUrl;
  final String? openUntil;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;
  final bool? inCityServer;
  final bool? hasForum;
  final int? parentId;

  City({
    this.id,
    this.name,
    this.type,
    this.connectionString,
    this.isAdminListings,
    this.image,
    this.description,
    this.subtitle,
    this.address,
    this.latitude,
    this.longitude,
    this.phone,
    this.email,
    this.websiteUrl,
    this.openUntil,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.inCityServer,
    this.hasForum,
    this.parentId,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      connectionString: json['connectionString'],
      isAdminListings: json['isAdminListings'],
      image: json['image'],
      description: json['description'],
      subtitle: json['subtitle'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      phone: json['phone'],
      email: json['email'],
      websiteUrl: json['websiteUrl'],
      openUntil: json['openUntil'],
      isActive: json['isActive'] == 1,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      inCityServer: json['inCityServer'],
      hasForum: json['hasForum'],
      parentId: json['parentId'],
    );
  }

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
      'isActive': isActive == true ? 1 : 0,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'inCityServer': inCityServer,
      'hasForum': hasForum,
      'parentId': parentId,
    };
  }
}

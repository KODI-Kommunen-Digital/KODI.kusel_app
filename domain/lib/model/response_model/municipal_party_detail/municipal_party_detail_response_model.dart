import 'package:core/base_model.dart';

class MunicipalPartyDetailResponseModel implements BaseModel<MunicipalPartyDetailResponseModel> {
  final String? status;
  final MunicipalPartyDetailDataModel? data;

  MunicipalPartyDetailResponseModel({
    this.status,
    this.data,
  });

  @override
  MunicipalPartyDetailResponseModel fromJson(Map<String, dynamic> json) {
    return MunicipalPartyDetailResponseModel(
      status: json['status'],
      data: json['data'] != null ? MunicipalPartyDetailDataModel.fromJson(json['data']) : null,
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

class MunicipalPartyDetailDataModel {
  final int? id;
  final String? name;
  final String? type;
  final String? connectionString;
  final bool? isAdminListings;
  final String? image;
  final String? description;
  final String? address;
  final String? latitude;
  final String? longitude;
  final String? phone;
  final String? email;
  final String? websiteUrl;
  final String? openUntil;
  final int? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? inMunicipalDetailCityModelServer;
  final bool? hasForum;
  final int? parentId;
  final List<OnlineService>? onlineServices;
  final List<MunicipalDetailCityModel>? topFiveCities;
  final String? mapImage;

  MunicipalPartyDetailDataModel({
    this.id,
    this.name,
    this.type,
    this.connectionString,
    this.isAdminListings,
    this.image,
    this.description,
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
    this.inMunicipalDetailCityModelServer,
    this.hasForum,
    this.parentId,
    this.onlineServices,
    this.topFiveCities,
    this.mapImage
  });

  factory MunicipalPartyDetailDataModel.fromJson(Map<String, dynamic> json) {
    return MunicipalPartyDetailDataModel(
      id: json['id'],
      mapImage: json['mapImage'],
      name: json['name'],
      type: json['type'],
      connectionString: json['connectionString'],
      isAdminListings: json['isAdminListings'],
      image: json['image'] ,
      description: json['description'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      phone: json['phone'],
      email: json['email'],
      websiteUrl: json['websiteUrl'],
      openUntil: json['openUntil'],
      isActive: json['isActive'],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      inMunicipalDetailCityModelServer: json['inMunicipalDetailCityModelServer'],
      hasForum: json['hasForum'],
      parentId: json['parentId'],
      onlineServices: json['onlineServices'] != null
          ? (json['onlineServices'] as List).map((e) => OnlineService.fromJson(e)).toList()
          : [],
      topFiveCities: json['topFiveCities'] != null
          ? (json['topFiveCities'] as List).map((e) => MunicipalDetailCityModel.fromJson(e)).toList()
          : [],
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
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'email': email,
      'websiteUrl': websiteUrl,
      'openUntil': openUntil,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'inMunicipalDetailCityModelServer': inMunicipalDetailCityModelServer,
      'hasForum': hasForum,
      'parentId': parentId,
      'onlineServices': onlineServices?.map((e) => e.toJson()).toList(),
      'topFiveCities': topFiveCities?.map((e) => e.toJson()).toList(),
    };
  }
}

class OnlineService {
  final int? id;
  final String? title;
  final String? description;
  final String? linkUrl;
  final String? iconUrl;
  final int? displayOrder;
  final int? isActive;

  OnlineService({
    this.id,
    this.title,
    this.description,
    this.linkUrl,
    this.iconUrl,
    this.displayOrder,
    this.isActive,
  });

  factory OnlineService.fromJson(Map<String, dynamic> json) {
    return OnlineService(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      linkUrl: json['linkUrl'],
      iconUrl: json['iconUrl'],
      displayOrder: json['displayOrder'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'linkUrl': linkUrl,
      'iconUrl': iconUrl,
      'displayOrder': displayOrder,
      'isActive': isActive,
    };
  }
}

class MunicipalDetailCityModel {
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
  final int? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? inMunicipalDetailCityModelServer;
  final bool? hasForum;
  final int? parentId;


  MunicipalDetailCityModel({
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
    this.inMunicipalDetailCityModelServer,
    this.hasForum,
    this.parentId,
  });

  factory MunicipalDetailCityModel.fromJson(Map<String, dynamic> json) {
    return MunicipalDetailCityModel(
      id: json['id'],
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
      isActive: json['isActive'],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      inMunicipalDetailCityModelServer: json['inMunicipalDetailCityModelServer'],
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
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'inMunicipalDetailCityModelServer': inMunicipalDetailCityModelServer,
      'hasForum': hasForum,
      'parentId': parentId,
    };
  }
}

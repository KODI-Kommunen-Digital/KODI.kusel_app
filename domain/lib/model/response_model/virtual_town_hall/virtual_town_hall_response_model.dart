import 'package:core/base_model.dart';

class VirtualTownHallResponseModel extends BaseModel<VirtualTownHallResponseModel> {
  String? status;
  DistrictData? data;

  VirtualTownHallResponseModel({this.status, this.data});

  @override
  VirtualTownHallResponseModel fromJson(Map<String, dynamic> json) {
    return VirtualTownHallResponseModel(
      status: json['status'] as String?,
      data: json['data'] != null ? DistrictData.fromJson(json['data']) : null,
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

class DistrictData {
  int? id;
  String? name;
  String? type;
  String? connectionString;
  bool? isAdminListings;
  String? image;
  String? description;
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
  List<OnlineService>? onlineServices;
  List<Municipality>? municipalities;

  DistrictData({
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
    this.inCityServer,
    this.hasForum,
    this.parentId,
    this.onlineServices,
    this.municipalities,
  });

  factory DistrictData.fromJson(Map<String, dynamic> json) {
    return DistrictData(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      connectionString: json['connectionString'],
      isAdminListings: json['isAdminListings'],
      image: json['image'],
      description: json['description'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      phone: json['phone'],
      email: json['email'],
      websiteUrl: json['websiteUrl'],
      openUntil: json['openUntil'],
      isActive: json['isActive'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      inCityServer: json['inCityServer'],
      hasForum: json['hasForum'],
      parentId: json['parentId'],
      onlineServices: (json['onlineServices'] as List<dynamic>?)
          ?.map((e) => OnlineService.fromJson(e))
          .toList(),
      municipalities: (json['municipalities'] as List<dynamic>?)
          ?.map((e) => Municipality.fromJson(e))
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
      'onlineServices': onlineServices?.map((e) => e.toJson()).toList(),
      'municipalities': municipalities?.map((e) => e.toJson()).toList(),
    };
  }
}

class OnlineService {
  int? id;
  String? title;
  String? description;
  String? linkUrl;
  String? iconUrl;
  int? displayOrder;
  int? isActive;

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

class Municipality {
  int? id;
  String? name;
  String? type;
  String? connectionString;
  bool? isAdminListings;
  String? image;
  String? description;
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

  Municipality({
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
    this.inCityServer,
    this.hasForum,
    this.parentId,
  });

  factory Municipality.fromJson(Map<String, dynamic> json) {
    return Municipality(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      connectionString: json['connectionString'],
      isAdminListings: json['isAdminListings'],
      image: json['image'],
      description: json['description'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      phone: json['phone'],
      email: json['email'],
      websiteUrl: json['websiteUrl'],
      openUntil: json['openUntil'],
      isActive: json['isActive'],
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
    };
  }
}

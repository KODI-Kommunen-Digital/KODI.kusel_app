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
  final bool? inCityServer;
  final bool? hasForum;
  final int? parentId;

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
    this.inCityServer,
    this.hasForum,
    this.parentId,
  });

  factory MunicipalPartyDetailDataModel.fromJson(Map<String, dynamic> json) {
    return MunicipalPartyDetailDataModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      connectionString: json['connectionString'],
      isAdminListings: json['isAdminListings'],
      image: json['image']!=null?"https://kusel1heidi.obs.eu-de.otc.t-systems.com/${json['image']}":null,
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
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'inCityServer': inCityServer,
      'hasForum': hasForum,
      'parentId': parentId,
    };
  }
}

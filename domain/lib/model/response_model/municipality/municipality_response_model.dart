import 'package:core/base_model.dart';

class MunicipalityResponseModel extends BaseModel<MunicipalityResponseModel> {
  final String? status;
  final List<MunicipalityCities>? data;

  MunicipalityResponseModel({
    this.status,
    this.data,
  });

  @override
  MunicipalityResponseModel fromJson(Map<String, dynamic> json) {
    return MunicipalityResponseModel(
      status: json['status'] ?? '',
      data: (json['data'] as List<dynamic>)
          .map((e) => MunicipalityCities().fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class MunicipalityCities extends BaseModel<MunicipalityCities> {
  int? id;
  String? name;
  String? type;
  String? connectionString;
  bool? isAdminListings;
  String? image;
  String? description;
  String? subtitle;
  String? mapImage;
  String? address;
  double? latitude;
  double? longitude;
  String? phone;
  String? email;
  String? websiteUrl;
  String? openUntil;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? inCityServer;
  bool? hasForum;
  int? parentId;

  MunicipalityCities();

  @override
  MunicipalityCities fromJson(Map<String, dynamic> json) {
    return MunicipalityCities()
      ..id = json['id']
      ..name = json['name']
      ..type = json['type']
      ..connectionString = json['connectionString']
      ..isAdminListings = json['isAdminListings']
      ..image = json['image'] != null
          ? "https://kusel1heidi.obs.eu-de.otc.t-systems.com/${json['image']}"
          : null
      ..description = json['description']
      ..subtitle = json['subtitle']
      ..mapImage = json['mapImage'] != null
          ? "https://kusel1heidi.obs.eu-de.otc.t-systems.com/${json['mapImage']}"
          : null
      ..address = json['address']
      ..latitude = double.tryParse(json['latitude'].toString())
      ..longitude = double.tryParse(json['longitude'].toString())
      ..phone = json['phone']
      ..email = json['email']
      ..websiteUrl = json['websiteUrl']
      ..openUntil = json['openUntil']
      ..isActive = json['isActive'] == 1
      ..createdAt = DateTime.tryParse(json['createdAt'] ?? '')
      ..updatedAt = DateTime.tryParse(json['updatedAt'] ?? '')
      ..inCityServer = json['inCityServer']
      ..hasForum = json['hasForum']
      ..parentId = json['parentId'];
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
      'mapImage': mapImage,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'email': email,
      'websiteUrl': websiteUrl,
      'openUntil': openUntil,
      'isActive': isActive == true ? 1 : 0,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'inCityServer': inCityServer,
      'hasForum': hasForum,
      'parentId': parentId,
    };
  }
}

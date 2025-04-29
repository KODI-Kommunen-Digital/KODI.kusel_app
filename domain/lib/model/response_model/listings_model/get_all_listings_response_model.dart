import 'package:core/base_model.dart';

class GetAllListingsResponseModel
    extends BaseModel<GetAllListingsResponseModel> {
  String? status;
  List<Listing>? data;

  GetAllListingsResponseModel({this.status, this.data});

  @override
  GetAllListingsResponseModel fromJson(Map<String, dynamic> json) {
    return GetAllListingsResponseModel(
      status: json['status'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => Listing.fromJson(item))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class Listing {
  int? id;
  String? title;
  String? description;
  String? createdAt;
  double? lat;
  double?long;
  int? userId;
  String? startDate;
  String? endDate;
  int? statusId;
  int? categoryId;
  int? subcategoryId;
  bool? showExternal;
  int? appointmentId;
  int? viewCount;
  int? externalId;
  String? expiryDate;
  int? sourceId;
  String? website;
  String? address;
  String? email;
  String? phone;
  int? zipcode;
  String? pdf;
  int? cityId;
  int? cityCount;
  List<int>? allCities;
  String? logo;
  int? logoCount;
  List<OtherLogo>? otherLogos;
  bool? isFavorite;
  String? categoryName;

  Listing({
    this.id,
    this.title,
    this.description,
    this.createdAt,
    this.userId,
    this.startDate,
    this.endDate,
    this.statusId,
    this.categoryId,
    this.subcategoryId,
    this.showExternal,
    this.appointmentId,
    this.viewCount,
    this.externalId,
    this.expiryDate,
    this.sourceId,
    this.website,
    this.address,
    this.email,
    this.phone,
    this.zipcode,
    this.pdf,
    this.cityId,
    this.cityCount,
    this.allCities,
    this.logo,
    this.logoCount,
    this.otherLogos,
    this.isFavorite,
    this.lat,
    this.long,
    this.categoryName,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: json['createdAt'],
      userId: json['userId'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      statusId: json['statusId'],
      categoryId: json['categoryId'],
      subcategoryId: json['subcategoryId'],
      showExternal: json['showExternal'],
      appointmentId: json['appointmentId'],
      viewCount: json['viewCount'],
      externalId: json['externalId'],
      expiryDate: json['expiryDate'],
      sourceId: json['sourceId'],
      website: json['website'],
      address: json['address'],
      email: json['email'],
      phone: json['phone'],
      zipcode: json['zipcode'],
      pdf: json['pdf'],
      cityId: json['cityId'],
      cityCount: json['cityCount'],
      allCities:
          json['allCities'] != null ? List<int>.from(json['allCities']) : null,
      logo: json['logo'] != null
          ? "https://kusel1heidi.obs.eu-de.otc.t-systems.com/${json['logo']}"
          : null,
      logoCount: json['logoCount'],
      otherLogos: json['otherLogos'] != null
          ? List<OtherLogo>.from(
              json['otherLogos'].map((x) => OtherLogo.fromJson(x)))
          : null,
      isFavorite: json['isFavorite'],
        lat: json['latitude'],
        long: json['longitude'],
      categoryName: json['categoryName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'userId': userId,
      'startDate': startDate,
      'endDate': endDate,
      'statusId': statusId,
      'categoryId': categoryId,
      'subcategoryId': subcategoryId,
      'showExternal': showExternal,
      'appointmentId': appointmentId,
      'viewCount': viewCount,
      'externalId': externalId,
      'expiryDate': expiryDate,
      'sourceId': sourceId,
      'website': website,
      'address': address,
      'email': email,
      'phone': phone,
      'zipcode': zipcode,
      'pdf': pdf,
      'cityId': cityId,
      'cityCount': cityCount,
      'allCities': allCities,
      'logo': logo,
      'logoCount': logoCount,
      'otherLogos': otherLogos?.map((x) => x.toJson()).toList(),
      'isFavorite': isFavorite,
      'categoryName': categoryName,
    };
  }
}

class OtherLogo {
  int? id;
  String? logo;
  int? listingId;
  int? imageOrder;

  OtherLogo({
    this.id,
    this.logo,
    this.listingId,
    this.imageOrder,
  });

  factory OtherLogo.fromJson(Map<String, dynamic> json) {
    return OtherLogo(
      id: json['id'],
      logo: json['logo'] != null
          ? "https://kusel1heidi.obs.eu-de.otc.t-systems.com/${json['logo']}"
          : null,
      listingId: json['listingId'],
      imageOrder: json['imageOrder'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'logo': logo,
      'listingId': listingId,
      'imageOrder': imageOrder,
    };
  }
}

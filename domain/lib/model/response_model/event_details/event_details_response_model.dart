import 'package:core/base_model.dart';

class GetEventDetailsResponseModel extends BaseModel<GetEventDetailsResponseModel> {
  final String? status;
  final EventData? data;

  GetEventDetailsResponseModel({this.status, this.data});

  @override
  GetEventDetailsResponseModel fromJson(Map<String, dynamic> json) {
    return GetEventDetailsResponseModel(
      status: json['status'],
      data: json['data'] != null
          ? EventData.fromJson(json['data'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data?.toJson(),
  };
}

class EventData {
  final int? id;
  final int? userId;
  final String? title;
  final String? place;
  final String? description;
  final String? externalId;
  final int? categoryId;
  final int? subcategoryId;
  final String? address;
  final String? email;
  final String? phone;
  final String? website;
  final int? price;
  final int? discountPrice;
  final int? statusId;
  final int? sourceId;
  final double? longitude;
  final double? latitude;
  final int? villageId;
  final String? startDate;
  final String? endDate;
  final String? createdAt;
  final String? updatedAt;
  final String? pdf;
  final String? expiryDate;
  final int? zipcode;
  final bool? showExternal;
  final int? appointmentId;
  final List<int>? allCities;
  final int? cityId;
  final String? logo;
  final List<OtherLogo>? otherLogos;

  EventData({
    this.id,
    this.userId,
    this.title,
    this.place,
    this.description,
    this.externalId,
    this.categoryId,
    this.subcategoryId,
    this.address,
    this.email,
    this.phone,
    this.website,
    this.price,
    this.discountPrice,
    this.statusId,
    this.sourceId,
    this.longitude,
    this.latitude,
    this.villageId,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.pdf,
    this.expiryDate,
    this.zipcode,
    this.showExternal,
    this.appointmentId,
    this.allCities,
    this.cityId,
    this.logo,
    this.otherLogos,
  });

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      place: json['place'],
      description: json['description'],
      externalId: json['externalId'],
      categoryId: json['categoryId'],
      subcategoryId: json['subcategoryId'],
      address: json['address'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
      price: json['price'],
      discountPrice: json['discountPrice'],
      statusId: json['statusId'],
      sourceId: json['sourceId'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      villageId: json['villageId'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      pdf: json['pdf'],
      expiryDate: json['expiryDate'],
      zipcode: json['zipcode'],
      showExternal: json['showExternal'],
      appointmentId: json['appointmentId'],
      allCities: json['allCities'] != null
          ? List<int>.from(json['allCities'])
          : null,
      cityId: json['cityId'],
      logo: json['logo'],
      otherLogos: json['otherLogos'] != null
          ? (json['otherLogos'] as List)
          .map((e) => OtherLogo.fromJson(e))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'title': title,
    'place': place,
    'description': description,
    'externalId': externalId,
    'categoryId': categoryId,
    'subcategoryId': subcategoryId,
    'address': address,
    'email': email,
    'phone': phone,
    'website': website,
    'price': price,
    'discountPrice': discountPrice,
    'statusId': statusId,
    'sourceId': sourceId,
    'longitude': longitude,
    'latitude': latitude,
    'villageId': villageId,
    'startDate': startDate,
    'endDate': endDate,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'pdf': pdf,
    'expiryDate': expiryDate,
    'zipcode': zipcode,
    'showExternal': showExternal,
    'appointmentId': appointmentId,
    'allCities': allCities,
    'cityId': cityId,
    'logo': logo,
    'otherLogos':
    otherLogos?.map((logo) => logo.toJson()).toList(),
  };
}

class OtherLogo {
  final int? id;
  final int? imageOrder;
  final int? listingId;
  final String? logo;

  OtherLogo({
    this.id,
    this.imageOrder,
    this.listingId,
    this.logo,
  });

  factory OtherLogo.fromJson(Map<String, dynamic> json) => OtherLogo(
    id: json['id'],
    imageOrder: json['imageOrder'],
    listingId: json['listingId'],
    logo: json['logo'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'imageOrder': imageOrder,
    'listingId': listingId,
    'logo': logo,
  };
}

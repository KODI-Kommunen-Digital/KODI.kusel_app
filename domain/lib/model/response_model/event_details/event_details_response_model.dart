import 'package:core/base_model.dart';

class GetEventDetailsResponseModel
    extends BaseModel<GetEventDetailsResponseModel> {
  final String? status;
  final EventData? data;

  GetEventDetailsResponseModel({this.status, this.data});

  @override
  GetEventDetailsResponseModel fromJson(Map<String, dynamic> json) {
    return GetEventDetailsResponseModel(
      status: json['status'] as String?,
      data: json['data'] != null
          ? EventData.fromJson(json['data'] as Map<String, dynamic>)
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
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      title: json['title'] as String?,
      place: json['place'] as String?,
      description: json['description'] as String?,
      externalId: json['externalId'] as String?,
      categoryId: json['categoryId'] as int?,
      subcategoryId: json['subcategoryId'] as int?,
      address: json['address'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      price: json['price'] as int?,
      discountPrice: json['discountPrice'] as int?,
      statusId: json['statusId'] as int?,
      sourceId: json['sourceId'] as int?,
      longitude: (json['longitude'] as num?)?.toDouble(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      villageId: json['villageId'] as int?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      pdf: json['pdf'] as String?,
      expiryDate: json['expiryDate'] as String?,
      zipcode: json['zipcode'] as int?,
      showExternal: json['showExternal'] as bool?,
      appointmentId: json['appointmentId'] as int?,
      allCities: (json['allCities'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      cityId: json['cityId'] as int?,
      logo: json['logo'] as String?,
      otherLogos: (json['otherLogos'] as List<dynamic>?)
          ?.map((e) => OtherLogo.fromJson(e as Map<String, dynamic>))
          .toList(),
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
    'otherLogos': otherLogos?.map((e) => e.toJson()).toList(),
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
    id: json['id'] as int?,
    imageOrder: json['imageOrder'] as int?,
    listingId: json['listingId'] as int?,
    logo: json['logo'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'imageOrder': imageOrder,
    'listingId': listingId,
    'logo': logo,
  };
}

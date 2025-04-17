import 'package:core/base_model.dart';

class GetEventDetailsResponseModel extends BaseModel<GetEventDetailsResponseModel> {
  String? status;
  EventData? data;

  GetEventDetailsResponseModel({this.status, this.data});

  @override
  GetEventDetailsResponseModel fromJson(Map<String, dynamic> json) {
    return GetEventDetailsResponseModel(
      status: json['status'],
      data: json['data'] != null ? EventData.fromJson(json['data']) : null,
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

class EventData {
  int? id;
  int? userId;
  String? title;
  String? place;
  String? description;
  String? externalId;
  int? categoryId;
  int? subcategoryId;
  String? address;
  String? email;
  String? phone;
  String? website;
  int? price;
  int? discountPrice;
  int? statusId;
  int? sourceId;
  double? longitude;
  double? latitude;
  int? villageId;
  String? startDate;
  String? endDate;
  String? createdAt;
  String? updatedAt;
  String? pdf;
  String? expiryDate;
  int? zipcode;
  bool? showExternal;
  int? appointmentId;
  List<int>? allCities;
  int? cityId;
  String? logo;
  List<OtherLogo>? otherLogos;

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
      longitude: (json['longitude'] as num?)?.toDouble(),
      latitude: (json['latitude'] as num?)?.toDouble(),
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
      allCities: json['allCities'] != null ? List<int>.from(json['allCities']) : null,
      cityId: json['cityId'],
      logo: json['logo'],
      otherLogos: json['otherLogos'] != null
          ? List<OtherLogo>.from(json['otherLogos'].map((x) => OtherLogo.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      'otherLogos': otherLogos?.map((x) => x.toJson()).toList(),
    };
  }
}

class OtherLogo {
  int? id;
  int? imageOrder;
  int? listingId;
  String? logo;

  OtherLogo({
    this.id,
    this.imageOrder,
    this.listingId,
    this.logo,
  });

  factory OtherLogo.fromJson(Map<String, dynamic> json) {
    return OtherLogo(
      id: json['id'],
      imageOrder: json['imageOrder'],
      listingId: json['listingId'],
      logo: json['logo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageOrder': imageOrder,
      'listingId': listingId,
      'logo': logo,
    };
  }
}

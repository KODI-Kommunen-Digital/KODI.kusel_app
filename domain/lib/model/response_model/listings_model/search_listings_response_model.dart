import 'package:core/base_model.dart';

class SearchListingsResponseModel extends BaseModel<SearchListingsResponseModel> {
  String? status;
  List<Listing>? data;

  SearchListingsResponseModel({this.status, this.data});

  @override
  SearchListingsResponseModel fromJson(Map<String, dynamic> json) {
    return SearchListingsResponseModel(
      status: json['status'] as String?,
      data: (json['data'] as List<dynamic>?)?.map((item) => Listing.fromJson(item)).toList(),
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
  int? villageId;
  String? title;
  String? place;
  String? description;
  int? categoryId;
  int? subcategoryId;
  int? statusId;
  String? address;
  String? email;
  String? phone;
  String? website;
  double? price;
  double? discountPrice;
  String? logo;
  double? longitude;
  double? latitude;
  String? zipcode;
  String? endDate;
  String? startDate;

  Listing({
    this.villageId,
    this.title,
    this.place,
    this.description,
    this.categoryId,
    this.subcategoryId,
    this.statusId,
    this.address,
    this.email,
    this.phone,
    this.website,
    this.price,
    this.discountPrice,
    this.logo,
    this.longitude,
    this.latitude,
    this.zipcode,
    this.endDate,
    this.startDate,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      villageId: json['villageId'] as int?,
      title: json['title'] as String?,
      place: json['place'] as String?,
      description: json['description'] as String?,
      categoryId: (json['categoryId'] as num?)?.toInt(),
      subcategoryId: (json['subcategoryId'] as num?)?.toInt(),
      statusId: (json['statusId'] as num?)?.toInt(),
      address: json['address'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      discountPrice: (json['discountPrice'] as num?)?.toDouble(),
      logo: json['logo'] as String?,
      longitude: (json['longitude'] as num?)?.toDouble(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      zipcode: json['zipcode'] as String?,
      endDate: json['endDate'] as String?,
      startDate: json['startDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'villageId': villageId,
      'title': title,
      'place': place,
      'description': description,
      'categoryId': categoryId,
      'subcategoryId': subcategoryId,
      'statusId': statusId,
      'address': address,
      'email': email,
      'phone': phone,
      'website': website,
      'price': price,
      'discountPrice': discountPrice,
      'logo': logo,
      'longitude': longitude,
      'latitude': latitude,
      'zipcode': zipcode,
      'endDate': endDate,
      'startDate': startDate,
    };
  }
}

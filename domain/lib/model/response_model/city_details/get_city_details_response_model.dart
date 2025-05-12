import 'package:core/base_model.dart';

class GetCityDetailsResponseModel extends BaseModel<GetCityDetailsResponseModel> {
  final String? status;
  final List<City>? data;

  GetCityDetailsResponseModel({this.status, this.data});

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }

  @override
  GetCityDetailsResponseModel fromJson(Map<String, dynamic> json) {
    return GetCityDetailsResponseModel(
      status: json['status'],
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => City.fromJson(e))
          .toList(),
    );
  }
}

class City {
  final int? id;
  final String? name;
  final String? image;
  final bool? hasForum;

  City({this.id, this.name, this.image, this.hasForum});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      image: json['image'] != null
          ? "https://kusel1heidi.obs.eu-de.otc.t-systems.com/${json['image']}"
          : null,
      hasForum: json['hasForum'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'hasForum': hasForum,
    };
  }
}

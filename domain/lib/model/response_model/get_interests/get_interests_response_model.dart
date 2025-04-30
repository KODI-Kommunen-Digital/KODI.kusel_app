import 'package:core/base_model.dart';

class GetInterestsResponseModel implements BaseModel<GetInterestsResponseModel> {
  String? status;
  List<Interest>? data;

  GetInterestsResponseModel({this.status, this.data});

  @override
  GetInterestsResponseModel fromJson(Map<String, dynamic> json) {
    return GetInterestsResponseModel(
      status: json['status'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => Interest.fromJson(item as Map<String, dynamic>))
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

class Interest {
  final int? id;
  final String? name;
  final int? available;
  final int? interestOrder;

  Interest({this.id, this.name, this.available, this.interestOrder});

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      id: json['id'] as int?,
      name: json['name'] as String?,
      available: json['available'] as int?,
      interestOrder: json['interest_order'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'available': available,
      'interest_order': interestOrder,
    };
  }
}

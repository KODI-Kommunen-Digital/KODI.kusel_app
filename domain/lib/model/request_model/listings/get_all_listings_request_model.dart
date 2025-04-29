import 'dart:convert';
import 'package:core/base_model.dart';

class GetAllListingsRequestModel extends BaseModel<GetAllListingsRequestModel> {
  final int? pageNo;
  final int? pageSize;
  final bool? sortByStartDate;
  final String? statusId;
  final String? categoryId;
  final String? subcategoryId;
  final String? cityId;
  final String? translate;
  final String? startAfterDate;
  final String? endBeforeDate;
  final double? centerLatitude;
  final double? centerLongitude;
  final int? radius;

  GetAllListingsRequestModel({
    this.pageNo,
    this.pageSize,
    this.sortByStartDate,
    this.statusId,
    this.categoryId,
    this.subcategoryId,
    this.cityId,
    this.translate,
    this.startAfterDate,
    this.endBeforeDate,
    this.centerLatitude,
    this.centerLongitude,
    this.radius,
  });

  @override
  GetAllListingsRequestModel fromJson(Map<String, dynamic> json) {
    return GetAllListingsRequestModel(
      pageNo: json['pageNo'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      sortByStartDate: json['sortByStartDate'] ?? false,
      statusId: json['statusId'] ?? '',
      categoryId: json['categoryId'] ?? '',
      subcategoryId: json['subcategoryId'] ?? '',
      cityId: json['cityId'] ?? '',
      translate: json['translate'] ?? '',
      startAfterDate: json['startAfterDate'] ?? '',
      endBeforeDate: json['endBeforeDate'] ?? '',
      centerLatitude: (json['centerLatitude'] as num?)?.toDouble(),
      centerLongitude: (json['centerLongitude'] as num?)?.toDouble(),
      radius: json['radius'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = {
      'pageNo': pageNo,
      'pageSize': pageSize,
      'sortByStartDate': sortByStartDate,
      'statusId': statusId,
      'categoryId': categoryId,
      'subcategoryId': subcategoryId,
      'cityId': cityId,
      'translate': translate,
      'startAfterDate': startAfterDate,
      'endBeforeDate': endBeforeDate,
      'centerLatitude': centerLatitude,
      'centerLongitude': centerLongitude,
      'radius': radius,
    };
    data.removeWhere((key, value) =>
    value == null || (value is String && value.isEmpty));
    return data;
  }

  @override
  String toString() => jsonEncode(toJson());
}

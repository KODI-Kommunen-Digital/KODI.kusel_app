import 'dart:convert';

class ListingsParams {
  final int pageNo;
  final int pageSize;
  final bool sortByStartDate;
  final String statusId;
  final String categoryId;
  final String subcategoryId;
  final String cityId;
  final String translate;
  final String startAfterDate;
  final String endBeforeDate;

  ListingsParams({
    required this.pageNo,
    required this.pageSize,
    required this.sortByStartDate,
    required this.statusId,
    required this.categoryId,
    required this.subcategoryId,
    required this.cityId,
    required this.translate,
    required this.startAfterDate,
    required this.endBeforeDate,
  });

  factory ListingsParams.fromJson(Map<String, dynamic> json) {
    return ListingsParams(
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}

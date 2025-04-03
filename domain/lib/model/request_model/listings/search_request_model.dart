import 'dart:convert';
import 'package:core/base_model.dart';

class SearchRequestModel extends BaseModel<SearchRequestModel> {

  final String searchQuery;

  SearchRequestModel({
    required this.searchQuery,
  });

  @override
  SearchRequestModel fromJson(Map<String, dynamic> json) {
    return SearchRequestModel(
      searchQuery: json['searchQuery'] ?? "",
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'searchQuery': searchQuery
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}

import 'package:core/base_model.dart';

class GetAllCategoriesResponseModel extends BaseModel<GetAllCategoriesResponseModel> {
  String? status;
  List<Category>? data;

  GetAllCategoriesResponseModel({this.status, this.data});

  @override
  GetAllCategoriesResponseModel fromJson(Map<String, dynamic> json) {
    return GetAllCategoriesResponseModel(
      status: json['status'] as String?,
      data: (json['data'] as List<dynamic>?)?.map((item) => Category.fromJson(item)).toList(),
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

class Category {
  int? id;
  String? name;
  String? imageUrl;
  int? noOfSubcategories;

  Category({this.id, this.name, this.noOfSubcategories, this.imageUrl});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int?,
      name: json['name'] as String?,
      imageUrl: json['imageUrl'] as String?,
      noOfSubcategories: json['noOfSubcategories'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'noOfSubcategories': noOfSubcategories,
    };
  }
}
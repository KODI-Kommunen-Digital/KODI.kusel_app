import 'package:core/base_model.dart';

class FeedBackRequestModel implements BaseModel<FeedBackRequestModel> {
  final String? title;
  final String? description;

  FeedBackRequestModel({this.title, this.description});

  @override
  FeedBackRequestModel fromJson(Map<String, dynamic> json) {
    return FeedBackRequestModel(
      title: json['title'] as String?,
      description: json['description'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }
}

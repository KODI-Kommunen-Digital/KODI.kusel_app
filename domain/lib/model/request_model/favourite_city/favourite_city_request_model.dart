import 'package:core/base_model.dart';

class GetFavouriteCitiesRequestModel
    implements BaseModel<GetFavouriteCitiesRequestModel> {
  final int? userId;

  GetFavouriteCitiesRequestModel({this.userId});

  @override
  GetFavouriteCitiesRequestModel fromJson(Map<String, dynamic> json) {
    return GetFavouriteCitiesRequestModel(userId: json['userId']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'userId': userId};
  }
}

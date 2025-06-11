import 'package:core/base_model.dart';

class GetFavoritesRequestModel implements BaseModel<GetFavoritesRequestModel> {
  String? userId;
  String? translate;

  GetFavoritesRequestModel({this.userId, this.translate});

  @override
  GetFavoritesRequestModel fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {"userId": userId, "translate": translate};
  }
}

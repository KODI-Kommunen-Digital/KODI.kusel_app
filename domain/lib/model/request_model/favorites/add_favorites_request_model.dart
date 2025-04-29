import 'package:core/base_model.dart';

class AddFavoritesRequestModel implements BaseModel<AddFavoritesRequestModel> {
  String? cityId;
  String? listingId;
  String? userId;

  AddFavoritesRequestModel({this.userId, this.cityId, this.listingId});

  @override
  AddFavoritesRequestModel fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "cityId": cityId,
      "listingId": listingId
    };
  }
}

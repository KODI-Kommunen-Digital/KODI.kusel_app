import 'package:core/base_model.dart';

class DigifitFavRequestModel implements BaseModel<DigifitFavRequestModel>{

  String translate;

  DigifitFavRequestModel({required this.translate});
  @override
  DigifitFavRequestModel fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
   return {
     "translate":translate
   };
  }

}
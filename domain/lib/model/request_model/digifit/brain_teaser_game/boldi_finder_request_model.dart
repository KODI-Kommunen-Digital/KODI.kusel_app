import 'package:core/base_model.dart';

class BoldiFinderRequestModel extends BaseModel<BoldiFinderRequestModel> {
  final int gameId;
  final int levelId;

  BoldiFinderRequestModel({
    required this.gameId,
    required this.levelId,
  });

  @override
  BoldiFinderRequestModel fromJson(Map<String, dynamic> json) => this;

  @override
  Map<String, dynamic> toJson() => {
        'gameId': gameId,
        'levelId': levelId,
      };
}

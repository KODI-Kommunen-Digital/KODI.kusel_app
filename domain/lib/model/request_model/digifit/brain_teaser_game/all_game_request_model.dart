import 'package:core/base_model.dart';

class AllGamesRequestModel extends BaseModel<AllGamesRequestModel> {
  final int gameId;
  final int levelId;

  AllGamesRequestModel({
    required this.gameId,
    required this.levelId,
  });

  @override
  AllGamesRequestModel fromJson(Map<String, dynamic> json) => this;

  @override
  Map<String, dynamic> toJson() => {
        'gameId': gameId,
        'levelId': levelId,
      };
}

class OrtDetailScreenParams{

  String ortId;
  Function(bool? isFav, int? id) onFavSuccess;
  OrtDetailScreenParams({required this.ortId, required this.onFavSuccess});

}
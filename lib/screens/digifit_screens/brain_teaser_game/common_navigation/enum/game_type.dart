import '../../../../../app_router.dart';

enum GameType {
  boldiFinder(1, boldiFinderScreenPath),
  matheJagd(2, matheJagdScreenPath),
  flipCatch(3, flipCatchScreenPath),
  digitDash(4, digitDashScreenPath),
  bilderSpiel(5, bilderSpielScreenPath);

  final int id;
  final String routePath;

  const GameType(this.id, this.routePath);

  static GameType? fromId(int id) {
    try {
      return GameType.values.firstWhere((type) => type.id == id);
    } catch (_) {
      return null;
    }
  }
}

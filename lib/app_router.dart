import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/splash/splash_screen.dart';

final mobileRouterProvider = Provider((ref) => GoRouter(routes: goRouteList));

const splashScreenPath = "/";

List<RouteBase> goRouteList = [
  GoRoute(
      path: splashScreenPath,
      builder: (context, state) {
        return SplashScreen();
      })
];

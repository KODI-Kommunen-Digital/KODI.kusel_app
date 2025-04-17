import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kusel/screens/auth/forgot_password/forgot_password_screen.dart';
import 'package:kusel/screens/auth/signin/signin_screen.dart';
import 'package:kusel/screens/auth/signup/signup_screen.dart';
import 'package:kusel/screens/dashboard/dashboard_screen.dart';
import 'package:kusel/screens/event/event_screen_controller.dart';
import 'package:kusel/screens/events_listing/event_list_screen.dart';
import 'package:kusel/screens/events_listing/event_list_screen_parameter.dart';
import 'package:kusel/screens/fliter_screen/filter_screen.dart';
import 'package:kusel/screens/highlight/highlight_screen.dart';
import 'package:kusel/screens/event/event_screen.dart';
import 'package:kusel/screens/splash/splash_screen.dart';
import 'package:kusel/screens/sub_category/sub_category_screen.dart';
import 'package:kusel/screens/sub_category/sub_category_screen_parameter.dart';

final mobileRouterProvider = Provider((ref) => GoRouter(routes: goRouteList));

const splashScreenPath = "/";
const signInScreenPath = "/signInScreen";
const signUpScreenPath = "/signUpScreen";
const dashboardScreenPath = "/dashboardScreenPath";
const eventScreenPath = "/eventScreenPath";
const forgotPasswordPath = "/forgotPasswordPath";
const highlightScreenPath = "/highlightScreenPath";
const subCategoryScreenPath = "/subCategoryPath";
const eventListScreenPath = "/eventListScreenPath";
const filterScreenPath = "/filterScreenPath";

List<RouteBase> goRouteList = [
  GoRoute(
      path: splashScreenPath,
      builder: (context, state) {
        return SplashScreen();
      }),
  GoRoute(
      path: signInScreenPath,
      builder: (context, state) {
        return SignInScreen();
      }),
  GoRoute(
      path: signUpScreenPath,
      builder: (context, state) {
        return SignupScreen();
      }),
  GoRoute(
      path: dashboardScreenPath,
      builder: (context, state) {
        return DashboardScreen();
      }),
  GoRoute(
      path: eventScreenPath,
      builder: (context, state) {
        return EventScreen(
            eventScreenParams: state.extra as EventScreenParams
        );
      }),
  GoRoute(
      path: eventListScreenPath,
      builder: (context, state) {
        return EventListScreen(
            eventListScreenParameter:
            state.extra as EventListScreenParameter);
      }),
  GoRoute(
      path: forgotPasswordPath,
      builder: (context, state) {
        return ForgotPasswordScreen();
      }),
  GoRoute(
      path: subCategoryScreenPath,
      builder: (context, state) {
        return SubCategoryScreen(
            subCategoryScreenParameters:
                state.extra as SubCategoryScreenParameters);
      }),
  GoRoute(
      path: highlightScreenPath,
      builder: (context, state) {
        return HighlightScreen();
      }),
  GoRoute(
      path: filterScreenPath,
      builder: (context, state) {
        return FilterScreen();
      }),
];

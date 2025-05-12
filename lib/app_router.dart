import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kusel/screens/all_event/all_event_screen.dart';
import 'package:kusel/screens/auth/forgot_password/forgot_password_screen.dart';
import 'package:kusel/screens/auth/signin/signin_screen.dart';
import 'package:kusel/screens/auth/signup/signup_screen.dart';
import 'package:kusel/screens/dashboard/dashboard_screen.dart';
import 'package:kusel/screens/event/event_detail_screen.dart';
import 'package:kusel/screens/event/event_detail_screen_controller.dart';
import 'package:kusel/screens/events_listing/selected_event_list_screen.dart';
import 'package:kusel/screens/events_listing/selected_event_list_screen_parameter.dart';
import 'package:kusel/screens/favorite/favorites_list_screen.dart';
import 'package:kusel/screens/feedback/feedback_screen.dart';
import 'package:kusel/screens/fliter_screen/filter_screen.dart';
import 'package:kusel/screens/highlight/highlight_screen.dart';
import 'package:kusel/screens/mobility_screen/mobility_screen.dart';
import 'package:kusel/screens/municipal_party_detail/municipal_detail_screen.dart';
import 'package:kusel/screens/municipal_party_detail/widget/municipal_detail_screen_params.dart';
import 'package:kusel/screens/onboarding/onboarding_finish_page.dart';
import 'package:kusel/screens/onboarding/onboarding_loading_page.dart';
import 'package:kusel/screens/onboarding/onboarding_screen.dart';
import 'package:kusel/screens/participate_screen/participate_screen.dart';
import 'package:kusel/screens/profile/profile_screen.dart';
import 'package:kusel/screens/search_result/search_result_screen.dart';
import 'package:kusel/screens/search_result/search_result_screen_parameter.dart';
import 'package:kusel/screens/splash/splash_screen.dart';
import 'package:kusel/screens/sub_category/sub_category_screen.dart';
import 'package:kusel/screens/sub_category/sub_category_screen_parameter.dart';
import 'package:kusel/screens/virtual_town_hall/virtual_town_hall_screen.dart';

final mobileRouterProvider = Provider((ref) => GoRouter(routes: goRouteList));

const splashScreenPath = "/";
const signInScreenPath = "/signInScreen";
const signUpScreenPath = "/signUpScreen";
const dashboardScreenPath = "/dashboardScreenPath";
const eventScreenPath = "/eventScreenPath";
const forgotPasswordPath = "/forgotPasswordPath";
const highlightScreenPath = "/highlightScreenPath";
const subCategoryScreenPath = "/subCategoryPath";
const selectedEventListScreenPath = "/eventListScreenPath";
const filterScreenPath = "/filterScreenPath";
const searchResultScreenPath = "/searchResultScreenPath";
const onboardingScreenPath = "/onboardingScreenPath";
const onboardingLoadingPagePath = "/onboardingLoadingPagePath";
const onboardingFinishPagePath = "/onboardingFinishPagePath";
const profileScreenPath = "/profileScreenPath";
const favoritesListScreenPath = "/favoritesListScreenPath";
const feedbackScreenPath = "/feedbackScreenPath";
const allEventScreenPath = "/allEventScreen";
const virtualTownHallScreenPath = "/virtualTownHallScreenPath";
const municipalDetailScreenPath = "/municipalDetailScreenPath";
const mobilityScreenPath = "/mobilityScreenPath";
const participateScreenPath = "/participateScreenPath";

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
        return EventDetailScreen(
            eventScreenParams: state.extra as EventDetailScreenParams);
      }),
  GoRoute(
      path: selectedEventListScreenPath,
      builder: (context, state) {
        return SelectedEventListScreen(
            eventListScreenParameter:
                state.extra as SelectedEventListScreenParameter);
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
  GoRoute(
      path: searchResultScreenPath,
      builder: (context, state) {
        return SearchResultScreen(
            searchResultScreenParameter:
                state.extra as SearchResultScreenParameter);
      }),
  GoRoute(
      path: onboardingScreenPath,
      builder: (context, state) {
        return OnboardingScreen();
      }),
  GoRoute(
      path: onboardingLoadingPagePath,
      builder: (context, state) {
        return OnboardingLoadingPage();
      }),
  GoRoute(
      path: onboardingFinishPagePath,
      builder: (context, state) {
        return OnboardingFinishPage();
      }),
  GoRoute(
      path: profileScreenPath,
      builder: (context, state) {
        return ProfileScreen();
      }),
  GoRoute(
      path: favoritesListScreenPath,
      builder: (context, state) {
        return FavoritesListScreen();
      }),
  GoRoute(
      path: feedbackScreenPath,
      builder: (context, state) {
        return FeedbackScreen();
      }),
  GoRoute(
      path: allEventScreenPath,
      builder: (context, state) {
        return AllEventScreen();
      }),
  GoRoute(
      path: virtualTownHallScreenPath,
      builder: (context, state) {
        return VirtualTownHallScreen();
      }),
  GoRoute(
      path: municipalDetailScreenPath,
      builder: (context, state) {
        return MunicipalDetailScreen(
          municipalDetailScreenParams:
              state.extra as MunicipalDetailScreenParams,
        );
      }),
  GoRoute(
      path: virtualTownHallScreenPath,
      builder: (context, state) {
        return VirtualTownHallScreen();
      }),
  GoRoute(
      path: mobilityScreenPath,
      builder: (context, state) {
        return MobilityScreen();
      }),
  GoRoute(
      path: participateScreenPath,
      builder: (context, state) {
        return ParticipateScreen();
      })
];

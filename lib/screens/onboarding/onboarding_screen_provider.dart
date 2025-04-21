import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/onboarding/onboarding_screen_state.dart';

final onboardingScreenProvider = StateNotifierProvider.autoDispose<
    OnboardingScreenController,
    OnboardingScreenState>((ref) => OnboardingScreenController());

class OnboardingScreenController extends StateNotifier<OnboardingScreenState> {
  OnboardingScreenController() : super(OnboardingScreenState.empty());
  PageController pageController = PageController();

  void initializerPageController() {
    pageController = PageController(
      initialPage: state.selectedPageIndex,
    );
  }

  void nextPage() {
    if (pageController.hasClients) {
      final nextPage = state.selectedPageIndex + 1;
      if (nextPage < 5) {
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void onBackPress() {
    if (pageController.hasClients) {
      final previousPage = state.selectedPageIndex - 1;
      if (previousPage >= 0) {
        pageController.animateToPage(
          previousPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void onSkipPress() {
    if (pageController.hasClients) {
      final nextPage = state.selectedPageIndex + 1;
      if (nextPage < 5) {
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void updateSelectedPageIndex(int index) {
    state = state.copyWith(selectedPageIndex: index);
  }

  void startLoadingTimer(Function() callBack) {
    Future.delayed(const Duration(seconds: 5), () {
      callBack();
    });
  }
}

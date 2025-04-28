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
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController yourLocationEditingController = TextEditingController();
  GlobalKey<FormState> onboardingNameFormKey = GlobalKey<FormState>();

  void initializerPageController() {
    pageController = PageController(
      initialPage: state.selectedPageIndex,
    );
  }

  void updateOnboardingType(OnBoardingType onBoardingType) {
    final isResidentSelected = onBoardingType == OnBoardingType.resident;
    final alreadySelected = isResidentSelected ? state.isResident : state.isTourist;

    state = state.copyWith(
      isResident: isResidentSelected ? !alreadySelected : false,
      isTourist: !isResidentSelected ? !alreadySelected : false,
    );
  }

  void updateOnboardingFamilyType(OnBoardingFamilyType onBoardingFamilyType) {
    bool alreadySelected;
    switch (onBoardingFamilyType) {
      case OnBoardingFamilyType.single:
        alreadySelected = state.isSingle;
        break;
      case OnBoardingFamilyType.withTwo:
        alreadySelected = state.isForTwo;
        break;
      case OnBoardingFamilyType.withMyFamily:
        alreadySelected = state.isWithFamily;
        break;
    }

    state = state.copyWith(
      isSingle: onBoardingFamilyType == OnBoardingFamilyType.single ? !alreadySelected : false,
      isForTwo: onBoardingFamilyType == OnBoardingFamilyType.withTwo ? !alreadySelected : false,
      isWithFamily: onBoardingFamilyType == OnBoardingFamilyType.withMyFamily ? !alreadySelected : false,
    );
  }

  void updateCompanionType(OnBoardingCompanionType onBoardingCompanionType) {
    final isWithDogSelected = onBoardingCompanionType == OnBoardingCompanionType.withDog;
    final alreadySelected = isWithDogSelected ? state.isWithDog : state.isBarrierearm;

    state = state.copyWith(
      isWithDog: isWithDogSelected ? !alreadySelected : false,
      isBarrierearm: !isWithDogSelected ? !alreadySelected : false,
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

  void onSkipPress(VoidCallback onLastSkipPress) {
    if (!pageController.hasClients) return;
    final currentPage = state.selectedPageIndex;
    final nextPage = currentPage + 1;
    if (currentPage == 4) {
      onLastSkipPress();
    } else if (currentPage == 2) {
      pageController.animateToPage(
        nextPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else if (nextPage < 5) {
      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
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

enum OnBoardingType { resident, tourist }

enum OnBoardingFamilyType { single, withTwo, withMyFamily }

enum OnBoardingCompanionType { withDog, barrierearm }

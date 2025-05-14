import 'dart:async';
import 'dart:ui';

import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/splash/splash_screen_state.dart';

final splashScreenProvider =
    StateNotifierProvider.autoDispose<SplashScreenProvider, SplashScreenState>(
        (ref) => SplashScreenProvider(
            sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class SplashScreenProvider extends StateNotifier<SplashScreenState> {
  SharedPreferenceHelper sharedPreferenceHelper;

  SplashScreenProvider({required this.sharedPreferenceHelper})
      : super(SplashScreenState.empty());

  void startTimer(void Function(bool isOnBoardingDone) callBack) {
    bool isOnboardingDone = onBoardingStatus();
    Timer(const Duration(seconds: 2), () {
      callBack(isOnboardingDone);
    });
  }


  bool onBoardingStatus() {
    String onBoardingStatus =
        sharedPreferenceHelper.getString(onboardingKey) ?? "false";
    bool isOnBoarded = onBoardingStatus == 'true';
    return isOnBoarded;
  }
}

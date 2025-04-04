import 'dart:async';

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

  startTimer(Function(bool isLogin) callBack) {
    Timer(Duration(seconds: 2), () async {
      final token = sharedPreferenceHelper.getString(tokenKey);
      if (token == null) {
        callBack(false);
      } else {
        callBack(true);
      }
    });
  }
}

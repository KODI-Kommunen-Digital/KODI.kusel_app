import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/navigator/navigator.dart';
import 'package:kusel/screens/splash/splash_state.dart';

final splashScreenProvider =
    StateNotifierProvider<SplashController, SplashState>(
        (ref) => SplashController(ref: ref));

class SplashController extends StateNotifier<SplashState> {
  Ref ref;

  SplashController({required this.ref}) : super(SplashState.empty());

  startTimer(void Function() callBack) {
    Timer(Duration(seconds: 2), callBack);
  }
}

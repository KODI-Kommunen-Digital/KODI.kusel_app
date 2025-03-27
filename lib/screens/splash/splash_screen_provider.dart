import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/screens/splash/splash_screen_state.dart';

import '../../navigation/navigation.dart';

final splashScreenProvider = StateNotifierProvider.autoDispose<
    SplashScreenProvider,
    SplashScreenState>((ref) => SplashScreenProvider(ref: ref));

class SplashScreenProvider extends StateNotifier<SplashScreenState> {
  Ref ref;
  SplashScreenProvider({required this.ref}) : super(SplashScreenState.empty());

  startTimer(void Function() callBack) {
    Timer(Duration(seconds: 2), callBack);
  }
}

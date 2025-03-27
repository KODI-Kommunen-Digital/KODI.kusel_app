import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/splash/splash_screen_provider.dart';


class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _State();
}


class _State extends ConsumerState<SplashScreen> {

  @override
  void initState() {
    Timer(const Duration(milliseconds: 1500), () {
      ref.read(splashScreenProvider.notifier).navigateToNextScreen(context);
    });    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Color(0xFF18204F),
          child: Center(
              child: Text(
                "Kusel",
                style: TextStyle(
                    fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
              )),
        )
    );
  }


}

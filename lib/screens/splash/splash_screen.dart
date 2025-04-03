import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/splash/splash_screen_provider.dart';
import 'package:kusel/theme_manager/colors.dart';


class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _State();
}


class _State extends ConsumerState<SplashScreen> {

  @override
  void initState() {
    Future.microtask(() {
      ref.read(splashScreenProvider.notifier).startTimer(() {
        ref.read(navigationProvider).removeAllAndNavigate(
            context: context, path: dashboardScreenPath);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: lightThemeSecondaryColor,
          child: Center(
              child: Text(
                AppLocalizations.of(context).app_title,
                style: TextStyle(
                    fontSize: 40,
                    color: lightThemeWhiteColor,
                    fontWeight: FontWeight.bold),
              )),
        )
    );
  }


}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/screens/splash/splash_controller.dart';
import '../../common_widgets/text_styles.dart';
import '../../localization_manager.dart';
import '../../navigator/navigator.dart' show navigationProvider;

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
        ref
            .read(navigationProvider)
            .removeCurrentAndNavigate(context: context, path: signInScreenPath);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: InkWell(
        onTap: () {
          ref
              .read(localeManagerProvider.notifier)
              .updateCurrentSelectedLocale(Locale('de'));
        },
        child: textRegularPoppins(text: "Kusel App"),
      )),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common_widgets/text_styles.dart';
import '../../localization_manager.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _State();
}

class _State extends ConsumerState<SplashScreen> {
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
        child: regularPoppins(text: "Kusel App"),
      )),
    );
  }
}

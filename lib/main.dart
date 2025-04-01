import 'dart:ui';

import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/theme_manager/theme_manager_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_router.dart';
import 'locale/localization_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(ProviderScope(overrides: [
    sharedPreferencesProvider.overrideWithValue(prefs),
  ], child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      child: MaterialApp.router(
          locale: ref.watch(localeManagerProvider).currentLocale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          title: 'Flutter Demo',
          routerConfig: ref.read(mobileRouterProvider),
          theme: ref.watch(themeManagerProvider).currentSelectedTheme),
    );
  }

  @override
  void initState() {
    Future.microtask(() {
      {
        Locale deviceLocale = PlatformDispatcher.instance.locale;
        for (Locale supportedLocale in AppLocalizations.supportedLocales) {
          if (supportedLocale.languageCode == deviceLocale.languageCode) {
            ref
                .read(localeManagerProvider.notifier)
                .updateCurrentSelectedLocale(deviceLocale);
          }
        }
      }
    });
    super.initState();
  }
}

import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/screens/no_network/network_status_screen.dart';
import 'package:kusel/screens/no_network/network_status_screen_provider.dart';
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      designSize: Size(360, 690),
      child: MaterialApp.router(
          locale: ref.watch(localeManagerProvider).currentLocale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          title: 'Flutter Demo',
          routerConfig: ref.read(mobileRouterProvider),
          theme: ref.watch(themeManagerProvider).currentSelectedTheme,
          builder: (context, child) {
            final hasNetwork =
                ref.watch(networkStatusProvider).isNetworkAvailable;
            return hasNetwork ? child! : NetworkStatusScreen();
          }),
    );
  }

  @override
  void initState() {
    Future.microtask(() async {
      {
        ref.read(localeManagerProvider.notifier).initialLocaleSetUp();
        ref.read(networkStatusProvider.notifier).checkNetworkStatus();
      }
    });
    super.initState();
  }
}

import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:domain/model/request_model/digifit/digifit_update_exercise_request_model.dart';
import 'package:domain/model/response_model/digifit/digifit_cache_data_response_model.dart';
import 'package:domain/model/response_model/digifit/digifit_information_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kusel/database/hive_box.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kusel/screens/no_network/network_status_screen.dart';
import 'package:kusel/screens/no_network/network_status_screen_provider.dart';
import 'package:kusel/theme_manager/theme_manager_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_router.dart';
import 'locale/localization_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(DigifitCacheDataResponseModelAdapter());
  Hive.registerAdapter(DigifitInformationResponseModelAdapter());
  Hive.registerAdapter(DigifitInformationDataModelAdapter());
  Hive.registerAdapter(DigifitInformationUserStatsModelAdapter());
  Hive.registerAdapter(DigifitInformationParcoursModelAdapter());
  Hive.registerAdapter(DigifitInformationStationModelAdapter());
  Hive.registerAdapter(DigifitInformationActionsModelAdapter());
  Hive.registerAdapter(DigifitUpdateExerciseRequestModelAdapter());
  Hive.registerAdapter(DigifitExerciseRecordModelAdapter());

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
      builder: (context, child) {
        return Consumer(
          builder: (context, ref, _) {
            final hasNetwork =
                ref.watch(networkStatusProvider).isNetworkAvailable;

            return MaterialApp.router(
              locale: ref.watch(localeManagerProvider).currentLocale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              title: 'Flutter Demo',
              routerConfig: ref.read(mobileRouterProvider),
              theme: ref.watch(themeManagerProvider).currentSelectedTheme,
              builder: (context, child) {
                return hasNetwork ? child! : const NetworkStatusScreen();
                return child!;
              },
            );
          },
        );
      },
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

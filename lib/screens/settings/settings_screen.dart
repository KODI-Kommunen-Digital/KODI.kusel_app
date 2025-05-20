import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/images_path.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/settings/settings_screen_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_widgets/common_background_clipper_widget.dart';
import '../dashboard/dashboard_screen_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(settingsScreenProvider.notifier).fetchCurrentLanguage();
      ref.read(settingsScreenProvider.notifier).isLoggedIn();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        CommonBackgroundClipperWidget(
            clipperType: UpstreamWaveClipper(),
            imageUrl: imagePath['background_image'] ?? "",
            height: 100.h,
            blurredBackground: true,
            isStaticImage: true
        ),
        Visibility(
          visible: ref.watch(settingsScreenProvider).isLoggedIn,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.account_circle_outlined),
                title: textBoldPoppins(
                  text: AppLocalizations.of(context).profile,
                  textAlign: TextAlign.start,
                ),
                onTap: () {
                  ref.read(navigationProvider).navigateUsingPath(
                      path: profileScreenPath, context: context);
                },
              ),
              const Divider(),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: textBoldPoppins(
              textAlign: TextAlign.start,
              text: AppLocalizations.of(context).change_language),
          onTap: () => _showLanguageDialog(context),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.link),
          title: textBoldPoppins(
              textAlign: TextAlign.start,
              text: AppLocalizations.of(context).imprint_page),
          onTap: () async {
            final Uri uri =
                Uri.parse("http://deinkuselerland.de/impressum");
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            }
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.text_snippet_outlined),
          title: textBoldPoppins(
              textAlign: TextAlign.start,
              text: AppLocalizations.of(context).terms_of_use),
          onTap: () async {
            final Uri uri =
                Uri.parse("http://deinkuselerland.de/terms");
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            }
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: textBoldPoppins(
              textAlign: TextAlign.start,
              text: AppLocalizations.of(context).privacy_policy),
          onTap: () async {
            final Uri uri =
                Uri.parse("http://deinkuselerland.de/privacy-policy");
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            }
          },
        ),
        Visibility(
          visible: ref.watch(settingsScreenProvider).isLoggedIn,
          child: Column(children: [
            const Divider(),
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: textBoldPoppins(
                text: AppLocalizations.of(context).favorites,
                textAlign: TextAlign.start,
              ),
              onTap: () async {
                ref.read(navigationProvider).navigateUsingPath(
                    context: context, path: favoritesListScreenPath);
              },
            ),
          ]),
        ),
        const Divider(),
        Visibility(
          visible: ref.watch(settingsScreenProvider).isLoggedIn,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.logout),
                title: textBoldPoppins(
                  text: AppLocalizations.of(context).logout,
                  textAlign: TextAlign.start,
                ),
                onTap: () async {
                  ref.read(settingsScreenProvider.notifier).logoutUser(() {
                    ref
                        .read(dashboardScreenProvider.notifier)
                        .onIndexChanged(0);
                  });
                },
              ),
            ],
          ),
        ),
        Visibility(
          visible: false ?? !ref.watch(settingsScreenProvider).isLoggedIn,
          child: ListTile(
            leading: const Icon(Icons.login),
            title: textBoldPoppins(
              text: AppLocalizations.of(context).log_in_sign_up,
              textAlign: TextAlign.start,
            ),
            onTap: () async {
              ref.read(navigationProvider).removeCurrentAndNavigate(
                  context: context, path: signInScreenPath);
            },
          ),
        ),
      ],
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final selectedLanguage =
            ref.watch(settingsScreenProvider).selectedLanguage;
        final languageList = ref.read(settingsScreenProvider).languageList;

        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: textBoldPoppins(
            color: Colors.white,
            text: AppLocalizations.of(context).select_language,
          ),
          content: Container(
            color: Theme.of(context).colorScheme.secondary,
            width: double.maxFinite,
            height: 90.h,
            child: ListView(
              shrinkWrap: true,
              children: languageList.map((language) {
                return RadioTheme(
                    data: RadioThemeData(
                      fillColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return Colors.white; // selected radio button
                        }
                        return Colors.white; // unselected radio button
                      }),
                    ),
                    child: RadioListTile<String>(
                      hoverColor: Colors.white,
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: textRegularPoppins(
                            text: language, color: Colors.white),
                      ),
                      value: language,
                      selectedTileColor: Colors.white,
                      groupValue: selectedLanguage,
                      onChanged: (String? value) {
                        if (value != null) {
                          ref
                              .read(settingsScreenProvider.notifier)
                              .changeLanguage(selectedLanguage: value);
                          ref
                              .read(navigationProvider)
                              .removeDialog(context: context);
                        }
                      },
                    ));
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

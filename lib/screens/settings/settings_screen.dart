import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/images_path.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/settings/settings_screen_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
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
        ClipPath(
          clipper: UpstreamWaveClipper(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .15,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              imagePath['background_image'] ?? "",
              fit: BoxFit.cover,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: textBoldPoppins(
              text: AppLocalizations.of(context).change_language),
          onTap: () => _showLanguageDialog(context),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout),
          title: textBoldPoppins(text: AppLocalizations.of(context).logout),
          onTap: () async {
            ref.read(settingsScreenProvider.notifier).logoutUser(() {
              ref.read(navigationProvider).removeAllAndNavigate(
                  context: context, path: signInScreenPath);
            });
          },
        ),
      ],
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: textBoldPoppins(
              text: AppLocalizations.of(context).select_language),
          content: DropdownButton<String>(
            value: ref.watch(settingsScreenProvider).selectedLanguage,
            isExpanded: true,
            onChanged: (String? value) {
              ref
                  .read(settingsScreenProvider.notifier)
                  .changeLanguage(selectedLanguage: value!);
            },
            items:
                ref.read(settingsScreenProvider).languageList.map((language) {
              return DropdownMenuItem(
                value: language,
                child: textRegularPoppins(text: language),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

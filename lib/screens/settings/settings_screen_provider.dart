import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/settings/settings_screen_state.dart';

final settingsScreenProvider =
    StateNotifierProvider.autoDispose<SettingsScreenProvider, SettingsScreenState>(
        (ref) => SettingsScreenProvider());

class SettingsScreenProvider extends StateNotifier<SettingsScreenState> {
  SettingsScreenProvider() : super(SettingsScreenState.empty());
}

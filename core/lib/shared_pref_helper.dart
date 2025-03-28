import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final sharedPreferenceHelperProvider = FutureProvider<SharedPreferenceHelper>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return SharedPreferenceHelper(prefs: prefs);
});

class SharedPreferenceHelper {
  final SharedPreferences prefs;

  SharedPreferenceHelper({required this.prefs});

  String? getString(String key) => prefs.getString(key);

  Future<bool> setString(String key, String value) async {
    return await prefs.setString(key, value);
  }

  int? getInt(String key) => prefs.getInt(key);

  Future<bool> setInt(String key, int value) async {
    return await prefs.setInt(key, value);
  }

  Future<bool> remove(String key) async {
    return await prefs.remove(key);
  }

  Future<void> clear() async {
    await await prefs.clear();
  }

}

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../base_model.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(); // This will be overridden in main
});

// SharedPreferenceHelper provider
final sharedPreferenceHelperProvider = Provider<SharedPreferenceHelper>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
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

  Future<void> saveObject(String key, dynamic object) async {
    String objectJson = jsonEncode(object.toJson());
    await prefs.setString(key, objectJson);
  }

  Future<bool> remove(String key) async {
    return await prefs.remove(key);
  }

  Future<void> clear() async {
     await prefs.clear();
  }

}

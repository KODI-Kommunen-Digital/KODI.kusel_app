import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'extract_deviceId_state.dart';

final extractDeviceIdProvider =
    StateNotifierProvider<ExtractDeviceIdProvider, ExtractDeviceIdState>(
        (ref) => ExtractDeviceIdProvider());

class ExtractDeviceIdProvider extends StateNotifier<ExtractDeviceIdState> {
  ExtractDeviceIdProvider() : super(ExtractDeviceIdState.empty());

  Future<String?> extractDeviceId() async {
    try {
      final deviceInfo = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        final androidId = androidInfo.id;
        state = state.copyWith(deviceId: androidId);
        return androidId;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        final iosId = iosInfo.identifierForVendor;
        state = state.copyWith(deviceId: iosId);
        return iosId;
      }
    } catch (e) {
      debugPrint('Error in extracting the deviceID $e');
    }

    return null;
  }
}

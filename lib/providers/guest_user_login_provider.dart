import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:domain/model/request_model/guest_user_login/guest_user_login_request_model.dart';
import 'package:domain/model/response_model/guest_user_login/guest_user_login_response_model.dart';
import 'package:domain/usecase/guest_user_login/guest_user_login_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'extract_deviceId/extract_deviceId_provider.dart';

final guestUserLoginProvider = Provider((ref) => GuestUserLogin(
    guestUserLoginUseCase: ref.read(guestUserLoginUseCaseProvider),
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
    extractDeviceIdProvider: ref.read(extractDeviceIdProvider)));

class GuestUserLogin {
  GuestUserLoginUseCase guestUserLoginUseCase;
  SharedPreferenceHelper sharedPreferenceHelper;
  ExtractDeviceIdProvider extractDeviceIdProvider;

  GuestUserLogin(
      {required this.guestUserLoginUseCase,
      required this.sharedPreferenceHelper,
      required this.extractDeviceIdProvider});

  getGuestUserToken() async {
    try {
      String? deviceId = await extractDeviceIdProvider.extractDeviceId();
      if (deviceId != null) {
        GuestUserLoginRequestModel requestModel =
            GuestUserLoginRequestModel(deviceId: deviceId);
        GuestUserLoginResponseModel responseModel =
            GuestUserLoginResponseModel();
        final response =
            await guestUserLoginUseCase.call(requestModel, responseModel);

        response.fold((l) {
          debugPrint('guest user token fold exception = ${l.toString()}');
        }, (r) {
          final res = r as GuestUserLoginResponseModel;

          sharedPreferenceHelper.setString(
              digifitAccessTokenKey, res.data?.accessToken ?? '');
        });
      }
    } catch (error) {
      debugPrint('guest user token exception = $error');
    }
  }
}

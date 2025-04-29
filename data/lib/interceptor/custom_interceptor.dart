import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/interceptor/refresh_token/refresh_token_request_model.dart';
import 'package:data/interceptor/refresh_token/refresh_token_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network/src/api_helper.dart';

import '../custom_logger.dart';
import '../end_points.dart';

final customInterceptorProvider = Provider((ref) => CustomInterceptor(
    ref: ref,
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class CustomInterceptor extends Interceptor {
  Ref<Object?> ref;
  SharedPreferenceHelper sharedPreferenceHelper;

  CustomInterceptor({required this.ref, required this.sharedPreferenceHelper});

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    ref.read(customLoggerProvider).logResponse(response);

    if ((response.requestOptions.path != sigInEndPoint &&
            response.requestOptions.path != signUpEndPoint) &&
        (response.statusCode == 401)) {
      ApiHelper apiHelper = ref.read(apiHelperProvider);

      final userId = sharedPreferenceHelper.getString(userIdKey);
      if (userId != null && userId.isNotEmpty) {
        final path = "users/$userId/refresh";

        final refreshToken = sharedPreferenceHelper.getString(refreshTokenKey);

        RefreshTokenRequestModel requestModel =
            RefreshTokenRequestModel(refreshToken: refreshToken ?? "");

        final result = await apiHelper.postRequest(
            path: path,
            body: requestModel.toJson(),
            create: () {
              return RefreshTokenResponseModel();
            });

        result.fold((left) {
          debugPrint("refresh token fold exception : $left");
        }, (right) async {
          if (right.data != null) {
            final accessToken = right.data!.accessToken;
            final refreshToken = right.data!.refreshToken;

            await sharedPreferenceHelper.setString(
                refreshTokenKey, refreshToken ?? "");
            await sharedPreferenceHelper.setString(tokenKey, accessToken ?? "");

            final updatedRequestOptions = response.requestOptions;
            updatedRequestOptions.headers["Authorization"] =
                "Bearer $accessToken";
            final retryRequest = await apiHelper.fetchRequest(
                requestOptions: updatedRequestOptions);
            retryRequest.fold(
              (err) => debugPrint("Retry request failed: $err"),
              (retriedResponse) => handler.resolve(retriedResponse),
            );
            return;
          } else {
            debugPrint("Failed to get new token: ${right.message}");
          }
        });
      }
    }
    super.onResponse(response, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    ref.read(customLoggerProvider).logRequest(options);
    options.validateStatus = (status) {
      return status != null && status < 500;
    };
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    ref.read(customLoggerProvider).logError(error);
    super.onError(error, handler);
  }
}

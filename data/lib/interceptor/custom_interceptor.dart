import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../custom_logger.dart';
import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';

final customInterceptorProvider =
    Provider((ref) => CustomInterceptor(ref: ref));

class CustomInterceptor extends Interceptor {
  Ref<Object?> ref;

  CustomInterceptor({required this.ref});

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    ref.read(customLoggerProvider).logResponse(response);

    super.onResponse(response, handler);
  }

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    var accessToken = ref.read(sharedPreferenceHelperProvider).getString(tokenKey);
    options.validateStatus = (status) {
      return status != null && status < 500;
    };

    options.headers.addAll({
      'authorization': "Bearer $accessToken", // Replace with dynamic token if needed
      'Accept': 'application/json',
    });
    ref.read(customLoggerProvider).logRequest(options);
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    ref.read(customLoggerProvider).logError(error);
    super.onError(error, handler);
  }
}

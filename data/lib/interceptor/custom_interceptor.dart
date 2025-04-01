import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../custom_logger.dart';

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

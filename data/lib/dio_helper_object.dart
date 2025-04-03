import 'package:data/interceptor/custom_interceptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network/src/dio_factory.dart';

import 'end_points.dart';

final dioHelperObjectProvider = Provider((ref) => DioHelper(
    baseUrl: baseUrl, dioInterceptors: [ref.read(customInterceptorProvider)]));

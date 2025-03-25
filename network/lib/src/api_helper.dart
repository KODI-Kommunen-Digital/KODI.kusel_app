import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:network/src/dio_factory.dart';
import 'exceptions.dart';

class ApiHelper<E extends BaseModel> {
  final Dio _dio;
  CreateModel<E>? errorModel;
  final String fallbackErrorMessage;

  ApiHelper._internal(
    this._dio, {
    this.errorModel,
    required this.fallbackErrorMessage,
  });

  factory ApiHelper({
    required DioHelper dioHelper,
    CreateModel<E>? errorModel,
    String? fallbackErrorMessage,
  }) {
    return ApiHelper._internal(
      dioHelper.createDio(),
      fallbackErrorMessage: fallbackErrorMessage ??
          "Unknown error occurred, please try again later.",
      errorModel: errorModel,
    );
  }

  Future<Either<Exception, T>> postRequest<T extends BaseModel>({
    required String path,
    required CreateModel<T> create,
    CancelToken? cancelToken,
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
    ProgressCallback? onReceiveProgress,
  }) async {
    var response = await _dio
        .post(
      path,
      data: body,
      options: Options(headers: headers),
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    )
        .catchError((error) {
      return Response(
        requestOptions: RequestOptions(path: ''),
        statusMessage: error.toString(),
        statusCode: 999,
      );
    });
    if (response.statusCode == 999) {
      return Left(ApiError(error: fallbackErrorMessage));
    }
    try {
      return Right(create().fromJson(response.data));
    } on Exception catch (e) {
      return Left(e);
    } catch (error) {
      try {
        return Left(ApiError(
            error: errorModel != null
                ? errorModel!().fromJson(response.data).message
                : fallbackErrorMessage));
      } catch (error) {
        return Left(ApiError(error: fallbackErrorMessage));
      }
    }
  }

  Future<Either<Exception, T>> postFormRequest<T extends BaseModel>({
    required String path,
    required CreateModel<T> create,
    CancelToken? cancelToken,
    FormData? body,
    Map<String, dynamic>? headers,
    ProgressCallback? onReceiveProgress,
  }) async {
    var response = await _dio
        .post(
      path,
      data: body,
      options: Options(headers: headers),
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    )
        .catchError((error) {
      return Response(
        requestOptions: RequestOptions(path: ''),
        statusMessage: error.toString(),
        statusCode: 999,
      );
    });
    if (response.statusCode == 999) {
      return Left(ApiError(error: fallbackErrorMessage));
    }
    try {
      return Right(create().fromJson(response.data));
    } on Exception catch (e) {
      return Left(e);
    } catch (error) {
      try {
        return Left(ApiError(
            error: errorModel != null
                ? errorModel!().fromJson(response.data).message
                : fallbackErrorMessage));
      } catch (error) {
        return Left(ApiError(error: fallbackErrorMessage));
      }
    }
  }

  Future<Either<Exception, List<T>>> postListRequest<T extends BaseModel>({
    required String path,
    required CreateModel<T> create,
    CancelToken? cancelToken,
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
    ProgressCallback? onReceiveProgress,
  }) async {
    var response = await _dio
        .post(
      path,
      data: body,
      options: Options(headers: headers),
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    )
        .catchError((error) {
      return Response(
        requestOptions: RequestOptions(path: ''),
        statusMessage: error.toString(),
        statusCode: 999,
      );
    });
    if (response.statusCode == 999) {
      return Left(ApiError(error: fallbackErrorMessage));
    }
    try {
      if (response.data is List) {
        return Right((response.data as List)
            .map<T>((e) => create().fromJson(e))
            .toList());
      } else {
        return Left(ApiError(error: "Response is not list type"));
      }
    } on Exception catch (e) {
      return Left(e);
    } catch (error) {
      try {
        return Left(ApiError(
            error: errorModel != null
                ? errorModel!().fromJson(response.data).message
                : fallbackErrorMessage));
      } catch (error) {
        return Left(ApiError(error: fallbackErrorMessage));
      }
    }
  }

  Future<Either<Exception, T>> getRequest<T extends BaseModel>({
    required String path,
    required CreateModel<T> create,
    CancelToken? cancelToken,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    ProgressCallback? onReceiveProgress,
  }) async {
    var response = await _dio
        .get(
      path,
      queryParameters: params,
      options: Options(headers: headers),
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    )
        .catchError((error) {
      return Response(
        requestOptions: RequestOptions(path: ''),
        statusMessage: error.toString(),
        statusCode: 999,
      );
    });
    try {
      return Right(create().fromJson(response.data));
    } on Exception catch (e) {
      return Left(e);
    } catch (error) {
      try {
        return Left(ApiError(
            error: errorModel != null
                ? errorModel!().fromJson(response.data).message
                : fallbackErrorMessage));
      } catch (error) {
        return Left(ApiError(error: fallbackErrorMessage));
      }
    }
  }

  Future<Either<Exception, List<T>>> getListRequest<T extends BaseModel>({
    required String path,
    required CreateModel<T> create,
    CancelToken? cancelToken,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    ProgressCallback? onReceiveProgress,
  }) async {
    var response = await _dio
        .get(
      path,
      queryParameters: params,
      options: Options(headers: headers),
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    )
        .catchError((error) {
      return Response(
        requestOptions: RequestOptions(path: ''),
        statusMessage: error.toString(),
        statusCode: 999,
      );
    });
    try {
      if (response.data is List) {
        return Right((response.data as List)
            .map<T>((e) => create().fromJson(e))
            .toList());
      } else {
        return Left(ApiError(error: "Response is not list type"));
      }
    } on Exception catch (e) {
      return Left(e);
    } catch (error) {
      try {
        return Left(ApiError(
            error: errorModel != null
                ? errorModel!().fromJson(response.data).message
                : fallbackErrorMessage));
      } catch (error) {
        return Left(ApiError(error: fallbackErrorMessage));
      }
    }
  }

  Future<Either<Exception, List<int>>> getByteArray({
    required String path,
    CancelToken? cancelToken,
    Map<String, dynamic>? body,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    ProgressCallback? onReceiveProgress,
  }) async {
    var response = await Dio().post<List<int>>(
      path,
      data: body,
      options: Options(responseType: ResponseType.bytes),
    );
    try {
      if (response.data != null && response.data is List<int>) {
        return Right(response.data!);
      } else {
        return Left(ApiError(error: "Response is not list type"));
      }
    } on Exception catch (e) {
      return Left(e);
    } catch (error) {
      return Left(ApiError(error: fallbackErrorMessage));
    }
  }

  Future<Either<Exception, T>> putRequest<T extends BaseModel>({
    required String path,
    required CreateModel<T> create,
    CancelToken? cancelToken,
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
    ProgressCallback? onReceiveProgress,
  }) async {
    var response = await _dio
        .put(
      path,
      data: body,
      options: Options(headers: headers),
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    )
        .catchError((error) {
      return Response(
        requestOptions: RequestOptions(path: ''),
        statusMessage: error.toString(),
        statusCode: 999,
      );
    });
    if (response.statusCode == 999) {
      return Left(ApiError(error: fallbackErrorMessage));
    }
    try {
      return Right(create().fromJson(response.data));
    } on Exception catch (e) {
      return Left(e);
    } catch (error) {
      try {
        return Left(ApiError(
            error: errorModel != null
                ? errorModel!().fromJson(response.data).message
                : fallbackErrorMessage));
      } catch (error) {
        return Left(ApiError(error: fallbackErrorMessage));
      }
    }
  }
}

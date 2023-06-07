import 'dart:io' as io;

import 'package:dio/dio.dart';

import 'connection_exception.dart';
import 'http_exception.dart';

class DioErrorInterceptor implements Interceptor {
  const DioErrorInterceptor(this.errorMessageFields);

  final List<String> errorMessageFields;

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    final uri = err.requestOptions.uri;

    switch (err.type) {
      case DioErrorType.badResponse:
        if (err.response != null) {
          throw HttpException.fromResponse(
            err.response!,
            errorMessageKeys: errorMessageFields,
          );
        }
        break;
      case DioErrorType.connectionTimeout:
        throw ConnectionTimeoutException(uri);
      case DioErrorType.connectionError:
        throw ConnectionErrorException(uri);
      case DioErrorType.receiveTimeout:
        throw RecieveTimeoutException(uri);
      case DioErrorType.sendTimeout:
        throw SendTimeoutException(uri);
      case DioErrorType.badCertificate:
        throw SendTimeoutException(uri);
      case DioErrorType.unknown:
        if (err.error.runtimeType == io.SocketException) {
          throw SocketException(uri);
        }
        break;
      case DioErrorType.cancel:
        break;
    }

    return handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }
}

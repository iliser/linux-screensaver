import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

extension _RetrieableFormData on FormData {
  bool get isRetrieable => files.every((e) => e is MultipartFileRecreatable);
}

class SafeRetryInterceptor extends RetryInterceptor {
  SafeRetryInterceptor({
    required super.dio,
    super.logPrint,
    super.retries,
    super.retryDelays,
    super.retryEvaluator,
    super.ignoreRetryEvaluatorExceptions,
    super.retryableExtraStatuses,
  });

  @override
  Future<void> onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) async {
    final data = err.requestOptions.data;
    if (data is FormData && !data.isRetrieable) {
      logPrint?.call(
        '[${err.requestOptions.path}] An error occurred during request, '
        'retries disabled cause request.data is FormData and contains non retrieable files',
      );
      return handler.next(err);
    }
    return super.onError(err, handler);
  }

  // methods in case of future changes in RetriesInterceptor
  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    final data = response.requestOptions.data;
    if (data is FormData && !data.isRetrieable) {
      return handler.next(response);
    }
    return super.onResponse(response, handler);
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final data = options.data;
    if (data is FormData && !data.isRetrieable) {
      return handler.next(options);
    }
    return super.onRequest(options, handler);
  }
}

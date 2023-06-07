import 'dart:developer';

import 'package:dio/dio.dart';

class DioPerformanceInterceptor extends Interceptor {
  final Map<String, Stopwatch> _sws = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _sws[options.uri.path] = Stopwatch()..start();
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    final path = err.requestOptions.uri.path;
    log(
      'Request on $path end with error in time : ${err.toString()}: ${_sws[path]?.elapsedMilliseconds}ms.',
      name: 'Network performance',
    );
    _sws.remove(path);
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final path = response.requestOptions;

    log(
      'Request on $path end with success in time ${_sws[path]?.elapsedMilliseconds}ms.',
      name: 'Network performance',
    );
    _sws.remove(path);
    super.onResponse(response, handler);
  }
}

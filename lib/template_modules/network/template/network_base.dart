import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_file_store/dio_cache_interceptor_file_store.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sentry_dio/sentry_dio.dart';
import 'package:template/globals.dart';

export '../cancel_token_extension.dart';

import '../dio_performance_interceptor.dart';
import '../dio_safe_retry_interceptor.dart';
import '../error/dio_error_interceptor.dart';
import 'parametrized_network.dart';

/// Prefer to store common request
final dbCacheOption = CacheOptions(
  store: HiveCacheStore(
    '${config.applicationSupportDirectory}/http_hive_cache',
  ),
  hitCacheOnErrorExcept: [401, 403],
);

/// Prefer to store request fith large data
final fileCacheOption = CacheOptions(
  store: FileCacheStore(
    '${config.applicationSupportDirectory}/http_file_cache',
  ),
  hitCacheOnErrorExcept: [401, 403],
);

abstract class NetworkBase implements ParametrizedNetwork {
  NetworkBase();

  NetworkBase.value({SyncParametrizedNetworkTag? tag});

  @override
  Map<Symbol, AlwaysAliveProviderBase> get args => {};

  // cancel token that canceled when network dispose was called
  final disposeToken = CancelToken();

  @override
  @mustCallSuper
  void dispose() => disposeToken.cancel('disposed');

  /// define request cache method you use one of options bellow or define CacheOptions
  /// - `dbCacheOptions` - for store request in `hive` prefer for small requests
  /// - `fileCacheOptions` - store request in file prefer for large request
  @visibleForOverriding
  CacheOptions? get cacheOptions => null;

  /// base url for all requests
  @visibleForOverriding
  String get baseUrl => config.baseApiUrl;

  /// default headers for request prefer to merge with`super.defaultHeader`
  @mustCallSuper
  Map<String, String> get defaultHeaders => {};

  /// default query for request prefer to merge with `super.defaultQuery`
  @mustCallSuper
  Map<String, String> get defaultQuery => {};

  /// timeout for sending data to server in milliseconds
  ///
  /// increase if network used for upload large data to server
  /// like image, video, archives
  Duration? get sendTimeout => const Duration(seconds: 3);

  /// timeout for estabilish connection to server in milliseconds
  Duration? get connectTimeout => const Duration(seconds: 3);

  /// timeout for recieve data to server in milliseconds
  ///
  /// increase if network used for download large amount of data
  /// like image, video, archives
  /// can be decreased for better user expirience if network work with small amount of data,
  Duration? get recieveTimeout => const Duration(seconds: 15);

  /// allow to retry requests from this network instance
  bool get allowRetries => true;

  /// allow to modify or rewrite dio instance
  List<Dio Function(Dio dio)> get integrations => [(dio) => dio..addSentry()];

  /// "deep.nested.key" from where error message for user will be extracted
  /// try each field and first presented in response used
  List<String> get errorMessageFields =>
      ['userErrorMessage', 'errorMessage', 'message'];

  Dio? _dio;
  Dio _buildDioInstance() {
    var dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: defaultHeaders,
        queryParameters: defaultQuery,
        sendTimeout: sendTimeout,
        connectTimeout: connectTimeout,
        receiveTimeout: recieveTimeout,
      ),
    );
    final rng = Random();
    dio.interceptors.addAll([
      if (allowRetries)
        SafeRetryInterceptor(
          dio: dio,
          retries: 3,
          retryDelays: [
            // random jitter added to split load if too many clients drops
            // from server in same time, aka. server just died and reload
            // then all client that wait data disconnect in the same time
            Duration(milliseconds: 300 + rng.nextInt(100)),
            Duration(milliseconds: 1300 + rng.nextInt(500)),
            Duration(milliseconds: 4000 + rng.nextInt(2000)),
          ],
        ),
      if (cacheOptions != null) DioCacheInterceptor(options: cacheOptions!),
      if (config.enableNetworkPerformance) DioPerformanceInterceptor(),
      DioErrorInterceptor(errorMessageFields),
    ]);

    for (var integration in integrations) {
      dio = integration(dio);
    }
    return dio;
  }

  /// return cached dio instance
  @nonVirtual
  Dio get dio => _dio ??= _buildDioInstance();
}

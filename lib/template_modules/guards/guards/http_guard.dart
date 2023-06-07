import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:guarded_core/configuration/guarded_configuration.dart';
import 'package:guarded_core/guarded_core.dart';
import 'package:template/template_modules/network/error/json_exception.dart';
import 'package:template/template_modules/network/error/network_exceptions.dart';

import '../core.dart';
import 'guarded_http_error.dart';

class GuardedConfigurationHttpErrorWidget extends GuardedConfiguration {
  GuardedConfigurationHttpErrorWidget(this.errorWidget);

  static GuardedConfigurationHttpErrorWidget? watch(WidgetRef ref) =>
      GuardedConfiguration.watch<GuardedConfigurationHttpErrorWidget>(ref);

  final Widget Function(NetworkException error) errorWidget;
}

// accept async value provider watch it and on `NetworkException` display concreate erro screen
class HttpGuard<T> extends GuardBase implements ScreenGuard, WidgetGuard {
  HttpGuard(this.provider, {this.isScreen = false});

  final bool isScreen;
  final ProviderBase<AsyncValue<T>> provider;

  @override
  GuardCheckResult check(BuildContext context, WidgetRef ref) {
    final value = ref.watch(provider);

    return value.when(
      data: (_) => const GuardCheckResult.pass(),
      error: (initialError, stackTrace) {
        dynamic error = initialError;
        if (kDebugMode) {
          log('Get error in `HttpGuard`\n error: $error,\n stackTrace: $stackTrace');
        }
        if (error is DioError && error.type == DioErrorType.unknown) {
          error = error.error;
        }
        if (error is CheckedFromJsonException) {
          error = JsonParseException(error);
        }
        if (error is NetworkException) {
          // err.
          return GuardCheckResult.widget(
            !isScreen
                ? GuardedHttpError(error)
                : GuardedScreenTemplate(
                    onRefresh: () async => ref.refresh(provider),
                    title: Text(error.title),
                    child: GuardedHttpError(error),
                  ),
          );
        }
        return GuardCheckResult.error(
          error,
          stackTrace: stackTrace,
        );
      },
      loading: () => const GuardCheckResult.loading(),
    );
  }

  @override
  GuardBase get screenGuard => HttpGuard(provider, isScreen: true);

  @override
  GuardBase get widgetGuard => HttpGuard(provider, isScreen: false);

  static GuardedConfigurationHttpErrorWidget httpErrorBuilder(
    Widget Function(NetworkException) builder,
  ) =>
      GuardedConfigurationHttpErrorWidget(builder);
}

import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:template/globals.dart';
import 'package:template/template_modules/displayed_exception.dart';

class _EventProcessor extends EventProcessor {
  @override
  FutureOr<SentryEvent?> apply(event, {hint}) {
    if (event is SentryTransaction) return event;
    var err = event.throwable;
    log(
      'Sentry catch err $err ${err.runtimeType}',
      name: 'SentryErrorProcess',
    );
    bool? mustReport;

    if (err is DioError) {
      if (err.type == DioErrorType.unknown) err = err.error;
    }

    if (err is CheckedFromJsonException) {
      err = DisplayedException(
        staticLocalization.networkErrors.jsonParse.description,
      );
      mustReport = true;
    }

    if (err is DisplayedException && !DisplayedException.doNotDisplay(hint)) {
      displayError(err);
      if (mustReport != true) return null;
    }
    // just drop all event if sentry disabled
    if (!config.enableSentry) return null;

    return event;
  }
}

void sentryOptionsInit(SentryFlutterOptions options) {
  options.enableAutoPerformanceTracing = true;
  options.autoAppStart = false;

  options.sampleRate = config.sentrySampleRate;
  options.tracesSampleRate = config.sentryTransactionSampleRate;

  options.dsn = config.sentryDsn;

  options.addEventProcessor(_EventProcessor());
}

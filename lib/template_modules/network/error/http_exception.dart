import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:template/globals.dart';
import 'package:template/i18n/strings.g.dart';
import 'package:template/template_modules/displayed_exception.dart';

import 'network_error_i18n_mixin.dart';
import 'network_exceptions.dart';

class _ErrorDescription with I18NErrorDescription {
  const _ErrorDescription(this.code, this.description, this.title);

  @override
  final String code;
  @override
  final String description;
  @override
  final String title;
}

extension _I18NErrorDescriptionCopyWithExtension on I18NErrorDescription {
  _ErrorDescription copyWith({
    String? code,
    String? description,
    String? title,
  }) {
    return _ErrorDescription(
      code ?? this.code,
      description ?? this.description,
      title ?? this.title,
    );
  }
}

extension _HttpExceptionNullableErrorMessage on HttpException {
  String? get errorMessageOrNull => errorMessage.isEmpty ? null : errorMessage;
}

String? _extractDeep(dynamic data, String key) {
  try {
    return key.split('.').fold<dynamic>(data, (p, k) => p[k]) as String?;
  } catch (error) {
    return null;
  }
}

String? _extractErrorMessage(
  Response res, {
  required List<String> errorMessageKeys,
}) {
  return errorMessageKeys
      .map((key) => _extractDeep(res.data, key))
      .where((e) => e != null)
      .firstOrNull;
}

/// Represent http error with code and uri
class HttpException extends NetworkException with NetworkErrorI18NMixin {
  // PR. maybe rename to ._ for prevent directly creation
  const HttpException(String text, this.code, Uri uri) : super(text, uri);

  factory HttpException.fromResponse(
    Response res, {
    required List<String> errorMessageKeys,
  }) {
    assert(res.statusCode != null);

    final errorMessage = _extractErrorMessage(
          res,
          errorMessageKeys: errorMessageKeys,
        ) ??
        '';
    final statusCode = res.statusCode;
    if (statusCode != null) {
      final errorConstructorMap = {
        400: ClientDataException.fromResponse,
        401: UnauthorizedException.fromResponse,
        403: ForbidenException.fromResponse,
        404: NotFoundException.fromResponse,
        422: UnprocessableDataException.fromResponse,
        429: TooManyRequestException.fromResponse,
        503: ServiceUnavailableException.fromResponse,
      };
      final exception = errorConstructorMap[statusCode]?.call(
        res,
        errorMessage,
      );

      if (exception != null) return exception;

      if (statusCode >= 500) {
        return ServerException.fromResponse(res, errorMessage);
      }

      return GenericHttpException.fromResponse(res, errorMessage);
    }
    throw Exception('response.statusCode must not be null');
  }

  final int code;

  @override
  String toString() => '''
$runtimeType(
  "$errorMessage",
  code: $code,
  uri: $uri,
)''';

  @override
  // TODO: implement description
  I18NErrorDescription get description => throw UnimplementedError();
}

class GenericHttpException extends HttpException {
  const GenericHttpException(String serverErrorMessage, int code, Uri uri)
      : super(serverErrorMessage, code, uri);

  factory GenericHttpException.fromResponse(Response res, String message) {
    final ret = GenericHttpException(
      message,
      res.statusCode ?? 0,
      res.requestOptions.uri,
    );
    Sentry.captureException(ret, hint: DisplayedException.doNotDisplayHint);
    return ret;
  }

  @override
  get description => staticLocalization.networkErrors.unknownError
      .copyWith(description: errorMessageOrNull, code: code.toString());
}

/// Represent http 5xx error
@immutable
class ServerException extends HttpException {
  const ServerException(String serverErrorMessage, int code, Uri uri)
      : super(serverErrorMessage, code, uri);

  factory ServerException.fromResponse(Response res, String message) {
    final ret = ServerException(
      message,
      res.statusCode ?? 0,
      res.requestOptions.uri,
    );
    Sentry.captureException(ret, hint: DisplayedException.doNotDisplayHint);
    return ret;
  }

  @override
  get description => staticLocalization.networkErrors.serverError
      .copyWith(description: errorMessageOrNull);
}

@immutable
class UnauthorizedException extends HttpException {
  const UnauthorizedException(String text, Uri uri) : super(text, 401, uri);

  factory UnauthorizedException.fromResponse(Response res, String message) {
    return UnauthorizedException(
      message,
      res.requestOptions.uri,
    );
  }

  @override
  get description => staticLocalization.networkErrors.unathorized
      .copyWith(description: errorMessageOrNull);
}

@immutable
class ForbidenException extends HttpException {
  const ForbidenException(String text, Uri uri) : super(text, 403, uri);

  factory ForbidenException.fromResponse(Response res, String message) {
    return ForbidenException(
      message,
      res.requestOptions.uri,
    );
  }

  @override
  get description => staticLocalization.networkErrors.forbiden
      .copyWith(description: errorMessageOrNull);
}

class NotFoundException extends HttpException {
  NotFoundException(String text, Uri uri) : super(text, 404, uri);

  factory NotFoundException.fromResponse(Response res, String message) {
    return NotFoundException(
      message,
      res.requestOptions.uri,
    );
  }

  @override
  get description => staticLocalization.networkErrors.notFound
      .copyWith(description: errorMessageOrNull);
}

@immutable
class ClientDataException extends HttpException {
  const ClientDataException(String text, Uri uri, this.payload)
      : super(text, 400, uri);

  factory ClientDataException.fromResponse(Response res, String message) {
    final ret = ClientDataException(
      message,
      res.requestOptions.uri,
      res.requestOptions.data,
    );

    Sentry.captureException(ret, hint: DisplayedException.doNotDisplayHint);
    return ret;
  }

  final dynamic payload;

  @override
  get description => staticLocalization.networkErrors.clientData
      .copyWith(description: errorMessageOrNull);
}

@immutable
class UnprocessableDataException extends HttpException {
  const UnprocessableDataException(String text, Uri uri, this.payload)
      : super(text, 422, uri);

  factory UnprocessableDataException.fromResponse(
    Response res,
    String message,
  ) {
    final ret = UnprocessableDataException(
      message,
      res.requestOptions.uri,
      res.requestOptions.data,
    );

    Sentry.captureException(ret, hint: DisplayedException.doNotDisplayHint);
    return ret;
  }

  final dynamic payload;

  @override
  get description => staticLocalization.networkErrors.unprocessableData
      .copyWith(description: errorMessageOrNull);
}

@immutable
class TooManyRequestException extends HttpException {
  const TooManyRequestException(String text, Uri uri, this.payload)
      : super(text, 429, uri);

  factory TooManyRequestException.fromResponse(Response res, String message) {
    final ret = TooManyRequestException(
      message,
      res.requestOptions.uri,
      res.requestOptions.data,
    );

    Sentry.captureException(ret, hint: DisplayedException.doNotDisplayHint);
    return ret;
  }

  final dynamic payload;

  @override
  get description => staticLocalization.networkErrors.tooManyRequest
      .copyWith(description: errorMessageOrNull);
}

@immutable
class ServiceUnavailableException extends HttpException {
  const ServiceUnavailableException(String text, Uri uri, this.payload)
      : super(text, 503, uri);

  factory ServiceUnavailableException.fromResponse(
    Response res,
    String message,
  ) {
    final ret = ServiceUnavailableException(
      message,
      res.requestOptions.uri,
      res.requestOptions.data,
    );

    Sentry.captureException(ret, hint: DisplayedException.doNotDisplayHint);
    return ret;
  }

  final dynamic payload;

  @override
  get description => staticLocalization.networkErrors.serviceUnavailable
      .copyWith(description: errorMessageOrNull);
}

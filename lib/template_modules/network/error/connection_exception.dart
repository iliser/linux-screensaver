import 'package:template/globals.dart';
import 'package:template/template_modules/network/error/network_error_i18n_mixin.dart';

import 'network_exceptions.dart';

abstract class ConnectionException extends NetworkException
    with NetworkErrorI18NMixin {
  ConnectionException(String text, Uri uri) : super(text, uri);

  @override
  String toString() {
    return '$runtimeType($errorMessage,$uri)';
  }
}

class ConnectionErrorException extends ConnectionException {
  ConnectionErrorException(Uri uri) : super('ConnectionErrorException', uri);

  @override
  get description => staticLocalization.networkErrors.connectionError;
}

class ConnectionTimeoutException extends ConnectionException {
  ConnectionTimeoutException(Uri uri)
      : super('ConnectionTimeoutException', uri);

  @override
  get description => staticLocalization.networkErrors.connectionTimeout;
}

class RecieveTimeoutException extends ConnectionException {
  RecieveTimeoutException(Uri uri) : super('RecieveTimeoutException', uri);

  @override
  get description => staticLocalization.networkErrors.recieveTimeout;
}

class SendTimeoutException extends ConnectionException {
  SendTimeoutException(Uri uri) : super('SendTimeoutException', uri);

  @override
  get description => staticLocalization.networkErrors.sendTimeout;
}

class SocketException extends ConnectionException {
  SocketException(Uri uri) : super('SocketException', uri);

  @override
  get description => staticLocalization.networkErrors.socketError;
}

class BadCertifacteException extends ConnectionException {
  BadCertifacteException(Uri uri) : super('BadCertificate', uri);

  @override
  get description => staticLocalization.networkErrors.socketError;
}

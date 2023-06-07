import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:template/i18n/strings.g.dart';
import 'package:template/globals.dart';
import 'package:template/template_modules/network/error/network_error_i18n_mixin.dart';
import 'package:template/template_modules/network/error/network_exceptions.dart';

@immutable
class JsonParseException extends NetworkException with NetworkErrorI18NMixin {
  JsonParseException(this.exception)
      : super(exception.message ?? 'json parse error', Uri());

  final CheckedFromJsonException exception;

  @override
  I18NErrorDescription get description =>
      staticLocalization.networkErrors.unknownError;
}

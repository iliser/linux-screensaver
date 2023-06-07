import 'dart:convert';

import '../error/http_exception.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'authorization_value.freezed.dart';
part 'authorization_value.g.dart';

@freezed
abstract class AuthorizationValue implements _$AuthorizationValue {
  const AuthorizationValue._();

  const factory AuthorizationValue.unauthorized() = _Unauthorized;
  const factory AuthorizationValue.basic(String login, String password) =
      _Basic;
  const factory AuthorizationValue.bearer(String token) = _Bearer;
  const factory AuthorizationValue.headerApiKey(String key, String token) =
      _Header;
  const factory AuthorizationValue.queryApiKey(String key, String token) =
      _Query;

  factory AuthorizationValue.fromJson(Map<String, dynamic> json) =>
      _$AuthorizationValueFromJson(json);

  Map<String, dynamic>? get headers => whenOrNull(
        headerApiKey: (key, token) => {key: token},
        bearer: (token) => {'Authorization': 'Bearer $token'},
        basic: (login, password) => {
          'Authorization':
              'Basic ${base64Encode(('$login:$password').codeUnits)}'
        },
        unauthorized: () => throw UnauthorizedException(
          'token is not provided',
          Uri(),
        ),
      );
  Map<String, dynamic>? get query => whenOrNull(
        queryApiKey: (key, token) => {key: token},
        unauthorized: () => throw UnauthorizedException(
          'token is not provided',
          Uri(),
        ),
      );
}

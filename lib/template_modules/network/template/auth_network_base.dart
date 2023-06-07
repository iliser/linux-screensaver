import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template/template_modules/global_authorization_module.dart';

import 'authorization_value.dart';
import 'network_base.dart';
import 'parametrized_network.dart';

export '../cancel_token_extension.dart';

abstract class AuthNetworkBase extends NetworkBase {
  /// for use with `awaitNetwork(ref,Network.value)`
  ///
  /// create network with given authorization value
  AuthNetworkBase.value({
    AsyncParametrizedNetworkTag? tag,
    AuthorizationValue authValue = const AuthorizationValue.unauthorized(),
  }) : authorizationValue = authValue;

  @override
  get args => {#authValue: authorizationProvider};

  late final AuthorizationValue authorizationValue;

  AlwaysAliveProviderBase<AsyncValue<AuthorizationValue>>
      get authorizationProvider => AuthorizationModule.globalTokenProvider;

  @override
  Map<String, String> get defaultHeaders => {
        ...super.defaultHeaders,
        ...?authorizationValue.headers,
      };

  @override
  Map<String, String> get defaultQuery => {
        ...super.defaultQuery,
        ...?authorizationValue.query,
      };
}

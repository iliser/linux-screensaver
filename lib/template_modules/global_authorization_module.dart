import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_persistent_state/riverpod_persistent_state.dart';
import 'package:template/template_modules/network/template/authorization_value.dart';

class AuthorizationModule {
  static const logoutPath = '/login?reset=true';

  static final globalTokenProvider =
      PersistentStateProvider<AuthorizationValue>(
    store: HiveJsonStore(
      defaultValue: () => const AuthorizationValue.unauthorized(),
      boxName: 'authorization_token',
      fromJson: (json) => AuthorizationValue.fromJson(json),
    ),
  );

  static final isAuthorizedProvider = Provider<AsyncValue>(
    (ref) => ref
        .watch(globalTokenProvider)
        .whenData((value) => value != const AuthorizationValue.unauthorized()),
  );

  static Future<void> logout(BuildContext context, WidgetRef ref) async {
    ref
        .read(globalTokenProvider.notifier)
        .update((_) => const AuthorizationValue.unauthorized());

    context.router.popUntilRoot();
    unawaited(context.router.replaceNamed(logoutPath));
  }

  static Future<void> updateToken(
    WidgetRef ref,
    AuthorizationValue newToken,
  ) async {
    ref.read(globalTokenProvider.notifier).update((_) => newToken);
  }
}

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guarded_core/guarded_core.dart';
import 'package:template/template_modules/global_authorization_module.dart';

import '../core.dart';

class AuthorizationGuard extends Guard {
  factory AuthorizationGuard.widget(Widget child) =>
      AuthorizationGuard._((_, __) => GuardCheckResult.widget(child));

  factory AuthorizationGuard.none() =>
      AuthorizationGuard._((_, __) => const GuardCheckResult.none());

  factory AuthorizationGuard.logout() => AuthorizationGuard._(
        (context, ref) {
          Future.microtask(() => AuthorizationModule.logout(context, ref));
          return const GuardCheckResult.none();
        },
      );
  AuthorizationGuard._(this._behavior);

  final GuardCheckResult Function(BuildContext context, WidgetRef ref)
      _behavior;

  @override
  GuardCheckResult check(BuildContext context, WidgetRef ref) {
    final authorizedData = ref.watch(AuthorizationModule.isAuthorizedProvider);
    if (authorizedData is AsyncLoading) {
      return const GuardCheckResult.loading();
    }
    final authorized = authorizedData.asData?.value ?? false;

    if (authorized) {
      return const GuardCheckResult.pass();
    }

    return _behavior(context, ref);
  }
}

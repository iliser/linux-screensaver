import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guarded_core/guard_base.dart';
import 'package:guarded_core/guard_check_result.dart';

import '../core.dart';

class AsyncGuard implements GuardBase, ScreenGuard, WidgetGuard {
  const AsyncGuard(this.providers);

  final List<ProviderBase<AsyncValue>> providers;

  @override
  GuardCheckResult check(BuildContext context, WidgetRef ref) {
    final results = providers.map((e) => ref.watch(e)).toList();

    bool hasLoading = false;
    for (final res in results) {
      if (res is AsyncError) {
        return GuardCheckResult.error(
          res.error,
          stackTrace: res.stackTrace,
        );
      }
      hasLoading |= res is AsyncLoading;
    }

    return hasLoading
        ? const GuardCheckResult.loading()
        : const GuardCheckResult.pass();
  }

  @override
  GuardBase get screenGuard => this;

  @override
  GuardBase get widgetGuard => this;
}

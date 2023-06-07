import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guarded_core/guarded_core.dart';

import '../core.dart';
import 'guarded_empty.dart';

GuardCheckResult _emptyResult({
  required bool isScreen,
  required bool empty,
  required ProviderBase provider,
}) {
  if (empty) {
    if (isScreen) {
      return GuardCheckResult.widget(
        Consumer(
          builder: (context, ref, child) => GuardedScreenTemplate(
            onRefresh: () async => ref.refresh(provider),
            child: const GuardedEmpty(),
          ),
        ),
      );
    }
    return const GuardCheckResult.widget(GuardedEmpty());
  }
  return const GuardCheckResult.pass();
}

class EmptyGuard<T> extends GuardBase implements ScreenGuard, WidgetGuard {
  EmptyGuard(
    this.provider,
    this.valueIsEmpty, {
    this.isScreen = false,
  });

  final bool isScreen;
  final ProviderBase<T> provider;
  final bool Function(T value) valueIsEmpty;

  @override
  GuardCheckResult check(BuildContext context, WidgetRef ref) {
    final empty = valueIsEmpty(ref.watch(provider));
    return _emptyResult(isScreen: isScreen, empty: empty, provider: provider);
  }

  @override
  GuardBase get screenGuard => EmptyGuard(
        provider,
        valueIsEmpty,
        isScreen: true,
      );

  @override
  GuardBase get widgetGuard => EmptyGuard(
        provider,
        valueIsEmpty,
        isScreen: false,
      );

  static EmptyGuard iterable<E>(ProviderBase<Iterable<E>> provider) {
    return EmptyGuard<Iterable<E>>(provider, (value) => value.isEmpty);
  }

  static EmptyGuard nullable<T>(ProviderBase<T?> provider) {
    return EmptyGuard<T?>(provider, (value) => value == null);
  }

  static EmptyGuardAsync asyncIterable<T>(
    ProviderBase<AsyncValue<Iterable<T>>> provider,
  ) {
    return EmptyGuardAsync<Iterable<T>>(provider, (value) => value.isEmpty);
  }

  static EmptyGuardAsync asyncNullable<T>(
    ProviderBase<AsyncValue<T?>> provider,
  ) {
    return EmptyGuardAsync<T?>(provider, (value) => value == null);
  }

  static GuardedConfigurationEmptyWidget emptyWidget(Widget widget) =>
      GuardedConfigurationEmptyWidget(widget);
}

// must be used with async guard or http guard
class EmptyGuardAsync<T> extends GuardBase implements ScreenGuard, WidgetGuard {
  EmptyGuardAsync(
    this.provider,
    this.valueIsEmpty, {
    this.isScreen = false,
  });

  final ProviderBase<AsyncValue<T>> provider;
  final bool Function(T value) valueIsEmpty;
  final bool isScreen;

  @override
  GuardCheckResult check(BuildContext context, WidgetRef ref) {
    final data = ref.watch(provider).asData;
    if (data == null) return const GuardCheckResult.loading();
    final empty = valueIsEmpty(data.value);
    return _emptyResult(isScreen: isScreen, empty: empty, provider: provider);
  }

  @override
  GuardBase get screenGuard => EmptyGuardAsync(
        provider,
        valueIsEmpty,
        isScreen: true,
      );

  @override
  GuardBase get widgetGuard => EmptyGuardAsync(
        provider,
        valueIsEmpty,
        isScreen: false,
      );
}

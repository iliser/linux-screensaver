import 'dart:async';

import 'package:riverpod/riverpod.dart';

extension AsyncValueProviderX on Ref {
  static final _providerCompleter = <int, Completer<dynamic>>{};

  /// watch Provider<AsyncValue<T>> as future
  /// return future that completes when provider has data or error
  /// returned future never completes if provider has't data or error
  Future<T> watchFuture<T>(
    AlwaysAliveProviderListenable<AsyncValue<T>> provider,
  ) {
    // clean up completer
    _providerCompleter.remove(provider.hashCode)?.completeError('completed');

    final state = watch(provider);
    if (state.hasValue) {
      return Future.value(state.requireValue);
    }
    if (state.hasError) {
      return Future.error(state.error!, state.stackTrace);
    }

    final completer = (_providerCompleter[provider.hashCode] ??= Completer<T>())
        as Completer<T>;
    // return never resolved completer
    return completer.future;
  }

  Stream<T> listenStream<T>(
    AlwaysAliveProviderListenable<AsyncValue<T>> provider,
  ) {
    final controller = StreamController<T>();
    final sub = listen(
      provider,
      (previous, next) {
        if (next is AsyncData) controller.add(next.asData!.value);
        if (next is AsyncError) {
          controller.addError(
            next.asError!.error,
            next.asError!.stackTrace,
          );
        }
      },
    );
    onDispose(() {
      sub.close();
      controller.close();
    });

    return controller.stream;
  }
}

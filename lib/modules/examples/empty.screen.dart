import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template/template_modules/guards/guard.dart';

final emptyProvider = StateProvider((_) => <String>[]);

final emptyAsyncProvider = FutureProvider(
  (_) => Future.delayed(const Duration(seconds: 5), () => <String>[]),
);

@RoutePage()
class EmptyScreenExample extends GuardedScreen {
  const EmptyScreenExample({Key? key}) : super(key: key);

  @override
  List<ScreenGuard> get guards => [EmptyGuard.iterable(emptyProvider)];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}

@RoutePage()
class AsyncEmptyScreenExample extends GuardedScreen {
  const AsyncEmptyScreenExample({Key? key}) : super(key: key);

  @override
  List<ScreenGuard> get guards => [
        EmptyGuard.asyncIterable(emptyAsyncProvider),
      ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}

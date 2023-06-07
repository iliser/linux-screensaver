import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template/template_modules/guards/guard.dart';

final _f0 = FutureProvider.autoDispose(
  (_) => Future.delayed(const Duration(seconds: 5)),
);

final _f1 = FutureProvider.autoDispose(
  (_) async {
    await Future.delayed(const Duration(seconds: 3));
    // throw 'err';
  },
);

final _f2 = FutureProvider.autoDispose(
  (_) async {
    await Future.delayed(const Duration(seconds: 6));
  },
);

final _e0 = FutureProvider.autoDispose(
  (_) async {
    await Future.delayed(const Duration(seconds: 3));
    throw 'err';
  },
);

@RoutePage()
class AsyncGuardExampleScreen extends GuardedScreen {
  const AsyncGuardExampleScreen(@QueryParam() this.error, {Key? key})
      : super(key: key);

  final String? error;

  // this prevents blinking to loading state
  @override
  bool get keepOldDataOnLoading => true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Async Guard Example'),
      ),
      body: const SafeArea(
        child: Center(
          child: Text('All is fine'),
        ),
      ),
    );
  }

  @override
  List<ScreenGuard> get guards => [
        AsyncGuard([_f0, _f1, _f2, if (error != null) _e0])
      ];
}

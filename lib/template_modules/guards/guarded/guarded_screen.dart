import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:guarded_core/configuration/guarded_configuration.dart';
import 'package:guarded_core/guarded_core.dart';
import 'package:template/globals.dart';
import 'package:template/template_modules/guards/guarded/guarded_error.dart';
import 'package:template/template_modules/guards/guarded/guarded_loading.dart';

import 'guard.dart';
import 'guarded_screen_template.dart';

abstract class GuardedScreen extends GuardedWidgetBase {
  const GuardedScreen({Key? key}) : super(key: key);

  @visibleForOverriding
  List<ScreenGuard> get guards;

  @override
  Iterable<GuardedConfiguration> get rawConfiguration => [
        Guarded.errorBuilder(_GuardedErrorBuilder.new),
        Guarded.loadingWidget(const _GuardedLoading()),
        Guarded.noneWidget(const SizedBox.shrink()),
      ];

  @override
  Iterable<GuardBase> get rawGuards => guards.map((e) => e.screenGuard);
}

class _GuardedErrorBuilder extends ConsumerWidget {
  const _GuardedErrorBuilder(this.error, this.stackTrace);

  final dynamic error;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final T = ref.watch(localizationProvider);
    return GuardedScreenTemplate(
      title: Text(T.guarded.generalErrorTitle),
      child: GuardedErrorWidget(error, stackTrace),
    );
  }
}

class _GuardedLoading extends ConsumerWidget {
  const _GuardedLoading();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final T = ref.watch(localizationProvider);
    return GuardedScreenTemplate(
      title: Text(T.guarded.loadingTitle),
      child: const GuardedLoadingWidget(),
    );
  }
}

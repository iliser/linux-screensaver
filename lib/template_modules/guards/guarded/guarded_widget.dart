import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:guarded_core/configuration/guarded_configuration.dart';
import 'package:guarded_core/guarded_core.dart';

import 'guard.dart';
import 'guarded_error.dart';
import 'guarded_loading.dart';

// To redefine loading,error,none widgets prefer extends this classes
abstract class GuardedWidget extends GuardedWidgetBase {
  const GuardedWidget({Key? key}) : super(key: key);

  @visibleForOverriding
  List<WidgetGuard> get guards;

  @override
  Iterable<GuardedConfiguration> get rawConfiguration => [
        Guarded.errorBuilder(GuardedErrorWidget.new),
        Guarded.loadingWidget(const GuardedLoadingWidget()),
      ];

  @nonVirtual
  @override
  List<GuardBase> get rawGuards => guards.map((e) => e.widgetGuard).toList();
}

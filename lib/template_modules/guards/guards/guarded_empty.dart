import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guarded_core/configuration/guarded_configuration.dart';
import 'package:template/globals.dart';

class GuardedEmptyWidget extends ConsumerWidget {
  const GuardedEmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final T = ref.watch(localizationProvider);
    return Center(
      child: Text(
        T.guarded.emptyMessage,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class GuardedConfigurationEmptyWidget extends GuardedConfiguration {
  GuardedConfigurationEmptyWidget(this.emptyWidget);

  static GuardedConfigurationEmptyWidget? watch(WidgetRef ref) =>
      GuardedConfiguration.watch<GuardedConfigurationEmptyWidget>(ref);

  final Widget emptyWidget;
}

class GuardedEmpty extends ConsumerWidget {
  const GuardedEmpty({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = GuardedConfigurationEmptyWidget.watch(ref);
    if (config != null) return config.emptyWidget;

    return const GuardedEmptyWidget();
  }
}

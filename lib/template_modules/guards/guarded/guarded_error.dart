import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template/globals.dart';

class GuardedErrorWidget extends ConsumerWidget {
  const GuardedErrorWidget(
    this.error,
    this.stackTrace, [
    this.onRefresh,
    Key? key,
  ]) : super(key: key);

  final Future Function()? onRefresh;
  final dynamic error;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final T = ref.watch(localizationProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          T.guarded.generalErrorMessage,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

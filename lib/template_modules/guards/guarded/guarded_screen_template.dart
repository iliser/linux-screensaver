import 'package:flutter/material.dart';

class GuardedScreenTemplate extends StatelessWidget {
  const GuardedScreenTemplate({
    Key? key,
    this.onRefresh,
    required this.child,
    this.title,
  }) : super(key: key);

  final Future<void> Function()? onRefresh;

  final Widget? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: title),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => await onRefresh?.call(),
          child: CustomScrollView(
            slivers: [SliverFillRemaining(child: child)],
          ),
        ),
      ),
    );
  }
}

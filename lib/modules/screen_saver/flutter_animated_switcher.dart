import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// transition builder analog to use with flutter_animate
typedef AnimatedBuilder = Widget Function(
  Widget child,
  AnimationController controller,
  Duration duration,
);

// widget like animated switcher but allow to use animation from flutter_animate
// and define in and out animation
class FlutterAnimatedSwitcher extends StatefulWidget {
  const FlutterAnimatedSwitcher({
    super.key,
    required this.inAnimated,
    required this.outAnimated,
    required this.inDuration,
    required this.outDuration,
    required this.child,
  });

  factory FlutterAnimatedSwitcher.fromAnimation({
    Key? key,
    required SwitchAnimation animation,
    required Widget child,
  }) =>
      FlutterAnimatedSwitcher(
        key: key,
        inAnimated: animation.inAnimated,
        outAnimated: animation.outAnimated,
        inDuration: animation.duration,
        outDuration: animation.duration,
        child: child,
      );

  final AnimatedBuilder inAnimated;
  final AnimatedBuilder outAnimated;
  final Duration inDuration;
  final Duration outDuration;
  final Widget child;

  @override
  State<FlutterAnimatedSwitcher> createState() =>
      _FlutterAnimatedSwitcherState();
}

class _FlutterAnimatedSwitcherState extends State<FlutterAnimatedSwitcher>
    with SingleTickerProviderStateMixin {
  late AnimationController controller = AnimationController(
    vsync: this,
    duration: widget.inDuration + widget.outDuration,
  );

  double target = 0;

  late Widget child = widget.child;
  Widget? currentAnimatedChild;
  Widget? nextChild;

  bool animateIn = false;

  int cid = 0;

  void replanAnimation() {
    if (nextChild == null) return;
    // animate if we not animate other widget replace
    if (currentAnimatedChild == null) {
      target = 1;
      currentAnimatedChild = nextChild;
      nextChild = null;
      controller.forward(from: 0);
      setState(() {});
    } else if (animateIn == false) {
      // if animation in out stage we can replace currentAnimatedChild without effects
      currentAnimatedChild = nextChild;
      nextChild = null;
    }
  }

  void _onOutComplete() {
    if (controller.value == 0) return;
    if (currentAnimatedChild != null) {
      setState(() {
        child = currentAnimatedChild!;
        animateIn = true;
        controller.forward(from: 0);
      });
    }
  }

  void _onInComplete() {
    setState(() {
      target = 0;
      animateIn = false;
      controller.value = 0;
      currentAnimatedChild = null;
    });
    Future.microtask(() => replanAnimation());
  }

  @override
  void initState() {
    controller.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          animateIn ? _onInComplete() : _onOutComplete();
        }
      },
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FlutterAnimatedSwitcher oldWidget) {
    if (oldWidget.child.key != widget.child.key) {
      nextChild = widget.child;
      replanAnimation();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return currentAnimatedChild != null
        ? animateIn
            ? widget.inAnimated(child, controller, widget.inDuration)
            : widget.outAnimated(child, controller, widget.outDuration)
        : child;
  }
}

@immutable
class SwitchAnimation {
  factory SwitchAnimation.flyUp([
    Duration duration = const Duration(milliseconds: 150),
  ]) =>
      SwitchAnimation(
        outAnimated: (child, controller, duration) => child
            .animate(controller: controller)
            .slideY(end: -1, duration: duration)
            .fadeOut(),
        inAnimated: (child, controller, duration) => child
            .animate(controller: controller)
            .slideY(begin: 1, duration: duration)
            .fadeIn(),
        duration: duration,
      );

  factory SwitchAnimation.flyDown([
    Duration duration = const Duration(milliseconds: 150),
  ]) =>
      SwitchAnimation(
        outAnimated: (child, controller, duration) => child
            .animate(controller: controller)
            .slideY(end: 1, duration: duration)
            .fadeOut(),
        inAnimated: (child, controller, duration) => child
            .animate(controller: controller)
            .slideY(begin: -1, duration: duration)
            .fadeIn(),
        duration: duration,
      );

  const SwitchAnimation({
    required this.inAnimated,
    required this.outAnimated,
    required this.duration,
  });

  final Duration duration;
  final AnimatedBuilder inAnimated;
  final AnimatedBuilder outAnimated;
}

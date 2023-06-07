import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:template/globals.dart';

class CustomDialog {
  CustomDialog._();

  static Widget transitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return _CustomTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      child: child,
    );
  }

  // animation optimized for bottom aligned widgets
  //  fast initial part and slow on bottom
  static Widget alignedBottomTransitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return _CustomTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      curve: Curves.easeInOutCubic,
      child: child,
    );
  }
}

Future<T?> showAnimatedDialog<T>({
  required BuildContext context,
  required Widget child,
  EdgeInsets? padding,
  Alignment? alignment,
}) {
  FocusManager.instance.primaryFocus?.unfocus();

  return showGeneralDialog(
    context: context,
    transitionDuration: config.defaultAnimationDuration * 2,
    transitionBuilder: CustomDialog.alignedBottomTransitionBuilder,
    pageBuilder: (context, animation, secondaryAnimation) =>
        CustomDialogPage(padding: padding, alignment: alignment, child: child),
  );
}

class _CustomTransition extends StatefulWidget {
  const _CustomTransition({
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
    this.curve,
  });

  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;
  final Curve? curve;

  @override
  State<_CustomTransition> createState() => __CustomTransitionState();
}

class __CustomTransitionState extends State<_CustomTransition> {
  late final animation = widget.curve != null
      ? CurvedAnimation(
          parent: widget.animation,
          curve: widget.curve!,
          reverseCurve: widget.curve,
        )
      : widget.animation;

  bool popped = false;
  @override
  Widget build(BuildContext context) {
    final offsetAnimation = (widget.animation.status == AnimationStatus.reverse
            ? Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0))
            : Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0)))
        .animate(animation);

    final blurAnimation =
        Tween<double>(begin: 0, end: 2).animate(widget.animation);

    return GestureDetector(
      onTap: () {
        // prevent multiple pop while animating
        if (popped) return;
        Navigator.pop(context);
        popped = true;
      },
      child: AnimatedBuilder(
        animation: blurAnimation,
        builder: (context, child) => BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurAnimation.value,
            sigmaY: blurAnimation.value,
          ),
          child: child,
        ),
        child: FadeTransition(
          opacity: widget.animation,
          child: SlideTransition(
            position: offsetAnimation,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class CustomDialogPage extends StatelessWidget {
  const CustomDialogPage({
    super.key,
    required this.child,
    this.padding,
    this.alignment,
  });

  final EdgeInsets? padding;
  final Alignment? alignment;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    const defaultPadding = EdgeInsets.only(
      bottom: 16.0,
      right: 8,
      left: 8,
      top: 8,
    );

    final efficientPadding = padding ?? defaultPadding;
    final mq = MediaQuery.of(context);

    return ColoredBox(
      color: Colors.transparent,
      child: Padding(
        padding: efficientPadding.copyWith(
          bottom: efficientPadding.bottom + mq.viewInsets.bottom,
          top: efficientPadding.top + mq.viewPadding.top,
        ),
        child: Align(
          alignment: alignment ?? Alignment.bottomRight,
          child: SizedBox(
            width: 360,
            child: GestureDetector(
              onTap: () {},
              child: MediaQuery.removeViewInsets(
                context: context,
                removeBottom: true,
                child: Builder(
                  builder: (context) => MediaQuery.removeViewPadding(
                    context: context,
                    removeTop: true,
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// add ink well to element, but also add transparent material to draw splash correct
class TapableBox extends StatelessWidget {
  const TapableBox({
    Key? key,
    required this.child,
    this.onTap,
    this.borderRadius,
    this.onLongPress,
    this.onDoubleTap,
  }) : super(key: key);

  final Widget child;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final void Function()? onDoubleTap;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        child,
        Positioned.fill(
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onLongPress: onLongPress,
              onDoubleTap: onDoubleTap,
              onTap: onTap,
              borderRadius: borderRadius,
            ),
          ),
        ),
      ],
    );
  }
}

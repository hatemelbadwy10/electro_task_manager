import 'package:flutter/material.dart';

class CustomAnimatedContainer extends StatelessWidget {
  final Widget child;
  final Decoration? decoration;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Duration duration;
  final Curve curve;

  const CustomAnimatedContainer({
    super.key,
    required this.child,
    this.decoration,
    this.padding = EdgeInsets.zero,
    this.margin,
    this.duration = const Duration(milliseconds: 220),
    this.curve = Curves.easeOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      padding: padding,
      margin: margin,
      decoration: decoration,
      child: AnimatedSize(
        duration: duration,
        curve: curve,
        alignment: AlignmentDirectional.topCenter,
        child: child,
      ),
    );
  }
}

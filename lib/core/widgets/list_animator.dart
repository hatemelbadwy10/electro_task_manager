import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AnimatedWidgets extends StatelessWidget {
  final Widget child;
  final double verticalOffset;
  final double horizontalOffset;
  final int durationMilli;
  final int position;

  const AnimatedWidgets({
    super.key,
    required this.child,
    this.verticalOffset = 50,
    this.horizontalOffset = 0,
    this.durationMilli = 500,
    this.position = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: position,
      duration: Duration(milliseconds: durationMilli),
      child: SlideAnimation(
        curve: Curves.easeInOut,
        horizontalOffset: horizontalOffset,
        verticalOffset: verticalOffset,
        child: FadeInAnimation(child: child),
      ),
    );
  }
}

class ListAnimator extends StatelessWidget {
  final List<Widget> data;
  final int durationMilli;
  final double verticalOffset;
  final double horizontalOffset;
  final ScrollController? controller;
  final Axis direction;
  final bool addPadding;
  final bool reverse;
  final bool scroll;
  final EdgeInsetsGeometry? customPadding;
  final ScrollPhysics? physics;

  const ListAnimator({
    super.key,
    required this.data,
    this.controller,
    this.durationMilli = 1000,
    this.verticalOffset = 30,
    this.horizontalOffset = 50,
    this.direction = Axis.vertical,
    this.addPadding = true,
    this.reverse = false,
    this.customPadding,
    this.scroll = true,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: SingleChildScrollView(
        controller: controller,
        padding: customPadding ?? EdgeInsets.only(top: addPadding ? 8 : 0),
        physics:
            physics ??
            (scroll
                ? const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  )
                : const NeverScrollableScrollPhysics()),
        reverse: reverse,
        scrollDirection: direction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(data.length, (index) {
            final offset = index.isEven ? horizontalOffset : -horizontalOffset;
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: Duration(milliseconds: durationMilli),
              child: SlideAnimation(
                verticalOffset: verticalOffset,
                horizontalOffset: offset,
                child: FadeInAnimation(
                  child: ScaleAnimation(
                    scale: 0.9,
                    curve: Curves.easeOutBack,
                    child: data[index],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

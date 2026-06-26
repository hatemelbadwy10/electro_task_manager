import 'package:flutter/material.dart';

const Duration extensionTransitionDuration = Duration(milliseconds: 180);

extension WidgetExtensions on Widget {
  Widget setContainerToView({
    double? height,
    double? width,
    double? margin,
    double? padding,
    double? radius,
    Color? color,
    Color? borderColor,
    AlignmentGeometry? alignment,
    List<BoxShadow>? shadows,
    Gradient? gradient,
  }) {
    return AnimatedContainer(
      duration: extensionTransitionDuration,
      width: width,
      height: height,
      alignment: alignment,
      margin: EdgeInsets.all(margin ?? 0),
      padding: EdgeInsets.all(padding ?? 0),
      decoration: ShapeDecoration(
        color: gradient == null ? color : null,
        gradient: gradient,
        shadows: shadows,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 0)),
          side: borderColor == null
              ? BorderSide.none
              : BorderSide(color: borderColor),
        ),
      ),
      child: Material(type: MaterialType.transparency, child: this),
    );
  }

  Widget onTap(
    VoidCallback? onTap, {
    BorderRadius? borderRadius,
    Color? splashColor,
    Color? highlightColor,
    bool isTransparent = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        splashColor: isTransparent ? Colors.transparent : splashColor,
        highlightColor: isTransparent ? Colors.transparent : highlightColor,
        child: this,
      ),
    );
  }

  Widget center({bool enabled = true}) {
    return enabled ? Center(child: this) : this;
  }

  Widget expand({int flex = 1, bool enabled = true}) {
    return enabled ? Expanded(flex: flex, child: this) : this;
  }

  Widget flexible({int flex = 1, FlexFit fit = FlexFit.loose}) {
    return Flexible(flex: flex, fit: fit, child: this);
  }

  Widget visible(bool visible, {Widget fallback = const SizedBox.shrink()}) {
    return visible ? this : fallback;
  }
}

extension PaddingExtensions on Widget {
  Padding paddingAll(double padding) {
    return Padding(padding: EdgeInsets.all(padding), child: this);
  }

  Padding paddingHorizontal(double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: this,
    );
  }

  Padding paddingVertical(double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: this,
    );
  }

  Padding paddingSymmetric(double horizontal, double vertical) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: this,
    );
  }

  Padding paddingTop(double top) {
    return Padding(
      padding: EdgeInsets.only(top: top),
      child: this,
    );
  }

  Padding paddingBottom(double bottom) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: this,
    );
  }

  Padding paddingStart(double start) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: start),
      child: this,
    );
  }

  Padding paddingEnd(double end) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: end),
      child: this,
    );
  }
}

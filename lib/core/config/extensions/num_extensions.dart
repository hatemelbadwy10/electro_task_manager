import 'package:flutter/material.dart';

extension NumExtensions on num? {
  num validate({num defaultValue = 0}) => this ?? defaultValue;

  SizedBox get gap {
    final value = validate().toDouble();
    return SizedBox(height: value, width: value);
  }

  EdgeInsets get edgeInsetsAll => EdgeInsets.all(validate().toDouble());

  EdgeInsets get edgeInsetsHorizontal {
    return EdgeInsets.symmetric(horizontal: validate().toDouble());
  }

  EdgeInsets get edgeInsetsVertical {
    return EdgeInsets.symmetric(vertical: validate().toDouble());
  }

  BorderRadius get borderRadius {
    return BorderRadius.circular(validate().toDouble());
  }

  Radius get radius => Radius.circular(validate().toDouble());
}

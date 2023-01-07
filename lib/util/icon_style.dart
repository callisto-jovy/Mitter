import 'package:flutter/material.dart';

///Taken from: https://github.com/babstrap/babstrap_settings_screen/blob/main/lib/src/icon_style.dart and modified (under MIT)
class IconStyle {
  Color? iconsColor;
  bool? withBackground;
  Color? backgroundColor;
  double? borderRadius;

  IconStyle({
    this.iconsColor = Colors.white,
    this.withBackground = true,
    this.backgroundColor = Colors.blue,
    borderRadius = 8,
  }) : borderRadius = double.parse(borderRadius!.toString());
}

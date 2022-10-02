import 'package:flutter/material.dart';

@immutable
class AppColors {
  static const colorPrimary = Color(0xffa487e7);
  static const colorPrimaryDark = Color(0xFF7B55D3);
  static const colorAccent = Color(0xff89C6FF);

  final colorCard = const Color(0xfff4f6fc);
  final roundBG = Colors.white;
  final regularText = const Color(0xff4f515a);
  final paleText = const Color(0xff939393);
  final brightText = colorPrimary;
  final regularBackground = colorPrimaryDark;

  const AppColors();
}
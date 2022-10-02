import "package:flutter/material.dart";
import 'colors.dart';

class AppTheme {

  static const colors = AppColors();
  const AppTheme._();

  static ThemeData define(BuildContext context) {
    return ThemeData(
      fontFamily: "SFRegular",
      scaffoldBackgroundColor: colors.colorCard,
      colorScheme: ThemeData().colorScheme.copyWith(
        primary: AppTheme.colors.brightText,
      ),
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(color:AppTheme.colors.regularText),
      ),
      // primarySwatch: Colors.deepPurple,
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,

    );
  }


}


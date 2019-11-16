import 'package:flutter/material.dart';

enum ThemesKey { Light, Dark }

class Themes {
  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    bottomAppBarColor: Color(0xff282C3A),
    buttonColor: Color(0xff28629C),
    backgroundColor: Color(0xff1E212A),
    cardColor: Color(0xff333742),
    accentTextTheme: TextTheme(
        title: TextStyle(
            fontFamily: 'Montserrat-bold',
            color: Color(0xffAEADB0),
            fontSize: 16),
        body1: TextStyle(
            fontFamily: 'Montserrat-Light',
            color: Color(0xffAEADB0),
            fontSize: 13)),
  );

  static final ThemeData light = ThemeData(
      brightness: Brightness.light,
      buttonColor: Color(0xff4373F3),
      backgroundColor: Color(0xffF1F5FF),
      accentTextTheme: TextTheme(
          title: TextStyle(
              fontFamily: 'Montserrat-bold',
              color: Color(0xff515F79),
              fontSize: 16),
          body1: TextStyle(
              fontFamily: 'Montserrat-Light',
              color: Color(0xff515F79),
              fontSize: 13)));

  static ThemeData getThemeFromKey(ThemesKey key) {
    switch (key) {
      case ThemesKey.Light:
        return light;
        break;
      case ThemesKey.Dark:
        return dark;
        break;
    }
  }
}

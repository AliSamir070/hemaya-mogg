import 'package:flutter/material.dart';

abstract class ColorManager {
  static Color primary = const Color(0xFF004182);
  static Color appBarTitleColor = const Color(0xFF06004F);
  static Color primaryDark = const Color(0xFF06004F);

  static Color darkGrey = const Color(0xff525252);
  static Color grey = const Color(0xff737477);
  static Color lightGrey = const Color(0xff9E9E9E);
  static Color black = const Color(0xff000000);
  static Color containerGray = const Color(0xffDBE4ED);
  static Color transparent = Colors.transparent;

  static const Color starRateColor = Color(0XFFFDD835);
  static const Color textColor = Color(0xff06004F);
  static Color darkBlue = const Color(0xff06004F);
  static Color yellow = const Color(0xFFFDD835);

  // new colors
  static Color darkPrimary = const Color(0xffd17d11);
  static Color lightPrimary = const Color(0xCCd17d11); // color with 80% opacity
  static Color grey1 = const Color(0xff707070);
  static Color grey2 = const Color(0xff797979);
  static Color white = const Color(0xffFFFFFF);
  static Color error = const Color(0xffe61f34); // red color

  // Home (dark) design tokens — extracted from Figma "eWeLink Home" frames
  static const Color homeBackground = Color(0xFF080D1A);
  static const Color surface = Color(0xFF121A2E);
  static const Color surfaceLight = Color(0xFF1B2A4A);
  static const Color sky = Color(0xFF38BDF8);
  static const Color indigo = Color(0xFF818CF8);
  static const Color orange = Color(0xFFFF8A4C);
  static const Color emerald = Color(0xFF34D399);
  static const Color slate = Color(0xFF8A96B2);
  static const Color ink = Color(0xFF06101F);
  static const Color pureWhite = Color(0xFFFFFFFF);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [sky, indigo],
  );
}

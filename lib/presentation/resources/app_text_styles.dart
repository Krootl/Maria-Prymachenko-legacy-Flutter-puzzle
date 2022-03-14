import 'package:flutter/widgets.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get headline3 => const TextStyle(
        fontFamily: 'NotoSans',
        fontSize: 36,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle get headline4 => const TextStyle(
        fontFamily: 'NotoSans',
        fontSize: 26,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle get headline5 => const TextStyle(
        fontFamily: 'NotoSans',
        fontSize: 25,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle get headline6 => const TextStyle(
        fontFamily: 'NotoSans',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle get body1 => const TextStyle(
        fontFamily: 'NotoSans',
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get subtitle1 => const TextStyle(
        fontFamily: 'NotoSans',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.5,
      );

  static TextStyle get subtitle2 => const TextStyle(
        fontFamily: 'NotoSans',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );
}

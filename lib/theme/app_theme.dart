import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // カラー
  static const Color bg = Color(0xFFF7F6F2);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surface2 = Color(0xFFF1EFE9);
  static const Color ink = Color(0xFF1A1714);
  static const Color ink2 = Color(0xFF4A4540);
  static const Color ink3 = Color(0xFF8A847D);
  static const Color ink4 = Color(0xFFC5BEB5);
  static const Color line = Color(0xFFECE8E0);
  static const Color accent = Color(0xFF6C5CE7);
  static const Color accentSoft = Color(0xFFECE9FF);
  static const Color success = Color(0xFF2EC27E);
  static const Color danger = Color(0xFFE0535B);

  // スペーシング
  static const double screenPadding = 24;
  static const double cardPadding = 20;

  // 角丸
  static const double rSm = 10;
  static const double rMd = 14;
  static const double rLg = 20;
  static const double rXl = 28;

  static ThemeData get theme => ThemeData(
        scaffoldBackgroundColor: bg,
        colorScheme: const ColorScheme.light(
          primary: accent,
          surface: surface,
          error: danger,
        ),
        fontFamily: 'Helvetica Neue',
        appBarTheme: const AppBarTheme(
          backgroundColor: bg,
          foregroundColor: ink,
          elevation: 0,
          centerTitle: false,
        ),
      );
}

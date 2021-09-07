import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final themeData = ThemeData(
  colorScheme: _colorScheme,
  iconTheme: const IconThemeData(color: Color(0xffBEBEBE)),
  floatingActionButtonTheme: _fabTheme,
  appBarTheme: _appBarTheme,
  textTheme: _textTheme,
);

const _colorScheme = ColorScheme.dark(
    onBackground: Color(0xff393939),
    onPrimary: Colors.white,
    primary: Color(0xff306F1A),
    primaryVariant: Color(0xff275119),
    secondary: Color(0xff47aca4));

const _fabTheme =
    FloatingActionButtonThemeData(backgroundColor: Color(0xff393939));

final _textTheme = TextTheme(
  headline4: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 36),
  headline5: GoogleFonts.poppins(
      fontWeight: FontWeight.bold,
      fontSize: 24,
      color: const Color(0xff7d7d7d)),
  headline6: GoogleFonts.poppins(fontWeight: FontWeight.w300, fontSize: 24),
  subtitle1: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
);

final _appBarTheme = AppBarTheme(
    toolbarHeight: 80,
    centerTitle: true,
    elevation: 0,
    titleTextStyle: _textTheme.headline6,
    backgroundColor: Color(0xff303030));

import 'package:flutter/material.dart';

ThemeData buildTheme() {
  // We're going to define all of our font styles
  // in this method:
  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      headline: base.headline.copyWith(
        fontFamily: 'Merriweather',
        fontSize: 25.0,
        color: const Color(0xFF0D0402),
      ),
      title: base.title.copyWith(
        fontFamily: 'Signature of the Ancient',
        fontSize: 20.0,
        fontStyle: FontStyle.italic,
        color: const Color(0xFF0A0080),
      ),
      subtitle: base.subtitle.copyWith(
        fontFamily: 'Merriweather',
        fontSize: 16.0,
        fontStyle: FontStyle.normal,
        color: const Color(0xFF0D0402),
      ),
    );
  }

  // We want to override a default light blue theme.
  final ThemeData base = ThemeData.light();
  //final ThemeData base2 = ThemeData.light();

  // And apply changes on it:
  return base.copyWith(
    textTheme: _buildTextTheme(base.textTheme),
  );
}

// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class GeneralTheme {
  final int contrast;
  final background;
  final primaryColor;
  final secondaryColor;
  final Brightness brightness;

  GeneralTheme({
    required this.contrast,
    required this.background,
    required this.primaryColor,
    required this.secondaryColor,
    required this.brightness,
  });

  WidgetStateProperty<Color?> _switchColors({bool dark = true}) {
    final color = dark ? primaryColor : primaryColor[contrast];

    return WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) => color,
    );
  }

  _getFloatingTheme() =>
      FloatingActionButtonThemeData(backgroundColor: primaryColor);

  _buttonStyle() => ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey;
            }
            return primaryColor;
          },
        ),
      );

  _getTextButtonTheme() => TextButtonThemeData(style: _buttonStyle());

  _getElevatedButtonTheme() => ElevatedButtonThemeData(style: _buttonStyle());

  ThemeData getData() => ThemeData(
        primaryColor: background,
        brightness: brightness,
        switchTheme: SwitchThemeData(
          thumbColor: _switchColors(),
          trackColor: _switchColors(dark: false),
          trackOutlineColor: _switchColors(),
        ),
        floatingActionButtonTheme: _getFloatingTheme(),
        textButtonTheme: _getTextButtonTheme(),
        elevatedButtonTheme: _getElevatedButtonTheme(),
      );
}

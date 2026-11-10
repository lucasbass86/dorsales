import 'package:dorsales/utils/utils.dart';
import 'package:flutter/material.dart';

ThemeData getTheme2() {
  return ThemeData.from(
          colorScheme: ColorScheme.fromSeed(seedColor: Utils.blue, brightness: Brightness.dark))
      .copyWith(
    splashColor: Colors.blue[300],
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Utils.blue, // Color del cursor
      selectionColor: Utils.blueText, // Color de la selección del texto
      selectionHandleColor: Utils.blue, // Color del indicador al seleccionar
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) => Utils.blue),
        foregroundColor: WidgetStateProperty.resolveWith((states) => Colors.white),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) => Utils.blue),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.white, fontSize: 20),
      prefixIconColor: Utils.grey,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.grey[700]!,
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.grey[700]!,
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
    ),
    switchTheme: SwitchThemeData(
      trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? Utils.grey : null),
      thumbColor: WidgetStateColor.resolveWith(
        (states) => states.contains(WidgetState.selected) ? Utils.blue : Colors.grey[800]!,
      ),
      trackColor: WidgetStatePropertyAll(Utils.grey),
    ),
    datePickerTheme: DatePickerThemeData(
      todayBackgroundColor: WidgetStateColor.resolveWith(
        (states) => states.contains(WidgetState.selected) ? Utils.blue : Colors.grey[800]!,
      ),
      dayBackgroundColor: WidgetStateColor.resolveWith(
        (states) => states.contains(WidgetState.selected) ? Utils.blue : Colors.transparent,
      ),
      cancelButtonStyle: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(Utils.blue),
      ),
      confirmButtonStyle: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(Utils.blue),
      ),
      dayOverlayColor: WidgetStatePropertyAll(Utils.blue.withAlpha(100)),
    ),
  );
}

ThemeData getTheme() {
  return ThemeData.dark().copyWith(
    splashColor: Colors.blue[300],
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Utils.blue, // Color del cursor
      selectionColor: Utils.blueText, // Color de la selección del texto
      selectionHandleColor: Utils.blue, // Color del indicador al seleccionar
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) => Utils.blue),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) => Utils.blue),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.white, fontSize: 20),
      prefixIconColor: Utils.grey,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.grey[700]!,
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.grey[700]!,
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
    ),
    switchTheme: SwitchThemeData(
      trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? Utils.grey : null),
      thumbColor: WidgetStateColor.resolveWith(
        (states) => states.contains(WidgetState.selected) ? Utils.blue : Colors.grey[800]!,
      ),
      trackColor: WidgetStatePropertyAll(Utils.grey),
    ),
    datePickerTheme: DatePickerThemeData(
      todayBackgroundColor: WidgetStateColor.resolveWith(
        (states) => states.contains(WidgetState.selected) ? Utils.blue : Colors.grey[800]!,
      ),
      dayBackgroundColor: WidgetStateColor.resolveWith(
        (states) => states.contains(WidgetState.selected) ? Utils.blue : Colors.transparent,
      ),
      cancelButtonStyle: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(Utils.blue),
      ),
      confirmButtonStyle: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(Utils.blue),
      ),
      dayOverlayColor: WidgetStatePropertyAll(Utils.blue.withAlpha(100)),
    ),
  );
}

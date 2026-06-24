import 'package:dorsales/utils/utils.dart';
import 'package:flutter/material.dart';

ThemeData getTheme() {
  return ThemeData.dark().copyWith(
    splashColor: Colors.grey,
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
          color: Colors.grey,
          style: BorderStyle.solid,
          width: 3.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.grey[700]!,
          style: BorderStyle.solid,
          width: 1,
        ),
      ),
    ),
  );
}

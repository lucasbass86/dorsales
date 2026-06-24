import 'dart:io';

import 'package:dorsales/secret/secret.dart';
import 'package:flutter/material.dart';

class Utils {
  static String password = Secret.masterPassword;
  static String urlUpdatePath = Secret.urlUpdatePath;
  static bool isConnected = false;
  static const String Todo = 'Todo';

  static const String Distancia = 'Distancia';
  static const String Fecha = 'Fecha';
  static const String Dorsal = 'Dorsal';
  static const String Tiempo = 'Tiempo';
  static const String Ritmo = 'Ritmo';

  static const String Buscar = 'Buscar';

  static const String Ascendente = 'Ascendente';
  static const String Descendente = 'Descendente';

  static DateTime fechaInicio = DateTime.now();
  static DateTime fechaFin = DateTime.now();

  static const List<String> orders = [Distancia, Fecha, Dorsal, Tiempo, Ritmo];
  static const List<String> ascDesc = [Ascendente, Descendente];

  static Color cMenos5000 = const Color(0xFF4677F0);
  static Color c5000 = const Color(0xFF48ABFA);
  static Color cMas5Menos10 = const Color(0xFF4DC7E3);
  static Color c10000 = const Color(0xFF48FAEB);
  static Color cMas10Menos21 = const Color(0xFF46F0B1);
  static Color c21097 = const Color(0xFFF2A861);
  static Color cMas21Menos42 = const Color(0xFFFC9965);
  static Color c42195 = const Color(0xFFE68168);
  static Color cMas42 = const Color(0xFFfc6d65);

  static const String sTodas = 'TODAS';
  static const String sTodos = 'TODOS';
  static TextStyle styleBig = TextStyle(color: blueText, fontWeight: FontWeight.bold, fontSize: 25);
  static List<String> distances = [];
  static List<String> years = [];

  static final Color blueText = Colors.blue[100]!;
  static final Color grey = Colors.grey[600]!;
  static final Color greyShadow = Colors.grey[200]!;
  static final Color blue = Colors.blue[300]!;

  static const double blurRadius = 7;
  static const double filterWidgetSize = 100;
  static const double filterWidgetFontSize = 23;

  static snackBar(BuildContext context, String texto, bool isBad) {
    SnackBar snackBar = SnackBar(
      content: Text(texto),
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      backgroundColor: isBad ? Colors.red[300] : Colors.blue[200],
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('www.google.es');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
        return true;
      } else {
        isConnected = false;
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}

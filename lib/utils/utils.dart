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

  static final Color blueText = Colors.blue[100]!;
  static final Color grey = Colors.grey[600]!;
  static final Color greyShadow = Colors.grey[200]!;
  static final Color blue = Colors.blue[300]!;

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

  static const double blurRadius = 7;
  static const double filterWidgetSize = 100;
  static const double filterWidgetFontSize = 23;

  static String dateEnglishToSpanish(
    DateTime dateTime, {
    bool showTime = false,
    bool shortYear = false,
  }) {
    String date = dateTime.toString();
    String year = shortYear ? date.substring(2, 4) : date.substring(0, 4);
    String month = date.substring(5, 7);
    String day = date.substring(8, 10);
    if (!showTime) {
      return "$day-$month-$year";
    } else if (date.length > 10) {
      String hour = date.substring(11, 13);
      String minute = date.substring(14, 16);
      // String seconds = date.substring(17, 19);
      return "$day-$month-$year $hour:$minute";
    } else {
      return "$day-$month-$year 00:00";
    }
  }

  static String durationToString(
    Duration duration, {
    bool showSeconds = true,
    bool showZeroHour = false,
  }) {
    final hh = duration.inHours;
    final mm = duration.inMinutes % 60;
    final ss = duration.inSeconds % 60;
    return '${hh > 0 || showZeroHour ? '${hh.toString().padLeft(2, '0')}:' : ''}${mm.toString().padLeft(2, '0')}${showSeconds ? ':${ss.toString().padLeft(2, '0')}' : ''}';
    // return '${hh.toString().padLeft(2, '0')}:${mm.toString().padLeft(2, '0')}${showSeconds ? ':${ss.toString().padLeft(2, '0')}' : ''}';
  }

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

  static Color getColorOfDistance(int distance) {
    if (distance < 5000) {
      return cMenos5000;
    } else if (distance == 5000) {
      return c5000;
    } else if (distance > 5000 && distance < 10000) {
      return cMas5Menos10;
    } else if (distance == 10000) {
      return c10000;
    } else if (distance > 10000 && distance < 21097) {
      return cMas10Menos21;
    } else if (distance == 21097) {
      return c21097;
    } else if (distance > 21097 && distance < 42195) {
      return cMas21Menos42;
    } else if (distance == 42195) {
      return c42195;
    } else {
      return cMas42;
    }
  }

  static Duration calculatePace({
    required int distanceMeters,
    required Duration time,
  }) {
    final distanceKm = distanceMeters / 1000;

    return Duration(
      microseconds: (time.inMicroseconds / distanceKm).round(),
    );
  }
}

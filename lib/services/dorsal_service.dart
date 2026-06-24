import 'dart:convert';

import 'package:dorsales/models/dorsal_model.dart';
import 'package:dorsales/secret/secret.dart';
import 'package:dorsales/shared_preferences/preferences.dart';
import 'package:dorsales/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DorsalService extends ChangeNotifier {
  final _baseUrl = Secret.firebaseUrl;
  final String urlVersiones = Secret.urlVersiones;

  List<Dorsal> dorsales = [];
  List<Dorsal> filter = [];

  DorsalService() {}

  Future<List<Dorsal>> loadDorsales() async {
    final url = Uri.https(_baseUrl, 'carreras.json');
    final resp = await http.get(url);

    final Map<String, dynamic> dorsalesMap = jsonDecode(resp.body);

    dorsales.clear();
    dorsalesMap.forEach((key, value) {
      final tempDorsal = Dorsal.fromJson(value);
      tempDorsal.id = key;
      dorsales.add(tempDorsal);
    });

    Utils.years.clear();
    Utils.years.add(Utils.sTodos);
    Utils.distances.clear();
    Utils.distances.add(Utils.sTodas);
    for (Dorsal d in dorsales) {
      if (d.fecha.isNotEmpty) {
        String year = d.fecha.substring(0, 4);
        if (!Utils.years.contains(year)) {
          Utils.years.add(year);
        }
      }
      if (!Utils.distances.contains(d.distancia.toString())) {
        Utils.distances.add(d.distancia.toString());
      }
    }
    Utils.years.sort((a, b) => b.compareTo(a));
    Utils.distances.sort((a, b) {
      if (a == Utils.sTodas) {
        return 0;
      } else {
        return int.parse(b).compareTo(int.parse(a));
      }
    });

    filterDorsales();
    notifyListeners();
    return filter;
  }

  Future saveOrCreateDorsal(Dorsal dorsal) async {
    if (dorsal.id == null) {
      await createDorsal(dorsal);
    } else {
      await updateDorsal(dorsal);
    }
    loadDorsales();
  }

  Future<String> updateDorsal(Dorsal dorsal) async {
    final url = Uri.https(_baseUrl, 'carreras/${dorsal.id}.json');
    // await http.put(url, body: dorsal.toJson());
    // final resp = await http.put(url, body: dorsal.toJson());
    final resp = await http.put(url,
        body: json.encode({
          "CARRERA": dorsal.carrera,
          "CATEGORIA": dorsal.categoria,
          "DISTANCIA": dorsal.distancia,
          "FECHA": dorsal.fecha,
          "GENERO": dorsal.genero,
          "NOTAS": dorsal.notas,
          "NUMERO": dorsal.numero,
          "POSICION": dorsal.posicion,
          "RITMO": dorsal.ritmo,
          "TIEMPO": dorsal.tiempo,
          "URLRESULTS": dorsal.urlResults,
          "URLSTRAVA": dorsal.urlStrava,
          "URLWATCH": dorsal.urlWatch
        }));
    // ignore: unused_local_variable
    final decodedData = resp.body;

    dorsales[dorsales.indexWhere((d) => d.id == dorsal.id)] = dorsal;

    notifyListeners();

    return dorsal.id!;
  }

  Future<String> deleteDorsal(Dorsal dorsal) async {
    final url = Uri.https(_baseUrl, 'carreras/${dorsal.id}.json');
    await http.delete(url,
        body: json.encode({
          "CARRERA": dorsal.carrera,
          "CATEGORIA": dorsal.categoria,
          "DISTANCIA": dorsal.distancia,
          "FECHA": dorsal.fecha,
          "GENERO": dorsal.genero,
          "NOTAS": dorsal.notas,
          "NUMERO": dorsal.numero,
          "POSICION": dorsal.posicion,
          "RITMO": dorsal.ritmo,
          "TIEMPO": dorsal.tiempo,
          "URLRESULTS": dorsal.urlResults,
          "URLSTRAVA": dorsal.urlStrava,
          "URLWATCH": dorsal.urlWatch
        }));
    dorsales.remove(dorsal);
    notifyListeners();

    return '';
  }

  Future<Dorsal> createDorsal(Dorsal dorsal) async {
    final url = Uri.https(_baseUrl, 'carreras.json');
    final resp = await http.post(url,
        body: json.encode({
          "CARRERA": dorsal.carrera,
          "CATEGORIA": dorsal.categoria,
          "DISTANCIA": dorsal.distancia,
          "FECHA": dorsal.fecha,
          "GENERO": dorsal.genero,
          "NOTAS": dorsal.notas,
          "NUMERO": dorsal.numero,
          "POSICION": dorsal.posicion,
          "RITMO": dorsal.ritmo,
          "TIEMPO": dorsal.tiempo,
          "URLRESULTS": dorsal.urlResults,
          "URLSTRAVA": dorsal.urlStrava,
          "URLWATCH": dorsal.urlWatch
        }));
    final decodedData = json.decode(resp.body);

    dorsal.id = decodedData['name'];
    dorsales.add(dorsal);
    notifyListeners();

    return dorsal;
  }

  void filterDorsales() {
    if (Preferences.selYear == Utils.sTodos) {
      filter = dorsales;
    } else {
      filter = dorsales
          .where((d) => d.fecha.isNotEmpty && d.fecha.substring(0, 4) == Preferences.selYear)
          .toList();
    }
    if (Preferences.selDistance == Utils.sTodas) {
    } else {
      filter = filter.where((d) => d.distancia == int.parse(Preferences.selDistance)).toList();
    }
    if (Preferences.filterBusqueda.isNotEmpty) {
      filter = filter
          .where((d) => d.carrera.toUpperCase().contains(Preferences.filterBusqueda))
          .toList();
    }
    orderDorsales();
  }

  void orderDorsales() {
    switch (Preferences.orderValue) {
      case Utils.Distancia:
        if (Preferences.orderAsc == Utils.Ascendente) {
          filter.sort((a, b) => a.distancia.compareTo(b.distancia));
        } else {
          filter.sort((a, b) => b.distancia.compareTo(a.distancia));
        }
        break;
      case Utils.Fecha:
        if (Preferences.orderAsc == Utils.Ascendente) {
          filter.sort((a, b) => (a.fecha == '' ? DateTime(1) : DateTime.parse(a.fecha))
              .compareTo(b.fecha == '' ? DateTime(1) : DateTime.parse(b.fecha)));
        } else {
          filter.sort((a, b) => (b.fecha == '' ? DateTime(1) : DateTime.parse(b.fecha))
              .compareTo(a.fecha == '' ? DateTime(1) : DateTime.parse(a.fecha)));
        }
        break;
      case Utils.Dorsal:
        if (Preferences.orderAsc == Utils.Ascendente) {
          filter.sort((a, b) => a.numero.compareTo(b.numero));
        } else {
          filter.sort((a, b) => b.numero.compareTo(a.numero));
        }
        break;
      case Utils.Tiempo:
        if (Preferences.orderAsc == Utils.Ascendente) {
          filter.sort(((a, b) {
            DateTime i, f;
            if (a.tiempo.isEmpty) {
              i = DateTime(1, 1, 1, 0, 0, 0);
            } else {
              List<String> t1 = a.tiempo.split(':');
              i = DateFormat("yyyy-MM-dd hh:mm:ss").parse(
                  DateTime(1, 1, 1, int.parse(t1[0]), int.parse(t1[1]), int.parse(t1[2]))
                      .toString());
            }
            if (b.tiempo.isEmpty) {
              f = DateTime(1, 1, 1, 0, 0, 0);
            } else {
              List<String> t2 = b.tiempo.split(':');
              f = DateFormat("yyyy-MM-dd hh:mm:ss").parse(
                  DateTime(1, 1, 1, int.parse(t2[0]), int.parse(t2[1]), int.parse(t2[2]))
                      .toString());
            }
            return i.compareTo(f);
          }));
        } else {
          filter.sort(((a, b) {
            DateTime i, f;
            if (a.tiempo.isEmpty) {
              i = DateTime(1, 1, 1, 0, 0, 0);
            } else {
              List<String> t1 = a.tiempo.split(':');
              i = DateFormat("yyyy-MM-dd hh:mm:ss").parse(
                  DateTime(1, 1, 1, int.parse(t1[0]), int.parse(t1[1]), int.parse(t1[2]))
                      .toString());
            }
            if (b.tiempo.isEmpty) {
              f = DateTime(1, 1, 1, 0, 0, 0);
            } else {
              List<String> t2 = b.tiempo.split(':');
              f = DateFormat("yyyy-MM-dd hh:mm:ss").parse(
                  DateTime(1, 1, 1, int.parse(t2[0]), int.parse(t2[1]), int.parse(t2[2]))
                      .toString());
            }
            return f.compareTo(i);
          }));
        }
        break;
      case Utils.Ritmo:
        if (Preferences.orderAsc == Utils.Ascendente) {
          filter.sort(((a, b) {
            DateTime i, f;
            if (a.ritmo.isEmpty) {
              i = DateTime(1, 1, 1, 0, 0, 0);
            } else {
              List<String> t1 = a.ritmo.split(':');
              i = DateFormat("yyyy-MM-dd hh:mm:ss")
                  .parse(DateTime(1, 1, 1, 0, int.parse(t1[0]), int.parse(t1[1])).toString());
            }
            if (b.ritmo.isEmpty) {
              f = DateTime(1, 1, 1, 0, 0, 0);
            } else {
              List<String> t2 = b.ritmo.split(':');
              f = DateFormat("yyyy-MM-dd hh:mm:ss")
                  .parse(DateTime(1, 1, 1, 0, int.parse(t2[0]), int.parse(t2[1])).toString());
            }
            return i.compareTo(f);
          }));
        } else {
          filter.sort(((a, b) {
            DateTime i, f;
            if (a.ritmo.isEmpty) {
              i = DateTime(1, 1, 1, 0, 0, 0);
            } else {
              List<String> t1 = a.ritmo.split(':');
              i = DateFormat("yyyy-MM-dd hh:mm:ss")
                  .parse(DateTime(1, 1, 1, 0, int.parse(t1[0]), int.parse(t1[1])).toString());
            }
            if (b.ritmo.isEmpty) {
              f = DateTime(1, 1, 1, 0, 0, 0);
            } else {
              List<String> t2 = b.ritmo.split(':');
              f = DateFormat("yyyy-MM-dd hh:mm:ss")
                  .parse(DateTime(1, 1, 1, 0, int.parse(t2[0]), int.parse(t2[1])).toString());
            }
            return f.compareTo(i);
          }));
        }
        break;
    }
  }
}

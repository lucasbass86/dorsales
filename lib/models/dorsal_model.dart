// To parse this JSON data, do
//
//     final dorsal = dorsalFromJson(jsonString);

import 'dart:convert';

Dorsal dorsalFromJson(String str) => Dorsal.fromJson(json.decode(str));

String dorsalToJson(Dorsal data) => json.encode(data.toJson());

class Dorsal {
  String? id;
  String carrera;
  String categoria;
  int distancia;
  String fecha;
  String genero;
  String notas;
  int numero;
  String posicion;
  String ritmo;
  // String ritmoOf;
  String tiempo;
  String urlResults;
  String urlStrava;
  String urlWatch;

  Dorsal({
    required this.carrera,
    required this.categoria,
    required this.distancia,
    required this.fecha,
    required this.genero,
    required this.notas,
    required this.numero,
    required this.posicion,
    required this.ritmo,
    // required this.ritmoOf,
    required this.tiempo,
    required this.urlResults,
    required this.urlStrava,
    required this.urlWatch,
  });

  @override
  String toString() {
    return '$numero - $carrera';
  }

  factory Dorsal.fromJson(Map<String, dynamic> json) => Dorsal(
        carrera: json["CARRERA"],
        categoria: json["CATEGORIA"],
        distancia: json["DISTANCIA"],
        fecha: json["FECHA"],
        genero: json["GENERO"],
        notas: json["NOTAS"],
        numero: json["NUMERO"],
        posicion: json["POSICION"],
        ritmo: json["RITMO"],
        // ritmoOf: json["RITMOOF"],
        tiempo: json["TIEMPO"],
        urlResults: json["URLRESULTS"],
        urlStrava: json["URLSTRAVA"],
        urlWatch: json["URLWATCH"],
      );

  Map<String, dynamic> toJson() => {
        "CARRERA": carrera,
        "CATEGORIA": categoria,
        "DISTANCIA": distancia,
        "FECHA": fecha,
        "GENERO": genero,
        "NOTAS": notas,
        "NUMERO": numero,
        "POSICION": posicion,
        "RITMO": ritmo,
        // "RITMOOF": ritmoOf,
        "TIEMPO": tiempo,
        "URLRESULTS": urlResults,
        "URLSTRAVA": urlStrava,
        "URLWATCH": urlWatch,
      };
}

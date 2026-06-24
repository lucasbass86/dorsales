import 'dart:convert';

List<Versiones> versionesFromJson(String str) => List<Versiones>.from(json.decode(str).map((x) => Versiones.fromJson(x)));

class Versiones {
  String appname;
  String appversion;

  @override
  String toString() {
    return '$appname:$appversion';
  }

  Versiones({
    required this.appname,
    required this.appversion,
  });

  factory Versiones.fromJson(Map<String, dynamic> json) => Versiones(
        appname: json["APPNAME"],
        appversion: json["APPVERSION"],
      );
}

List<CResultado> cResultadoFromJson(String str) => List<CResultado>.from(json.decode(str).map((x) => CResultado.fromJson(x)));

class CResultado {
  String resultado;

  @override
  String toString() {
    return resultado;
  }

  CResultado({
    required this.resultado,
  });

  factory CResultado.fromJson(Map<String, dynamic> json) => CResultado(
        resultado: json["RESULTADO"].toString(),
      );
}

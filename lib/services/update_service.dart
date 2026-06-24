import 'package:dorsales/models/versiones_model.dart';
import 'package:dorsales/secret/secret.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateService extends ChangeNotifier {
  final String _urlVersiones = Secret.urlVersiones;
  final String _urlUsuarios = Secret.urlUsuarios;
  final String _urlUserLock = Secret.urlUserLock;
  List<Versiones> versiones = [];
  List<CResultado> resultado = [];
  final String app = 'DORSALES';

  Future<List<Versiones>> getVersiones() async {
    final response = await http.get(Uri.parse(_urlVersiones));
    versiones = versionesFromJson(response.body);
    return versiones;
  }

  Future<List<CResultado>> setUser(String id, String info) async {
    final response = await http.post(
      Uri.parse(_urlUsuarios),
      body: {
        'app': app,
        'id': id,
        'info': info,
      },
    );
    resultado = cResultadoFromJson(response.body);
    return resultado;
  }

  Future<List<CResultado>> getUserLock(String id, String info) async {
    final params = {
      'app': app,
      'id': id,
    };
    final uri = Uri.parse(_urlUserLock).replace(queryParameters: params);
    final response = await http.get(uri);

    resultado = cResultadoFromJson(response.body);
    return resultado;
  }
}

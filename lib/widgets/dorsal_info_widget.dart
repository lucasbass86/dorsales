import 'package:animate_do/animate_do.dart';
import 'package:dorsales/dialogs/dialogs.dart';
import 'package:dorsales/models/dorsal_model.dart';
import 'package:dorsales/pages/pages.dart';
import 'package:dorsales/services/dorsal_service.dart';
import 'package:dorsales/providers/general_provider.dart';
import 'package:dorsales/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:intl/intl.dart';

class DorsalInfoWidget extends StatelessWidget {
  final Dorsal dorsal;
  final BuildContext bottomContext;
  const DorsalInfoWidget({required this.dorsal, required this.bottomContext});

  @override
  Widget build(BuildContext context) {
    GeneralProvider generalProvider = Provider.of<GeneralProvider>(context);
    Color colorChip;
    if (dorsal.distancia < 5000) {
      colorChip = Utils.cMenos5000;
    } else if (dorsal.distancia == 5000) {
      colorChip = Utils.c5000;
    } else if (dorsal.distancia > 5000 && dorsal.distancia < 10000) {
      colorChip = Utils.cMas5Menos10;
    } else if (dorsal.distancia == 10000) {
      colorChip = Utils.c10000;
    } else if (dorsal.distancia > 10000 && dorsal.distancia < 21097) {
      colorChip = Utils.cMas10Menos21;
    } else if (dorsal.distancia == 21097) {
      colorChip = Utils.c21097;
    } else if (dorsal.distancia > 21097 && dorsal.distancia < 42195) {
      colorChip = Utils.cMas21Menos42;
    } else if (dorsal.distancia > 42195) {
      colorChip = Utils.c42195;
    } else {
      colorChip = Utils.cMas42;
    }

    double posicion = 0;
    if (dorsal.posicion.contains('/')) {
      List<String> split = dorsal.posicion.split('/');
      posicion = int.parse(split[0]) * 100 / int.parse(split[1]);
    }
    double categoria = 0;
    if (dorsal.categoria.contains('/')) {
      List<String> split = dorsal.categoria.split('/');
      categoria = int.parse(split[0]) * 100 / int.parse(split[1]);
    }
    double genero = 0;
    if (dorsal.genero.contains('/')) {
      List<String> split = dorsal.genero.split('/');
      genero = int.parse(split[0]) * 100 / int.parse(split[1]);
    }

    return Container(
      padding: const EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Utils.grey,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 2,
                    offset: Offset(7, 7),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Carrera'),
                  Text(dorsal.carrera, style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text('Nº Dorsal'),
                  Text(dorsal.numero.toString(), style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 2,
                    offset: Offset(7, 7),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('Fecha'),
                      SizedBox(height: 10),
                      BounceInDown(child: Text(dorsal.fecha != '' ? DateFormat('dd-MM-yyyy').format(DateTime.parse(dorsal.fecha)) : '', style: TextStyle(fontSize: 20))),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Distancia'),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async {
                          int distancia = dorsal.distancia;
                          generalProvider.selDistance = distancia.toString();
                          final DorsalService dorsalService = Provider.of<DorsalService>(context, listen: false);
                          dorsalService.loadDorsales();
                          Navigator.pop(context);
                        },
                        child: BounceInUp(
                          child: Chip(
                            label: Text(dorsal.distancia.toString(), style: TextStyle(fontSize: 20, color: Colors.white)),
                            avatar: Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                            backgroundColor: colorChip,
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 2,
                    offset: Offset(7, 7),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('Tiempo'),
                      SizedBox(height: 10),
                      Text(dorsal.tiempo, style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Ritmo'),
                      SizedBox(height: 10),
                      Text(dorsal.ritmo, style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Ritmo Of.'),
                      SizedBox(height: 10),
                      Text(dorsal.ritmo, style: TextStyle(fontSize: 20)),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 2,
                    offset: Offset(7, 7),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Posición'),
                              const SizedBox(width: 5),
                              Text('${posicion.floor()} %'),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(dorsal.posicion, style: TextStyle(fontSize: 20)),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Text('Categoría'),
                              const SizedBox(width: 5),
                              Text('${categoria.ceil()} %'),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(dorsal.categoria, style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Género'),
                          const SizedBox(width: 5),
                          Text('${genero.ceil()} %'),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(dorsal.genero, style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 2,
                    offset: Offset(7, 7),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 110,
                    child: Column(
                      children: [
                        Text('Url reloj'),
                        SizedBox(height: 10),
                        (dorsal.urlWatch != '')
                            ? GestureDetector(
                                onTap: _launchURLWatch,
                                child: Image.asset('assets/garmin.png', width: 75, height: 75),
                              )
                            : Icon(Icons.cancel_outlined, size: 75, color: Colors.white)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 110,
                    child: Column(
                      children: [
                        Text('Url Strava'),
                        SizedBox(height: 10),
                        (dorsal.urlStrava != '')
                            ? GestureDetector(
                                onTap: _launchURLStrava,
                                child: Image.asset('assets/strava.png', width: 75, height: 75),
                              )
                            : Icon(Icons.cancel_outlined, size: 75, color: Colors.white)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 110,
                    child: Column(
                      children: [
                        Text('Url Resultados'),
                        SizedBox(height: 10),
                        (dorsal.urlResults != '')
                            ? GestureDetector(
                                onTap: _launchURLResults,
                                child: Image.asset('assets/charts.png', width: 75, height: 75),
                              )
                            : Icon(Icons.cancel_outlined, size: 75, color: Colors.white)
                      ],
                    ),
                  )
                ],
              ),
            ),
            if (dorsal.notas.isNotEmpty)
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2,
                      offset: Offset(7, 7),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Notas'),
                    SelectableText(dorsal.notas, style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
            OutlinedButton(
              onPressed: () {
                password(context).then((value) {
                  if (value[0] == true) {
                    if (value[1] == Utils.password) {
                      Navigator.pop(bottomContext);
                      Navigator.pushNamed(context, NewDorsalPage.routeName, arguments: dorsal);
                    } else {
                      Utils.snackBar(context, 'Password erróneo . . .', true);
                      Navigator.of(context).pop();
                    }
                  }
                });
              },
              child: Text('Editar'),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURLWatch() async {
    if (Uri.parse(dorsal.urlWatch).isAbsolute) await launchUrl(Uri.parse(dorsal.urlWatch));
  }

  void _launchURLStrava() async {
    if (Uri.parse(dorsal.urlStrava).isAbsolute) await launchUrl(Uri.parse(dorsal.urlStrava));
  }

  void _launchURLResults() async {
    if (Uri.parse(dorsal.urlResults).isAbsolute) await launchUrl(Uri.parse(dorsal.urlResults));
  }
}

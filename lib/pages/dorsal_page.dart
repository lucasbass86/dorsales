// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

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

// ignore: must_be_immutable
class DorsalPage extends StatefulWidget {
  static const String routeName = 'DorsalPage2';
  final Dorsal dorsal;
  DateTime selectedDate = DateTime.now();
  bool borrar = false;

  DorsalPage({required this.dorsal});

  @override
  State<DorsalPage> createState() => _DorsalPageState();
}

class _DorsalPageState extends State<DorsalPage> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GeneralProvider generalProvider = Provider.of<GeneralProvider>(context);
    Color colorChip;
    if (widget.dorsal.distancia < 5000) {
      colorChip = Utils.cMenos5000;
    } else if (widget.dorsal.distancia == 5000) {
      colorChip = Utils.c5000;
    } else if (widget.dorsal.distancia > 5000 && widget.dorsal.distancia < 10000) {
      colorChip = Utils.cMas5Menos10;
    } else if (widget.dorsal.distancia == 10000) {
      colorChip = Utils.c10000;
    } else if (widget.dorsal.distancia > 10000 && widget.dorsal.distancia < 21097) {
      colorChip = Utils.cMas10Menos21;
    } else if (widget.dorsal.distancia == 21097) {
      colorChip = Utils.c21097;
    } else if (widget.dorsal.distancia > 21097 && widget.dorsal.distancia < 42195) {
      colorChip = Utils.cMas21Menos42;
    } else if (widget.dorsal.distancia > 42195) {
      colorChip = Utils.c42195;
    } else {
      colorChip = Utils.cMas42;
    }

    double posicion = 0;
    if (widget.dorsal.posicion.contains('/')) {
      List<String> split = widget.dorsal.posicion.split('/');
      posicion = int.parse(split[0]) * 100 / int.parse(split[1]);
    }
    double categoria = 0;
    if (widget.dorsal.posicion.contains('/')) {
      List<String> split = widget.dorsal.categoria.split('/');
      categoria = int.parse(split[0]) * 100 / int.parse(split[1]);
    }
    double genero = 0;
    if (widget.dorsal.genero.contains('/')) {
      List<String> split = widget.dorsal.genero.split('/');
      genero = int.parse(split[0]) * 100 / int.parse(split[1]);
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            controller: _scrollController,
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
                      Text(widget.dorsal.carrera, style: TextStyle(fontSize: 20)),
                      Text('Nº Dorsal'),
                      Text(widget.dorsal.numero.toString(), style: TextStyle(fontSize: 20)),
                      SizedBox(height: 10),
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
                          BounceInDown(child: Text(widget.dorsal.fecha != '' ? DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.dorsal.fecha)) : '', style: TextStyle(fontSize: 20))),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Distancia'),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () async {
                              int distancia = widget.dorsal.distancia;
                              generalProvider.selDistance = distancia.toString();
                              final DorsalService dorsalService = Provider.of<DorsalService>(context, listen: false);
                              dorsalService.loadDorsales();
                              Navigator.pop(context);
                            },
                            child: BounceInUp(
                              child: Chip(
                                label: Text(widget.dorsal.distancia.toString(), style: TextStyle(fontSize: 20, color: Colors.white)),
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
                          Text(widget.dorsal.tiempo, style: TextStyle(fontSize: 20)),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Ritmo'),
                          SizedBox(height: 10),
                          Text(widget.dorsal.ritmo, style: TextStyle(fontSize: 20)),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Ritmo Of.'),
                          SizedBox(height: 10),
                          Text(widget.dorsal.ritmo, style: TextStyle(fontSize: 20)),
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
                          Text(widget.dorsal.posicion, style: TextStyle(fontSize: 20)),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
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
                              Text(widget.dorsal.categoria, style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text('Género'),
                                  const SizedBox(width: 5),
                                  Text('${genero.ceil()} %'),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(widget.dorsal.genero, style: TextStyle(fontSize: 20)),
                            ],
                          )
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
                            (widget.dorsal.urlWatch != '')
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
                            (widget.dorsal.urlStrava != '')
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
                            (widget.dorsal.urlResults != '')
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
                      Text(widget.dorsal.notas, style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    password(context).then((value) {
                      if (value[0] == true) {
                        if (value[1] == Utils.password) {
                          Navigator.pushNamed(context, NewDorsalPage.routeName, arguments: widget.dorsal);
                          setState(() {});
                          _scrollController.jumpTo(0);
                        } else {
                          Utils.snackBar(context, 'Password erróneo . . .', true);
                        }
                      }
                    });
                  },
                  child: Text('Editar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _launchURLWatch() async {
    if (Uri.parse(widget.dorsal.urlWatch).isAbsolute) await launchUrl(Uri.parse(widget.dorsal.urlWatch));
  }

  void _launchURLStrava() async {
    if (Uri.parse(widget.dorsal.urlStrava).isAbsolute) await launchUrl(Uri.parse(widget.dorsal.urlStrava));
  }

  void _launchURLResults() async {
    if (Uri.parse(widget.dorsal.urlResults).isAbsolute) await launchUrl(Uri.parse(widget.dorsal.urlResults));
  }
}

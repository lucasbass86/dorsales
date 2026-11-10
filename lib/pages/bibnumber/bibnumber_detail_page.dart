import 'package:dorsales/models/dorsal_model.dart';
import 'package:dorsales/pages/pages.dart';
import 'package:dorsales/utils/enum.dart';
import 'package:dorsales/utils/utils.dart';
import 'package:dorsales/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BibNumberDetailPage extends StatelessWidget {
  static const String routeName = 'BibNumberDetailPage';
  const BibNumberDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Dorsal dorsal = ModalRoute.of(context)!.settings.arguments as Dorsal;
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
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Row(
            children: [
              Text(
                'Detalle ',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              Text(
                'dorsal',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Utils.blue),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                final response = await Navigator.pushNamed(context, BibNumberEditPage.routeName,
                    arguments: dorsal);
                if (response != null && response == TypeModification.erased) {
                  Navigator.pop(context);
                }
              },
              icon: Icon(Icons.edit))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dorsal.carrera.isNotEmpty ? dorsal.carrera : 'Sin nombre',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 5,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: Colors.grey[600],
                      ),
                      Text(dorsal.fecha.isNotEmpty
                          ? Utils.dateEnglishToSpanish(DateTime.parse(dorsal.fecha))
                          : 'Sin fecha'),
                      Text('·'),
                      Text(dorsal.distancia != 0
                          ? '${(dorsal.distancia / 1000).toStringAsFixed(2)} km'
                          : 'Sin distancia')
                    ],
                  ),
                  if (dorsal.distancia != 0)
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, GraphicDetalilPage.routeName,
                          arguments: dorsal.distancia),
                      child: Text(
                        'Ver',
                        style: TextStyle(color: Utils.blueText),
                      ),
                    )
                ],
              ),
              SizedBox(height: 40),
              Center(child: DorsalWidget(dorsal: dorsal)),
              SizedBox(height: 20),
              BasicContainerWidget(
                borderColor: Colors.grey[700]!,
                borderWidth: 2,
                borderRadius: 10,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 10,
                              children: [
                                Icon(
                                  Icons.watch_later_outlined,
                                  size: 40,
                                  color: Utils.blue.withAlpha(150),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tiempo',
                                      style: TextStyle(fontSize: 19, color: Colors.grey),
                                    ),
                                    Text(
                                      dorsal.tiempo,
                                      style: TextStyle(fontSize: 21, color: Colors.white),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 10,
                              children: [
                                Icon(
                                  Icons.speed_rounded,
                                  size: 40,
                                  color: Utils.blue.withAlpha(150),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Ritmo',
                                      style: TextStyle(fontSize: 19, color: Colors.grey),
                                    ),
                                    Text(
                                      dorsal.ritmo,
                                      style: TextStyle(fontSize: 21, color: Colors.white),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 10,
                              children: [
                                Icon(
                                  Icons.stacked_bar_chart_outlined,
                                  size: 40,
                                  color: Utils.blue.withAlpha(150),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pos.general',
                                      style: TextStyle(fontSize: 19, color: Colors.grey),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          dorsal.posicion.isNotEmpty ? dorsal.posicion : 'Sin dato',
                                          style: TextStyle(fontSize: 21, color: Colors.white),
                                        ),
                                        if (dorsal.posicion.isNotEmpty)
                                          Text(
                                            '${posicion.floor()}%',
                                            style: TextStyle(fontSize: 21, color: Colors.white),
                                          ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 10,
                              children: [
                                Icon(
                                  Icons.man_rounded,
                                  size: 40,
                                  color: Utils.blue.withAlpha(150),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pos.género',
                                      style: TextStyle(fontSize: 19, color: Colors.grey),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          dorsal.genero.isNotEmpty ? dorsal.genero : 'Sin dato',
                                          style: TextStyle(fontSize: 21, color: Colors.white),
                                        ),
                                        if (dorsal.genero.isNotEmpty)
                                          Text(
                                            '${genero.floor()}%',
                                            style: TextStyle(fontSize: 21, color: Colors.white),
                                          ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 10,
                        children: [
                          Icon(
                            Icons.sports_score_rounded,
                            size: 40,
                            color: Utils.blue.withAlpha(150),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pos.categoría',
                                style: TextStyle(fontSize: 19, color: Colors.grey),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    dorsal.categoria.isNotEmpty ? dorsal.categoria : 'Sin dato',
                                    style: TextStyle(fontSize: 21, color: Colors.white),
                                  ),
                                  if (dorsal.categoria.isNotEmpty)
                                    Text(
                                      '${categoria.floor()}%',
                                      style: TextStyle(fontSize: 21, color: Colors.white),
                                    ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                padding: EdgeInsetsGeometry.all(10),
              ),
              SizedBox(height: 20),
              BasicContainerWidget(
                borderColor: Colors.grey[700]!,
                borderWidth: 2,
                borderRadius: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (dorsal.urlWatch.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () => _launchURLWatch(dorsal),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                spacing: 10,
                                children: [
                                  Icon(
                                    Icons.watch,
                                    size: 30,
                                    color: Utils.blue.withAlpha(150),
                                  ),
                                  Text(
                                    'Actividad reloj',
                                    style: TextStyle(fontSize: 19, color: Colors.white),
                                  )
                                ],
                              ),
                              Text(
                                'Ver',
                                style: TextStyle(color: Utils.blue, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (dorsal.urlWatch.isEmpty)
                      Text(
                        'Sin datos de reloj',
                        style: TextStyle(fontSize: 19, color: Colors.white),
                      ),
                    Divider(),
                    if (dorsal.urlStrava.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () => _launchURLStrava(dorsal),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                spacing: 10,
                                children: [
                                  Icon(
                                    Icons.stadium_rounded,
                                    size: 30,
                                    color: Utils.blue.withAlpha(150),
                                  ),
                                  Text(
                                    'Actividad Strava',
                                    style: TextStyle(fontSize: 19, color: Colors.white),
                                  )
                                ],
                              ),
                              Text(
                                'Ver',
                                style: TextStyle(color: Utils.blue, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (dorsal.urlStrava.isEmpty)
                      Text(
                        'Sin datos de Strava',
                        style: TextStyle(fontSize: 19, color: Colors.white),
                      ),
                    Divider(),
                    if (dorsal.urlResults.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () => _launchURLResults(dorsal),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                spacing: 10,
                                children: [
                                  Icon(
                                    Icons.link,
                                    size: 30,
                                    color: Utils.blue.withAlpha(150),
                                  ),
                                  Text(
                                    'Resultados carrera',
                                    style: TextStyle(fontSize: 19, color: Colors.white),
                                  )
                                ],
                              ),
                              Text(
                                'Ver',
                                style: TextStyle(color: Utils.blue, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (dorsal.urlResults.isEmpty)
                      Text(
                        'Sin datos de resultados',
                        style: TextStyle(fontSize: 19, color: Colors.white),
                      ),
                  ],
                ),
                padding: EdgeInsetsGeometry.all(10),
              ),
              SizedBox(height: 20),
              if (dorsal.notas.isNotEmpty)
                BasicContainerWidget(
                  borderColor: Colors.grey[700]!,
                  borderWidth: 2,
                  borderRadius: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Observaciones',
                        style: TextStyle(fontSize: 19, color: Colors.grey),
                      ),
                      Text(
                        dorsal.notas,
                        style: TextStyle(fontSize: 21, color: Colors.white),
                      )
                    ],
                  ),
                  padding: EdgeInsetsGeometry.all(10),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURLWatch(Dorsal dorsal) async {
    if (Uri.parse(dorsal.urlWatch).isAbsolute) await launchUrl(Uri.parse(dorsal.urlWatch));
  }

  void _launchURLStrava(Dorsal dorsal) async {
    if (Uri.parse(dorsal.urlStrava).isAbsolute) await launchUrl(Uri.parse(dorsal.urlStrava));
  }

  void _launchURLResults(Dorsal dorsal) async {
    if (Uri.parse(dorsal.urlResults).isAbsolute) await launchUrl(Uri.parse(dorsal.urlResults));
  }
}

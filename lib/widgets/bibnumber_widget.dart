import 'package:dorsales/models/dorsal_model.dart';
import 'package:dorsales/pages/pages.dart';
import 'package:dorsales/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BibNumberWidget extends StatelessWidget {
  final Dorsal dorsal;
  const BibNumberWidget({required this.dorsal});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, BibNumberDetailPage.routeName, arguments: dorsal),
      child: Container(
        height: 170,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.grey[900]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Expanded(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  dorsal.numero.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Text(
                      dorsal.carrera,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          spacing: 5,
                          children: [
                            Icon(
                              Icons.calendar_month,
                              color: Utils.blue,
                              size: 40,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fecha',
                                  style: TextStyle(color: Utils.grey),
                                ),
                                Text(dorsal.fecha != ''
                                    ? DateFormat('dd-MM-yyyy').format(DateTime.parse(dorsal.fecha))
                                    : '')
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: Utils.grey,
                        margin: const EdgeInsets.only(right: 20),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          spacing: 5,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Utils.blue,
                              size: 40,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Distancia',
                                  style: TextStyle(color: Utils.grey),
                                ),
                                Text('${(dorsal.distancia / 1000).toStringAsFixed(2)} km')
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          spacing: 5,
                          children: [
                            Icon(
                              Icons.watch_later_outlined,
                              color: Utils.blue,
                              size: 40,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tiempo',
                                  style: TextStyle(color: Utils.grey),
                                ),
                                Text(dorsal.tiempo)
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: Utils.grey,
                        margin: const EdgeInsets.only(right: 20),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          spacing: 5,
                          children: [
                            Icon(
                              Icons.speed,
                              color: Utils.blue,
                              size: 40,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ritmo',
                                  style: TextStyle(color: Utils.grey),
                                ),
                                Text(dorsal.ritmo.toString())
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

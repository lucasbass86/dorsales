import 'package:dorsales/dialogs/dialogs.dart';
import 'package:dorsales/models/dorsal_model.dart';
import 'package:dorsales/providers/general_provider.dart';
import 'package:dorsales/services/dorsal_service.dart';
import 'package:dorsales/utils/enum.dart';
import 'package:dorsales/utils/utils.dart';
import 'package:dorsales/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BibNumberEditPage extends StatefulWidget {
  static const String routeName = 'BibNumberEditPage';
  BibNumberEditPage({Key? key}) : super(key: key);

  @override
  State<BibNumberEditPage> createState() => _BibNumberEditPageState();
}

class _BibNumberEditPageState extends State<BibNumberEditPage> {
  late Dorsal dorsal;
  late GeneralProvider generalProvider;
  late TextEditingController edNumero;
  late TextEditingController edCarrera;
  late TextEditingController edCategoria;
  late TextEditingController edDistancia;
  late TextEditingController edGenero;
  late TextEditingController edPosicion;
  late TextEditingController edUrlWatch;
  late TextEditingController edUrlStrava;
  late TextEditingController edUrlResults;
  late TextEditingController edNotas;

  DateTime date = DateTime.now();
  Duration? duration;
  Duration? pace;
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    generalProvider = Provider.of<GeneralProvider>(context);
    if (isLoading) {
      dorsal = ModalRoute.of(context)!.settings.arguments as Dorsal;
      edNumero = TextEditingController(text: dorsal.numero.toString());
      edCarrera = TextEditingController(text: dorsal.carrera);
      edCategoria = TextEditingController(text: dorsal.categoria);
      edDistancia = TextEditingController(text: dorsal.distancia.toString());
      edGenero = TextEditingController(text: dorsal.genero);
      edPosicion = TextEditingController(text: dorsal.posicion);
      edUrlWatch = TextEditingController(text: dorsal.urlWatch);
      edUrlStrava = TextEditingController(text: dorsal.urlStrava);
      edUrlResults = TextEditingController(text: dorsal.urlResults);
      edNotas = TextEditingController(text: dorsal.notas);
      date = dorsal.fecha.isNotEmpty ? DateTime.parse(dorsal.fecha) : DateTime.now();

      List<String> durations = dorsal.tiempo.split(':');
      int hourDuration = durations.length == 3 ? int.parse(durations[0]) : 0;
      int minDuration = durations.length == 3 ? int.parse(durations[1]) : int.parse(durations[0]);
      int secDuration = durations.length == 3 ? int.parse(durations[2]) : int.parse(durations[1]);
      duration = Duration(hours: hourDuration, minutes: minDuration, seconds: secDuration);
      int minPace = int.parse(dorsal.ritmo.split(':')[0]);
      int secPace = int.parse(dorsal.ritmo.split(':')[1]);
      pace = Duration(minutes: minPace, seconds: secPace);
      isLoading = false;
    }
    return Scaffold(
      appBar: _appBar(context),
      body: _body(context),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 1,
      title: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Row(
          children: [
            Text(
              'Editar ',
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
              final resp =
                  await showMessage(context: context, message: '¿Borrar dorsal?', cancel: true);
              if (resp != null) {
                final pass = await password(context);
                if (pass[0]) {
                  if (pass[1] == Utils.password) {
                    DorsalService dorsalService =
                        Provider.of<DorsalService>(context, listen: false);
                    dorsalService.deleteDorsal(dorsal);
                    Utils.snackBar(context, 'Dorsal borrado', false);
                    Navigator.pop(context, TypeModification.erased);
                  } else {
                    Utils.snackBar(context, 'Contraseña incorrecta', true);
                  }
                }
              }
            },
            icon: Icon(
              Icons.delete,
              color: Colors.red[300],
            ))
      ],
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            _field(
                title: 'Nombre de la carrera',
                hint: 'Ej. Media Maratón R&R Madrid',
                icon: Icons.edit_location_alt,
                controller: edCarrera,
                maxLenght: 250),
            const SizedBox(height: 20),
            _field(
                title: 'Número de dorsal',
                hint: 'Ej. 13',
                icon: Icons.confirmation_num_outlined,
                controller: edNumero,
                maxLenght: 6,
                textInputType: TextInputType.number),
            const SizedBox(height: 20),
            Row(
              spacing: 10,
              children: [
                Icon(
                  Icons.calendar_month,
                  size: 40,
                  color: Utils.blue.withAlpha(150),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fecha',
                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final resp = await showDatePicker(
                            firstDate: DateTime(1986),
                            lastDate: DateTime(2099),
                            currentDate: date,
                            context: context,
                          );
                          if (resp != null) {
                            setState(() {
                              date = resp;
                            });
                          }
                        },
                        child: BasicContainerWidget(
                            height: 60,
                            borderColor: Colors.grey[700]!,
                            borderWidth: 2,
                            borderRadius: 10,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(Utils.dateEnglishToSpanish(date))),
                            padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 10)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _field(
                title: 'Distancia (m)',
                hint: 'Ej. 21097',
                icon: Icons.directions_run_rounded,
                controller: edDistancia,
                maxLenght: 6,
                textInputType: TextInputType.number),
            const SizedBox(height: 20),
            Row(
              spacing: 10,
              children: [
                Icon(
                  Icons.watch_later_outlined,
                  size: 40,
                  color: Utils.blue.withAlpha(150),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tiempo',
                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final resp = await showPacePicker(
                              context: context,
                              hasHours: true,
                              title: 'Indica el tiempo (hh:mm:ss)',
                              initialPace: duration ?? Duration.zero);
                          if (resp != null) {
                            duration = resp;
                            dorsal.tiempo = duration != null
                                ? Utils.durationToString(duration!, showZeroHour: true)
                                : '00:00:00';
                            pace = Utils.calculatePace(
                                distanceMeters: int.parse(edDistancia.text), time: duration!);
                            dorsal.ritmo = pace != null
                                ? Utils.durationToString(pace!, showZeroHour: false)
                                : '00:00';
                            setState(() {});
                          }
                        },
                        child: BasicContainerWidget(
                            height: 60,
                            borderColor: Colors.grey[700]!,
                            borderWidth: 2,
                            borderRadius: 10,
                            child:
                                Align(alignment: Alignment.centerLeft, child: Text(dorsal.tiempo)),
                            padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 10)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              spacing: 10,
              children: [
                Icon(
                  Icons.speed_rounded,
                  size: 40,
                  color: Utils.blue.withAlpha(150),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ritmo',
                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final resp = await showPacePicker(
                              context: context,
                              title: 'Indica el ritmo (mm:ss)',
                              initialPace: pace ?? Duration.zero);
                          if (resp != null) {
                            pace = resp;
                            dorsal.ritmo = pace != null
                                ? Utils.durationToString(pace!, showZeroHour: false)
                                : '00:00';
                            setState(() {});
                          }
                        },
                        child: BasicContainerWidget(
                            height: 60,
                            borderColor: Colors.grey[700]!,
                            borderWidth: 2,
                            borderRadius: 10,
                            child:
                                Align(alignment: Alignment.centerLeft, child: Text(dorsal.ritmo)),
                            padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 10)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _field(
                title: 'Posición general (x/xx)',
                hint: 'Ej. 13/101',
                icon: Icons.stacked_bar_chart_outlined,
                controller: edPosicion,
                maxLenght: 13,
                textInputType: TextInputType.text),
            const SizedBox(height: 20),
            _field(
                title: 'Posición de género (x/xx)',
                hint: 'Ej. 11/77',
                icon: Icons.man_rounded,
                controller: edGenero,
                maxLenght: 13,
                textInputType: TextInputType.text),
            const SizedBox(height: 20),
            _field(
                title: 'Posición de categoría (x/xx)',
                hint: 'Ej. 7/53',
                icon: Icons.sports_score_rounded,
                controller: edCategoria,
                maxLenght: 13,
                textInputType: TextInputType.text),
            const SizedBox(height: 20),
            _field(
                title: 'URL actividad reloj',
                hint: 'https://...',
                icon: Icons.watch,
                controller: edUrlWatch,
                maxLenght: 1000,
                textInputType: TextInputType.url),
            const SizedBox(height: 20),
            _field(
                title: 'URL actividad Strava',
                hint: 'https://...',
                icon: Icons.stadium_rounded,
                controller: edUrlStrava,
                maxLenght: 1000,
                textInputType: TextInputType.url),
            const SizedBox(height: 20),
            _field(
                title: 'URL resultados',
                hint: 'https://...',
                icon: Icons.link,
                controller: edUrlResults,
                maxLenght: 1000,
                textInputType: TextInputType.url),
            const SizedBox(height: 20),
            _field(
                title: 'Observaciones',
                hint: 'Añadir cualquier información adicional...',
                icon: Icons.insert_drive_file_rounded,
                controller: edNotas,
                maxLenght: 1000,
                maxLines: 7,
                textInputType: TextInputType.url),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              width: 150,
              height: 70,
              child: ElevatedButton(
                onPressed: () async {
                  final resp = await password(context);
                  if (resp[0]) {
                    if (resp[1] == Utils.password) {
                      dorsal.carrera = edCarrera.text;
                      dorsal.categoria = edCategoria.text;
                      dorsal.distancia =
                          edDistancia.text.isNotEmpty ? int.parse(edDistancia.text) : 0;
                      dorsal.fecha = DateFormat('yyyy-MM-dd').format(date);
                      dorsal.genero = edGenero.text;
                      dorsal.notas = edNotas.text;
                      dorsal.numero = int.parse(edNumero.text);
                      dorsal.posicion = edPosicion.text;
                      dorsal.tiempo = duration != null
                          ? Utils.durationToString(duration!, showZeroHour: true)
                          : '00:00:00';
                      dorsal.ritmo = pace != null
                          ? Utils.durationToString(pace!, showZeroHour: false)
                          : '00:00';
                      dorsal.urlResults = edUrlResults.text;
                      dorsal.urlStrava = edUrlStrava.text;
                      dorsal.urlWatch = edUrlWatch.text;
                      DorsalService dorsalService =
                          Provider.of<DorsalService>(context, listen: false);
                      await dorsalService.saveOrCreateDorsal(dorsal);
                      Utils.snackBar(context, 'Dorsal modificado', false);
                      Navigator.pop(context, TypeModification.modify);
                    } else {
                      Utils.snackBar(context, 'Contraseña errónea', true);
                    }
                  }
                },
                child: Text('Modificar', style: TextStyle(fontSize: 21, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
      {required String title,
      required String hint,
      required IconData icon,
      required TextEditingController controller,
      required int maxLenght,
      TextInputType textInputType = TextInputType.text,
      int maxLines = 1}) {
    return Row(
      spacing: 10,
      children: [
        Icon(
          icon,
          size: 40,
          color: Utils.blue.withAlpha(150),
        ),
        Expanded(
          child: Column(
            spacing: 3,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
              ),
              TextField(
                controller: controller,
                maxLength: maxLenght,
                maxLines: maxLines,
                keyboardType: textInputType,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(hint: Text(hint), counterText: ''),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

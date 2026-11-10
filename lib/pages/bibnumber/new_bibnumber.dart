import 'package:dorsales/dialogs/dialogs.dart';
import 'package:dorsales/models/dorsal_model.dart';
import 'package:dorsales/providers/general_provider.dart';
import 'package:dorsales/services/dorsal_service.dart';
import 'package:dorsales/utils/utils.dart';
import 'package:dorsales/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewBibNumber extends StatefulWidget {
  final PageController pageController;
  const NewBibNumber({Key? key, required this.pageController}) : super(key: key);

  @override
  State<NewBibNumber> createState() => _NewBibNumberState();
}

class _NewBibNumberState extends State<NewBibNumber> {
  late GeneralProvider generalProvider;
  TextEditingController edNumero = TextEditingController();
  TextEditingController edCarrera = TextEditingController();
  TextEditingController edCategoria = TextEditingController();
  TextEditingController edDistancia = TextEditingController();
  TextEditingController edGenero = TextEditingController();
  TextEditingController edPosicion = TextEditingController();
  TextEditingController edUrlWatch = TextEditingController();
  TextEditingController edUrlStrava = TextEditingController();
  TextEditingController edUrlResults = TextEditingController();
  TextEditingController edNotas = TextEditingController();

  DateTime date = DateTime.now();
  Duration? duration;
  Duration? pace;
  @override
  Widget build(BuildContext context) {
    generalProvider = Provider.of<GeneralProvider>(context);
    return Container(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            SwitchListTile(
              shape: StadiumBorder(),
              value: generalProvider.lockNewBibNumber,
              onChanged: (value) => setState(() => generalProvider.lockNewBibNumber = value),
              title: Text('Bloquear desplazamiento'),
            ),
            const SizedBox(height: 20),
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
                            confirmText: 'Aceptar',
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                            initialDate: date,
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
                              initialPace: duration ?? Duration.zero,
                              title: 'Indica el tiempo (hh:mm:ss)');
                          if (resp != null) {
                            setState(() {
                              duration = resp;
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
                                child: Text(duration != null
                                    ? Utils.durationToString(duration!)
                                    : '00:20:11')),
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
                            setState(() {
                              pace = resp;
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
                                child:
                                    Text(pace != null ? Utils.durationToString(pace!) : '04:17')),
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
                  if (edNumero.text.isEmpty) {
                    Utils.snackBar(context, 'Indica el número de dorsal', true);
                    return;
                  }

                  final resp = await password(context);
                  if (resp[0]) {
                    if (resp[1] == Utils.password) {
                      DorsalService dorsalService =
                          Provider.of<DorsalService>(context, listen: false);
                      await dorsalService.saveOrCreateDorsal(Dorsal(
                          carrera: edCarrera.text,
                          categoria: edCategoria.text,
                          distancia: edDistancia.text.isNotEmpty ? int.parse(edDistancia.text) : 0,
                          fecha: DateFormat('yyyy-MM-dd').format(date),
                          genero: edGenero.text,
                          notas: edNotas.text,
                          numero: int.parse(edNumero.text),
                          posicion: edPosicion.text,
                          ritmo: pace != null
                              ? Utils.durationToString(pace!, showZeroHour: false)
                              : '00:00',
                          tiempo: duration != null
                              ? Utils.durationToString(duration!, showZeroHour: true)
                              : '00:00:00',
                          urlResults: edUrlResults.text,
                          urlStrava: edUrlStrava.text,
                          urlWatch: edUrlWatch.text));
                      Utils.snackBar(context, 'Dorsar guardado', false);
                      _clearControllers();
                      generalProvider.lockNewBibNumber = false;
                      widget.pageController.jumpTo(0);
                    } else {
                      Utils.snackBar(context, 'Contraseña errónea', true);
                    }
                  }
                },
                child: Text('Guardar', style: TextStyle(fontSize: 21, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearControllers() {
    edCarrera.text = '';
    edCategoria.text = '';
    edDistancia.text = '';
    edGenero.text = '';
    edNotas.text = '';
    edNumero.text = '';
    edPosicion.text = '';
    edUrlResults.text = '';
    edUrlStrava.text = '';
    edUrlWatch.text = '';
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

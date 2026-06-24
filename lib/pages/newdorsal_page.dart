import 'package:dorsales/models/dorsal_model.dart';
import 'package:dorsales/services/dorsal_service.dart';
import 'package:dorsales/providers/general_provider.dart';
import 'package:dorsales/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

// ignore: must_be_immutable
class NewDorsalPage extends StatefulWidget {
  static const String routeName = 'NewDorsalPage';
  // static Dorsal dorsal =
  //     Dorsal(carrera: '', categoria: '', distancia: 0, fecha: '', genero: '', numero: 0, posicion: '', ritmo: '', /*ritmoOf: '',*/ tiempo: '', notas: '', urlWatch: '', urlResults: '', urlStrava: '');
  DateTime selectedDate = DateTime.now();
  bool borrar = false;

  NewDorsalPage();

  @override
  State<NewDorsalPage> createState() => _NewDorsalPageState();
}

class _NewDorsalPageState extends State<NewDorsalPage> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  late Dorsal dorsal;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GeneralProvider generalProvider = Provider.of<GeneralProvider>(context);
    // if (ModalRoute.of(context)!.settings.arguments != null) NewDorsalPage.dorsal = ModalRoute.of(context)!.settings.arguments as Dorsal;
    dorsal = ModalRoute.of(context)!.settings.arguments as Dorsal;
    TextEditingController edNumero = TextEditingController(text: dorsal.numero.toString());
    TextEditingController edCarrera = TextEditingController(text: dorsal.carrera);
    TextEditingController edCategoria = TextEditingController(text: dorsal.categoria);
    TextEditingController edDistancia = TextEditingController(text: dorsal.distancia.toString());
    TextEditingController edFecha = TextEditingController(
      text: dorsal.fecha != '' ? DateFormat('dd-MM-yyyy').format(DateTime.parse(dorsal.fecha)) : DateFormat('dd-MM-yyyy').format(widget.selectedDate),
    );
    TextEditingController edGenero = TextEditingController(text: dorsal.genero);
    TextEditingController edPosicion = TextEditingController(text: dorsal.posicion);
    TextEditingController edRitmo = TextEditingController(text: dorsal.ritmo);
    TextEditingController edTiempo = TextEditingController(text: dorsal.tiempo);
    TextEditingController edUrlWatch = TextEditingController(text: dorsal.urlWatch);
    TextEditingController edUrlStrava = TextEditingController(text: dorsal.urlStrava);
    TextEditingController edUrlResults = TextEditingController(text: dorsal.urlResults);
    TextEditingController edNotas = TextEditingController(text: dorsal.notas);

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  onChanged: (value) => dorsal.carrera = value,
                  controller: edCarrera,
                  decoration: InputDecoration(
                    labelText: 'Carrera',
                    border: OutlineInputBorder(),
                    hintText: 'Carrera',
                  ),
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 250,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) {
                          if (value.isNotEmpty) dorsal.numero = int.tryParse(value)!;
                        },
                        controller: edNumero,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Indica el número del dorsal';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Nº Dorsal',
                          border: OutlineInputBorder(),
                          hintText: 'Nº Dorsal',
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 5,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) {
                          dorsal.fecha = value;
                        },
                        controller: edFecha,
                        decoration: InputDecoration(
                          labelText: 'Fecha',
                          border: OutlineInputBorder(),
                          hintText: 'Fecha',
                          prefixIcon: GestureDetector(
                            onTap: () => _selectDate(context),
                            child: Icon(
                              Icons.calendar_today_rounded,
                              size: 35,
                            ),
                          ),
                        ),
                        maxLength: 10,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) {
                          if (value.isNotEmpty) dorsal.distancia = int.tryParse(value)!;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Indica la distancia';
                          }
                          return null;
                        },
                        controller: edDistancia,
                        decoration: InputDecoration(
                          labelText: 'Distancia',
                          border: OutlineInputBorder(),
                          hintText: 'Distancia',
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 8,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) => dorsal.tiempo = value,
                        controller: edTiempo,
                        validator: (value) {
                          if (value != '') {
                            RegExp regex = RegExp(r'^([0-1]?\d|2[0-3])(?::([0-5]?\d))?(?::([0-5]?\d))?$');
                            if (!regex.hasMatch(value!)) {
                              return 'El formato de tiempo es: 00:00:00';
                            }
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Tiempo',
                          border: OutlineInputBorder(),
                          hintText: 'Tiempo',
                        ),
                        maxLength: 11,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) => dorsal.ritmo = value,
                        controller: edRitmo,
                        validator: (value) {
                          if (value != '') {
                            RegExp regex = RegExp(r'^([0-5]?\d|2[0-9])(?::([0-5]?\d))?(?::([0-5]?\d))?$');
                            if (!regex.hasMatch(value!)) {
                              return 'El formato de ritmo es: 00:00';
                            }
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Ritmo',
                          border: OutlineInputBorder(),
                          hintText: 'Ritmo',
                        ),
                        maxLength: 7,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) => dorsal.posicion = value,
                        controller: edPosicion,
                        decoration: InputDecoration(
                          labelText: 'Posición',
                          border: OutlineInputBorder(),
                          hintText: 'Posición',
                        ),
                        maxLength: 13,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) => dorsal.categoria = value,
                        controller: edCategoria,
                        decoration: InputDecoration(
                          labelText: 'Categoría',
                          border: OutlineInputBorder(),
                          hintText: 'Categoría',
                        ),
                        maxLength: 13,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) => dorsal.genero = value,
                        controller: edGenero,
                        decoration: InputDecoration(
                          labelText: 'Género',
                          border: OutlineInputBorder(),
                          hintText: 'Género',
                        ),
                        maxLength: 13,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextFormField(
                  onChanged: (value) => dorsal.urlWatch = value,
                  controller: edUrlWatch,
                  decoration: InputDecoration(
                    labelText: 'Url actividad reloj',
                    border: OutlineInputBorder(),
                    hintText: 'Url reloj',
                  ),
                  maxLength: 500,
                ),
                SizedBox(height: 10),
                TextFormField(
                  onChanged: (value) => dorsal.urlStrava = value,
                  controller: edUrlStrava,
                  decoration: InputDecoration(
                    labelText: 'Url Strava',
                    border: OutlineInputBorder(),
                    hintText: 'Url Strava',
                  ),
                  maxLength: 500,
                ),
                SizedBox(height: 10),
                TextFormField(
                  onChanged: (value) => dorsal.urlResults = value,
                  controller: edUrlResults,
                  decoration: InputDecoration(
                    labelText: 'Url Resultados',
                    border: OutlineInputBorder(),
                    hintText: 'Url Resultados',
                  ),
                  maxLength: 500,
                ),
                SizedBox(height: 10),
                TextFormField(
                  onChanged: (value) => dorsal.notas = value,
                  controller: edNotas,
                  decoration: InputDecoration(
                    labelText: 'Notas',
                    border: OutlineInputBorder(),
                    hintText: 'Notas',
                  ),
                  maxLines: 10,
                  minLines: 5,
                  maxLength: 2000,
                  textCapitalization: TextCapitalization.sentences,
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    if (dorsal.id != null)
                      OutlinedButton(
                        onPressed: () async {
                          await dialogBorrar(context, generalProvider);
                          if (widget.borrar) {
                            Utils.snackBar(context, 'Dorsal borrado :_(', true);
                            Navigator.pop(context);
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(Colors.red[400]!),
                          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                        ),
                        child: Text('Eliminar'),
                      ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancelar'),
                          ),
                          const SizedBox(width: 15),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                DorsalService dorsalService = Provider.of<DorsalService>(context, listen: false);
                                if (edFecha.text.isNotEmpty) dorsal.fecha = DateFormat('yyyy-MM-dd').format(widget.selectedDate);
                                await dorsalService.saveOrCreateDorsal(dorsal);
                                setState(() {
                                  Utils.snackBar(context, 'Dorsal guardado', false);
                                  Navigator.pop(context);
                                });
                              } else {
                                Utils.snackBar(context, 'Comprueba los campos', true);
                              }
                            },
                            child: const Text('Guardar'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: widget.selectedDate,
        firstDate: DateTime(1986),
        lastDate: DateTime(2100),
        helpText: 'Selecciona una fecha',
        cancelText: 'Cancelar',
        confirmText: 'Aceptar',
        locale: const Locale('es', 'ES'),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.blueGrey,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.grey,
                ),
              ),
              dialogTheme: DialogThemeData(backgroundColor: Colors.grey[800]),
            ),
            child: child!,
          );
        });
    if (picked != null /*&& picked != widget.selectedDate*/) {
      setState(() {
        dorsal.fecha = DateFormat('yyyy-MM-dd').format(picked);
        widget.selectedDate = picked;
      });
    }
  }

  Future<dynamic> dialogBorrar(BuildContext context, GeneralProvider generalProvider) {
    DorsalService dorsalService = Provider.of<DorsalService>(context, listen: false);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "¿Seguro que desea borrar el registro?",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 27),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            actions: [
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  dorsalService.deleteDorsal(dorsal);
                  widget.borrar = true;
                  Navigator.pop(context);
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        });
  }
}

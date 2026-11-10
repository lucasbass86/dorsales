import 'package:dorsales/providers/general_provider.dart';
import 'package:dorsales/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<dynamic> password(BuildContext context) {
  final TextEditingController edPassword = TextEditingController();
  return showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        title: Text("Introduce el password"),
        content: StatefulBuilder(
          builder: (context, setState) {
            return TextFormField(
              onChanged: (value) {},
              controller: edPassword,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Password',
                focusedBorder: OutlineInputBorder(
                  // borderSide: BorderSide(color: Utils.colorEtiquetaTextoTheme, width: 1.0),
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          },
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop([false, '']),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop([true, edPassword.text]);
            },
            child: const Text('Aceptar'),
          ),
        ],
      );
    },
  ).then((value) => value ?? [false]);
}

Future<dynamic> showMessage(
    {required BuildContext context, required String message, bool cancel = false}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Información"),
        content: Text(message),
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        actions: [
          if (cancel)
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Aceptar'),
          ),
        ],
      );
    },
  );
}

Future<dynamic> order(BuildContext context) {
  final GeneralProvider general = Provider.of<GeneralProvider>(context, listen: false);
  String order1 = general.order == '' ? Utils.Distancia : general.order;
  String order2 = general.orderAsc == '' ? Utils.Ascendente : general.orderAsc;
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Selecciona el orden",
          style: TextStyle(color: Colors.white),
        ),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton(
                    isExpanded: true,
                    value: general.order == '' ? Utils.Distancia : general.order,
                    elevation: 16,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    underline: Container(
                      height: 2,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        general.order = newValue!;
                        order1 = newValue;
                      });
                    },
                    items: Utils.orders.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            if (value == Utils.Distancia)
                              const Icon(Icons.location_on)
                            else if (value == Utils.Fecha)
                              const Icon(Icons.calendar_today_rounded)
                            else if (value == Utils.Dorsal)
                              const Icon(Icons.confirmation_number_sharp)
                            else if (value == Utils.Tiempo || value == Utils.Ritmo)
                              const Icon(Icons.timer)
                            else if (value == Utils.Todo)
                              const Icon(Icons.clear_all_rounded),
                            const SizedBox(width: 20),
                            Text(value),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  DropdownButton(
                    isExpanded: true,
                    value: general.orderAsc == '' ? Utils.Ascendente : general.orderAsc,
                    elevation: 16,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    underline: Container(
                      height: 2,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        general.orderAsc = newValue!;
                        order2 = newValue;
                      });
                    },
                    items: Utils.ascDesc.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            if (value == Utils.Ascendente)
                              const Icon(Icons.arrow_circle_up_rounded)
                            else if (value == Utils.Descendente)
                              const Icon(Icons.arrow_circle_down_rounded),
                            const SizedBox(width: 20),
                            Text(value),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
        ),
        titleTextStyle:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 27),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              general.order = order1;
              general.orderAsc = order2;
              Navigator.of(context).pop();
            },
            child: const Text('Aceptar'),
          ),
        ],
      );
    },
  );
}

Future<Duration?> showPacePicker({
  required BuildContext context,
  Duration initialPace = const Duration(hours: 0, minutes: 0, seconds: 0),
  String? title,
  String? acceptText,
  String? cancelText,
  bool hasHours = false,
}) {
  int selectedHours = initialPace.inHours;
  int selectedMinutes = initialPace.inMinutes % 60;
  int selectedSeconds = initialPace.inSeconds % 60;

  return showDialog<Duration>(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          height: 330,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  title ?? 'Selecciona ritmo (MM:SS)',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 200,
                child: Row(
                  children: [
                    if (hasHours)
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Utils.blue.withAlpha((255 * 0.10).toInt()),
                                border: Border(
                                  top: BorderSide(
                                    color: Utils.blue.withAlpha((255 * 0.35).toInt()),
                                  ),
                                  bottom: BorderSide(
                                    color: Utils.blue.withAlpha((255 * 0.35).toInt()),
                                  ),
                                ),
                              ),
                            ),
                            ListWheelScrollView.useDelegate(
                              itemExtent: 40,
                              perspective: 0.002,
                              physics: const FixedExtentScrollPhysics(),
                              controller: FixedExtentScrollController(initialItem: selectedHours),
                              onSelectedItemChanged: (value) {
                                selectedHours = value;
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                builder: (context, index) {
                                  if (index < 0 || index > 23) return null;
                                  return Center(
                                    child: Text(
                                      index.toString().padLeft(2, '0'),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (hasHours) const Text(":", style: TextStyle(fontSize: 22)),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Utils.blue.withAlpha((255 * 0.10).toInt()),
                              border: Border(
                                top: BorderSide(
                                  color: Utils.blue.withAlpha((255 * 0.35).toInt()),
                                ),
                                bottom: BorderSide(
                                  color: Utils.blue.withAlpha((255 * 0.35).toInt()),
                                ),
                              ),
                            ),
                          ),
                          ListWheelScrollView.useDelegate(
                            itemExtent: 40,
                            perspective: 0.002,
                            physics: const FixedExtentScrollPhysics(),
                            controller: FixedExtentScrollController(initialItem: selectedMinutes),
                            onSelectedItemChanged: (value) {
                              selectedMinutes = value;
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              builder: (context, index) {
                                if (index < 0 || index > 59) return null;
                                return Center(
                                  child: Text(
                                    index.toString().padLeft(2, '0'),
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(":", style: TextStyle(fontSize: 22)),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Utils.blue.withAlpha((255 * 0.10).toInt()),
                              border: Border(
                                top: BorderSide(
                                  color: Utils.blue.withAlpha((255 * 0.35).toInt()),
                                  width: 1,
                                ),
                                bottom: BorderSide(
                                  color: Utils.blue.withAlpha((255 * 0.35).toInt()),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                          ListWheelScrollView.useDelegate(
                            itemExtent: 40,
                            perspective: 0.002,
                            physics: const FixedExtentScrollPhysics(),
                            controller: FixedExtentScrollController(initialItem: selectedSeconds),
                            onSelectedItemChanged: (value) {
                              selectedSeconds = value;
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              builder: (context, index) {
                                if (index < 0 || index > 59) return null;
                                return Center(
                                  child: Text(
                                    index.toString().padLeft(2, '0'),
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Utils.blue)),
                    onPressed: () => Navigator.pop(context),
                    child: Text(cancelText ?? 'Cancelar'),
                  ),
                  TextButton(
                    style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Utils.blue)),
                    onPressed: () {
                      Navigator.pop(
                        context,
                        Duration(
                          hours: selectedHours,
                          minutes: selectedMinutes,
                          seconds: selectedSeconds,
                        ),
                      );
                    },
                    child: Text(acceptText ?? 'Aceptar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

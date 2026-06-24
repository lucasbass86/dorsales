import 'package:dorsales/providers/general_provider.dart';
import 'package:dorsales/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<dynamic> password(BuildContext context) {
  final TextEditingController edPassword = TextEditingController();
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) {
      return WillPopScope(
        onWillPop: () => Future.value(false),
        child: AlertDialog(
          // backgroundColor: Utils.colorCardTheme,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          title: Text("Introduce el password" /*, style: TextStyle(color: Utils.colorEtiquetaTextoTheme)*/),
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
        ),
      );
    },
  );
}

Future<dynamic> showMessage({required BuildContext context, required String message, bool cancel = false}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        // backgroundColor: Utils.colorCardTheme,
        title: Text("Información" /*, style: TextStyle(color: Utils.colorEtiquetaTextoTheme)*/),
        content: Text(message /*, style: Utils.secondTextStyleTheme*/),
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold /*, color: Utils.colorEtiquetaTextoTheme*/, fontSize: 27),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        actions: [
          if (cancel)
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              // style: ButtonStyle(
              //   foregroundColor: MaterialStateProperty.resolveWith((states) => Utils.colorEtiquetaTheme),
              // ),
              child: const Text('Cancelar'),
            ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            // style: ButtonStyle(
            //   backgroundColor: MaterialStateProperty.resolveWith((states) => Utils.colorEtiquetaTheme),
            // ),
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
                            if (value == Utils.Ascendente) const Icon(Icons.arrow_circle_up_rounded) else if (value == Utils.Descendente) const Icon(Icons.arrow_circle_down_rounded),
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
        titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 27),
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

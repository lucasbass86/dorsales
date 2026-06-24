import 'package:dorsales/dialogs/dialogs.dart';
import 'package:dorsales/models/dorsal_model.dart';
import 'package:dorsales/pages/pages.dart';
import 'package:dorsales/services/dorsal_service.dart';
import 'package:dorsales/services/license_service.dart';
import 'package:dorsales/shared_preferences/preferences.dart';
import 'package:dorsales/utils/utils.dart';
import 'package:dorsales/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String routeName = 'HomePage';
  const HomePage();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  bool isExpanded = false;
  bool _hasRun = false;

  @override
  void initState() {
    super.initState();

    if (!_hasRun) {
      _hasRun = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(seconds: 1), () async {
          if (context.mounted) {
            await _checkLicense(context);
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final DorsalService dorsalService = Provider.of<DorsalService>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder(
          future: dorsalService.loadDorsales(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              double distanciaTotal = dorsalService.filter.fold(0, (previousValue, element) => previousValue + element.distancia);
              if (distanciaTotal > 0) distanciaTotal = distanciaTotal / 1000;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _rowTop(context),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        children: [
                          _rowDatos(text: 'Kilómetros totales', value: '${distanciaTotal.toStringAsFixed(2)} Km'),
                          const SizedBox(height: 30),
                          _rowDatos(text: 'Años', value: Utils.years.length.toString()),
                          const SizedBox(height: 10),
                          const YearsListWidget(),
                          const SizedBox(height: 30),
                          _rowDatos(text: 'Distancias', value: Utils.distances.length.toString()),
                          const SizedBox(height: 10),
                          const ListDistancesWidget(),
                          const SizedBox(height: 30),
                          _rowDatos(
                            text: 'Dorsales',
                            value: dorsalService.filter.length.toString(),
                            widget: GestureDetector(
                              onTap: () async {
                                await order(context);
                                dorsalService.orderDorsales();
                                Utils.snackBar(context, dorsalService.filter.length > 1 ? '${dorsalService.filter.length} dorsales' : '${dorsalService.filter.length} dorsal', false);
                              },
                              child: Icon(Icons.filter_list_rounded, color: Utils.blueText),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                              height: 135,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: dorsalService.filter.length,
                                itemBuilder: (context, index) => DorsalWidget(dorsal: dorsalService.filter[index]),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/running.gif'),
                  const SizedBox(height: 30),
                  Text('Loading . . .', style: Utils.styleBig),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _rowTop(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: isExpanded ? MediaQuery.of(context).size.width * 0.6 : 50,
          child: TextField(
            controller: searchController,
            cursorColor: Utils.blueText,
            style: Utils.styleBig.copyWith(fontSize: 17),
            decoration: InputDecoration(
              hintText: 'Buscar',
              suffixIcon: GestureDetector(
                onTap: () {
                  searchController.text = '';
                  Preferences.filterBusqueda = '';
                  isExpanded = !isExpanded;
                  print('entra: $isExpanded');
                  setState(() {});
                },
                child: Icon(Preferences.filterBusqueda.isEmpty ? Icons.search : Icons.close, color: Utils.grey, size: 35),
              ),
            ),
            onChanged: (value) {
              Preferences.filterBusqueda = value.toUpperCase();
              if (value.isNotEmpty) {
                final DorsalService dorsalService = Provider.of<DorsalService>(context, listen: false);
                dorsalService.loadDorsales();
              }
            },
          ),
        ),
        Expanded(child: const SizedBox(width: 15)),
        GestureDetector(
            onTap: () {
              password(context).then((value) async {
                if (value[0] == true) {
                  if (value[1] == Utils.password) {
                    Navigator.pushNamed(context, NewDorsalPage.routeName,
                        arguments: Dorsal(
                            carrera: '', categoria: '', distancia: 0, fecha: '', genero: '', numero: 0, posicion: '', ritmo: '', tiempo: '', notas: '', urlWatch: '', urlResults: '', urlStrava: ''));
                  } else {
                    Utils.snackBar(context, 'Password erróneo . . .', true);
                  }
                }
              });
            },
            child: Icon(Icons.add, color: Utils.grey, size: 45)),
        const SizedBox(width: 15),
        GestureDetector(
          onTap: () => SystemNavigator.pop(),
          child: Icon(Icons.power_settings_new_rounded, color: Utils.grey, size: 45),
        ),
      ],
    );
  }

  Row _rowDatos({required String text, required String value, Widget? widget}) {
    return Row(
      children: [
        Text(text, style: Utils.styleBig),
        const Expanded(child: SizedBox(width: 1)),
        Text(value, style: Utils.styleBig),
        if (widget != null)
          Row(
            children: [
              const SizedBox(width: 15),
              widget,
            ],
          )
      ],
    );
  }

  Future<void> _checkLicense(BuildContext context) async {
    final cnx = await Utils.checkConnection();
    // Preferences.license = '';
    if (cnx && Preferences.license.isEmpty) {
      if (context.mounted) {
        final em = await showDialogInput(context, subtitle: 'Se envía un código de verificación para registrarse.', label: 'Email', inputType: TextInputType.emailAddress);
        if (em[0]) {
          final GetLicenseCodeResponse r = await LicenseService.obtainLicense(em[1]);
          if (r.status == LicenseService.success && context.mounted) {
            final code = await showDialogInput(context, label: 'Código', subtitle: 'Introduce el código de verificación', maxLength: 13);
            if (code[0]) {
              final GetLicenseCodeResponse r2 = await LicenseService.setLicenseCode(code[1], em[1]);
              if (r2.status == LicenseService.success && context.mounted) {
                Utils.snackBar(context, 'Registrado correctamente', false);
                Preferences.license = code[1];
              }
            } else {
              SystemNavigator.pop();
            }
          }
        } else {
          SystemNavigator.pop();
        }
      }
    } else if (cnx && Preferences.license.isNotEmpty) {
      final GetLicenseCodeResponse r = await LicenseService.checkLicenseCode(Preferences.license);
      if (r.status == LicenseService.success) {
        MapData licenseData = r.data as MapData;
        if (licenseData.license != null) {
          if (licenseData.license!.locked == 1) {
            if (context.mounted) {
              await showMessage(context: context, message: 'Esta licencia está bloqueada. Contacta con ${LicenseService.emailDev}').then((_) {
                SystemNavigator.pop();
              });
            }
          }
          if (licenseData.license!.message.isNotEmpty) {
            if (context.mounted) {
              await showMessage(context: context, message: licenseData.license!.message);
            }
          }
        }
      } else {
        if (context.mounted) {
          await showMessage(context: context, message: 'Ha habido un problema con la licencia. Contacta con ${LicenseService.emailDev}').then((_) {
            SystemNavigator.pop();
          });
        }
      }
    } else if (!cnx && Preferences.license.isEmpty) {
      if (context.mounted) {
        await showMessage(context: context, message: 'Necesita tener conexión para verificar la licencia').then((_) {
          SystemNavigator.pop();
        });
      }
    }
  }
}

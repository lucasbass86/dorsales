import 'package:dorsales/dialogs/dialogs.dart';
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
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    double distanciaTotal =
        dorsalService.filter.fold(0, (previousValue, element) => previousValue + element.distancia);
    if (distanciaTotal > 0) distanciaTotal = distanciaTotal / 1000;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BasicContainerWidget(
              borderColor: Utils.grey,
              borderWidth: 1,
              borderRadius: 20,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '${dorsalService.filter.isEmpty ? 'Ningún' : dorsalService.filter.length}',
                        style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${dorsalService.filter.isEmpty ? ' dorsal' : dorsalService.filter.length == 1 ? ' dorsal' : ' dorsales'}',
                        style: TextStyle(fontSize: 23, color: Utils.blue),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        distanciaTotal.toStringAsFixed(2),
                        style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        ' Km',
                        style: TextStyle(fontSize: 23, color: Utils.blue),
                      ),
                    ],
                  )
                ],
              ),
            ),
            ListView.separated(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: dorsalService.filter.length,
              separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
              itemBuilder: (BuildContext context, int index) =>
                  BibNumberWidget(dorsal: dorsalService.filter[index]),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkLicense(BuildContext context) async {
    final cnx = await Utils.checkConnection();
    // Preferences.license = '';
    if (cnx && Preferences.license.isEmpty) {
      if (context.mounted) {
        final em = await showDialogInput(context,
            subtitle: 'Se envía un código de verificación para registrarse.',
            label: 'Email',
            inputType: TextInputType.emailAddress);
        if (em[0]) {
          final GetLicenseCodeResponse r = await LicenseService.obtainLicense(em[1]);
          if (r.status == LicenseService.success && context.mounted) {
            final code = await showDialogInput(context,
                label: 'Código', subtitle: 'Introduce el código de verificación', maxLength: 13);
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
              await showMessage(
                      context: context,
                      message:
                          'Esta licencia está bloqueada. Contacta con ${LicenseService.emailDev}')
                  .then((_) {
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
          await showMessage(
                  context: context,
                  message:
                      'Ha habido un problema con la licencia. Contacta con ${LicenseService.emailDev}')
              .then((_) {
            SystemNavigator.pop();
          });
        }
      }
    } else if (!cnx && Preferences.license.isEmpty) {
      if (context.mounted) {
        await showMessage(
                context: context, message: 'Necesita tener conexión para verificar la licencia')
            .then((_) {
          SystemNavigator.pop();
        });
      }
    }
  }
}

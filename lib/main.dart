import 'package:dorsales/models/versiones_model.dart';
import 'package:dorsales/pages/pages.dart';
import 'package:dorsales/routes/routes.dart';
import 'package:dorsales/services/dorsal_service.dart';
import 'package:dorsales/providers/general_provider.dart';
import 'package:dorsales/shared_preferences/preferences.dart';
import 'package:dorsales/themes/themes.dart';
import 'package:dorsales/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  await Preferences.init();
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DorsalService(), lazy: true),
        ChangeNotifierProvider(create: (_) => GeneralProvider(), lazy: true),
      ],
      child: const FirstState(),
    );
  }
}

class FirstState extends StatefulWidget {
  const FirstState();

  @override
  State<FirstState> createState() => _FirstStateState();
}

class _FirstStateState extends State<FirstState> {
  bool isConnected = false;
  bool hasNewVersion = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkAppStatus();
  }

  Future<void> checkAppStatus() async {
    isConnected = await Utils.checkConnection();
    if (isConnected) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      List<Versiones> versiones = await getVersiones();
      if (versiones.isNotEmpty) {
        hasNewVersion = versiones
                .firstWhere((v) => v.appname == 'dorsales')
                .appversion
                .replaceAll('.', '')
                .compareTo(packageInfo.version.replaceAll('.', '')) >
            0;
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<List<Versiones>> getVersiones() async {
    final response = await http
        .get(Uri.parse('http://www.escayolasdelucas.com/apps/versiones/getVersiones.php'));
    List<Versiones> versiones = versionesFromJson(response.body);
    return versiones;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const MyAppLoading();
    } else {
      if (isConnected) {
        if (hasNewVersion) {
          return const UpdateApp();
        } else {
          return const MyApp();
        }
      } else {
        return const MyAppNoConnection();
      }
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // initialRoute: HomePage.routeName,
      initialRoute: MainPage.routeName,
      routes: routes,
      theme: getTheme2(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
      ],
    );
  }
}

class UpdateApp extends StatelessWidget {
  const UpdateApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: UpdatePage.routeName,
      routes: routes,
      theme: getTheme2(),
    );
  }
}

class MyAppNoConnection extends StatelessWidget {
  const MyAppNoConnection();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: NoConnectionPage.routeName,
      routes: routes,
      theme: getTheme2(),
    );
  }
}

class MyAppLoading extends StatelessWidget {
  const MyAppLoading();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getTheme2(),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/running.gif'),
              const SizedBox(height: 30),
              Text('Loading . . .', style: Utils.styleBig),
            ],
          ),
        ),
      ),
    );
  }
}

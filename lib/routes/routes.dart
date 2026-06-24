import 'package:dorsales/pages/pages.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> routes = <String, Widget Function(BuildContext)>{
  HomePage.routeName: (context) => const HomePage(),
  NewDorsalPage.routeName: (context) => NewDorsalPage(),
  NoConnectionPage.routeName: (context) => NoConnectionPage(),
  UpdatePage.routeName: (context) => UpdatePage(),
};

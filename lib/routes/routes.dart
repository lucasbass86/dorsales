import 'package:dorsales/pages/pages.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> routes = <String, Widget Function(BuildContext)>{
  NoConnectionPage.routeName: (context) => NoConnectionPage(),
  UpdatePage.routeName: (context) => UpdatePage(),
  MainPage.routeName: (context) => MainPage(),
  BibNumberDetailPage.routeName: (context) => BibNumberDetailPage(),
  BibNumberEditPage.routeName: (context) => BibNumberEditPage(),
  GraphicDetalilPage.routeName: (context) => GraphicDetalilPage(),
};

import 'package:dorsales/shared_preferences/preferences.dart';
import 'package:flutter/material.dart';

class GeneralProvider extends ChangeNotifier {
  String get selDistance => Preferences.selDistance;
  set selDistance(String value) {
    Preferences.selDistance = value;
    notifyListeners();
  }

  String get selYear => Preferences.selYear;
  set selYear(String value) {
    Preferences.selYear = value;
    notifyListeners();
  }

  String get filterBusqueda => Preferences.filterBusqueda;
  set filterBusqueda(String value) {
    Preferences.filterBusqueda = value;
    notifyListeners();
  }

  String get order => Preferences.orderValue;
  set order(String value) {
    Preferences.orderValue = value;
    notifyListeners();
  }

  String get orderAsc => Preferences.orderAsc;
  set orderAsc(String value) {
    Preferences.orderAsc = value;
    notifyListeners();
  }

  bool _lockNewBibNumber = false;
  bool get lockNewBibNumber => _lockNewBibNumber;
  set lockNewBibNumber(bool value) {
    _lockNewBibNumber = value;
    notifyListeners();
  }

  int _homeIndex = 0;
  int get homeIndex => _homeIndex;
  set homeIndex(int index) {
    _homeIndex = index;
    notifyListeners();
  }
}

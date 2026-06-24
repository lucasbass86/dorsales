import 'package:dorsales/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _prefs;
  static String _filterBusqueda = '';

  static String _orderValue = Utils.Fecha;
  static String _orderAsc = Utils.Ascendente;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const String _sLicense = 'license';
  static String _license = '';
  static String get license => _prefs.getString(_sLicense) ?? _license;
  static set license(String value) {
    _license = value;
    _prefs.setString(_sLicense, value);
  }

  static String _selYear = Utils.sTodos;
  static String get selYear {
    return _prefs.getString('selectedYear') ?? _selYear;
  }

  static set selYear(String value) {
    _selYear = value;
    _prefs.setString('selectedYear', value);
  }

  static String _selDistance = Utils.sTodas;
  static String get selDistance {
    return _prefs.getString('selectedDistance') ?? _selDistance;
  }

  static set selDistance(String value) {
    _selDistance = value;
    _prefs.setString('selectedDistance', value);
  }

  static String get filterBusqueda {
    return _prefs.getString('filterBusqueda') ?? _filterBusqueda;
  }

  static set filterBusqueda(String value) {
    _filterBusqueda = value;
    _prefs.setString('filterBusqueda', value);
  }

  static String get orderValue {
    return _prefs.getString('orderValue') ?? _orderValue;
  }

  static set orderValue(String value) {
    _orderValue = value;
    _prefs.setString('orderValue', value);
  }

  static String get orderAsc {
    return _prefs.getString('orderAsc') ?? _orderAsc;
  }

  static set orderAsc(String value) {
    _orderAsc = value;
    _prefs.setString('orderAsc', value);
  }
}

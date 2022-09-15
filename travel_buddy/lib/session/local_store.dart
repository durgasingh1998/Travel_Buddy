import 'package:shared_preferences/shared_preferences.dart';

class LocalStore {
  late SharedPreferences _pref;

  storeData(String k, String value) async {
    _pref = await SharedPreferences.getInstance();
    await _pref.setString(k, value);
  }

  Future<String> retrieveData(String k) async {
    _pref = await SharedPreferences.getInstance();
    return await _pref.getString(k) ?? '';
  }

  clearAll() async {
    _pref = await SharedPreferences.getInstance();
    await _pref.clear();
  }
}

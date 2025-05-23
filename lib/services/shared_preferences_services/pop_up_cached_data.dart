import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';

class PopUpCachedData{
  final SharedPreferences _sharedPreferences;
  PopUpCachedData(this._sharedPreferences);

  Future<void> setIds({required List<String> value}) async {
    _sharedPreferences.setStringList(PopKeyManager.popUPId, value);
  }

  Future<List<String>?> getIds() async {
    return _sharedPreferences.getStringList(PopKeyManager.popUPId);
  }

  removeSharedPreferencesGeneralFunction(String key) async {
    return _sharedPreferences.remove(key);
  }


}

class PopKeyManager {
  static const String popUPId = 'pop-up-id';
}
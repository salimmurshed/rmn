import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';

class HistoryCachedData {
  final SharedPreferences _sharedPreferences;

  HistoryCachedData(this._sharedPreferences);

  void setHistory(List<String> scannedList) {
    _sharedPreferences.setStringList(HistoryKeyManager.history, scannedList);
  }

  List<String>? getHistory() {
    return _sharedPreferences.getStringList(HistoryKeyManager.history);
  }
  removeSharedPreferencesGeneralFunction(String key) async {
    return _sharedPreferences.remove(key);
  }
}

class HistoryKeyManager {
  static const String history = 'history';
}

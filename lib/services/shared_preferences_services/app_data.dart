import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';

class AppData{
  final SharedPreferences _sharedPreferences;
  AppData(this._sharedPreferences);

  Future<void> setCrashCollectionData({required bool value}) async {
    _sharedPreferences.setBool(UserKeyManager.isCrashCollectionActivated, value);
  }

  Future<bool> isCrashCollectionActivated() async {
    return _sharedPreferences.getBool(UserKeyManager.isCrashCollectionActivated) ?? true;
  }

  Future<void> setLocationDetection({required bool value}) async {
    _sharedPreferences.setBool(UserKeyManager.isLocationDetectionActivated, value);
  }

  Future<bool> isLocationDetectionActivated() async {
    return _sharedPreferences.getBool(UserKeyManager.isLocationDetectionActivated) ?? true;
  }

  Future<void> setNotificationPermission({required bool value}) async {
    _sharedPreferences.setBool(UserKeyManager.isNotificationActivated, value);
  }

  Future<bool> isNotificationActivated() async {
    return _sharedPreferences.getBool(UserKeyManager.isNotificationActivated) ?? true;
  }


}

class UserKeyManager {
  static const String isCrashCollectionActivated = 'is-crash-collection-activated';
  static const String isLocationDetectionActivated = 'is-location-detection-activated';
  static const String isNotificationActivated = 'is-notification-activated';
}
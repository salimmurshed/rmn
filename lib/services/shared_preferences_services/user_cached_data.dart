import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:rmnevents/services/shared_preferences_services/history_cached_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCachedData {
  final SharedPreferences _sharedPreferences;

  UserCachedData(this._sharedPreferences);

  Future<void> setUserData(
      {required String accessToken,
      required String userId,
      required String email,
      required String firstName,
      required String lastName,
      required String url,
      required String userInfo}) async {
    await setUserAccessToken(value: accessToken);
    await setUserId(value: userId);
    await setUserInfo(jsonEncodedValue: userInfo);
    await setUserEmail(email: email);
    await setUserName(isFirstName: true, name: firstName);
    await setUserName(isFirstName: false, name: lastName);
    await setUserPhoto(url: url);

    debugPrint('Access $accessToken');
    debugPrint('User $userId');
    debugPrint('Email $email');
    debugPrint('first $firstName');
    debugPrint('last $lastName');
    debugPrint('Info $userInfo');
  }

  Future<void> setUserDataForPreselection({
    required String email,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String address,
    required String zip,
    required String dob,
  }) async {
    await setUserPreselectionEmail(email);
    await setUserPreselectionNameSeparately(
        isFirstName: true, value: firstName);
    await setUserPreselectionNameSeparately(
        isFirstName: false, value: lastName);
    await setUserPreselectionContact(phoneNumber);
    await setUserPreselectionAddress(address);
    await setUserPreselectionZip(zip);
    await setUserPreselectionDob(dob);

    debugPrint('Email $email');
    debugPrint('first $firstName');
    debugPrint('last $lastName');
    debugPrint('Phone $phoneNumber');
    debugPrint('Address $address');
    debugPrint('DOB $dob');
  }

  Future<bool> isUserSignedIn() async {
    return _sharedPreferences.getBool(UserKeyManager.isUserSignedIn) ?? false;
  }

  Future<void> setUserSession({required bool value}) async {
    _sharedPreferences.setBool(UserKeyManager.isUserSignedIn, value);
  }

  Future<void> setFirstTimeUser({required bool value}) async {
    _sharedPreferences.setBool(UserKeyManager.isFirstTimeUser, value);
  }

  Future<bool> isFirstTimeUser() async {
    return _sharedPreferences.getBool(UserKeyManager.isFirstTimeUser) ?? true;
  }

  Future<String?> getUserAccessToken() async {
    return _sharedPreferences.getString(UserKeyManager.accessToken);
  }

  Future<void> setUserAccessToken({required String value}) async {
    _sharedPreferences.setString(UserKeyManager.accessToken, value);
  }

  Future<String?> getUserId() async {
    return _sharedPreferences.getString(UserKeyManager.userId);
  }

  Future<void> setCurrentRole({required String role}) async {
    await _sharedPreferences.setString(UserKeyManager.currentRole, role);
  }

  Future<String?> getCurrentRole() async {
    return _sharedPreferences.getString(UserKeyManager.currentRole);
  }

  Future<void> setUserId({required String value}) async {
    _sharedPreferences.setString(UserKeyManager.userId, value);
  }

  Future<String?> getUserInfo() async {
    return _sharedPreferences.getString(UserKeyManager.userInfo);
  }

  Future<String?> getUserEmail() async {
    return _sharedPreferences.getString(UserKeyManager.userEmail);
  }

  Future<String?> getUserName({required bool isFirstName}) async {
    return _sharedPreferences.getString(
        isFirstName ? UserKeyManager.firstName : UserKeyManager.lastName);
  }

  Future<String?> getUserPhoto() async {
    return _sharedPreferences.getString(UserKeyManager.url);
  }

  Future<void> setUserInfo({required String jsonEncodedValue}) async {
    _sharedPreferences.setString(UserKeyManager.userInfo, jsonEncodedValue);
  }

  Future<void> setUserEmail({required String email}) async {
    _sharedPreferences.setString(UserKeyManager.userEmail, email);
  }

  Future<void> setUserName(
      {required String name, required bool isFirstName}) async {
    _sharedPreferences.setString(
        isFirstName ? UserKeyManager.firstName : UserKeyManager.lastName, name);
  }

  Future<void> setUserPhoto({required String url}) async {
    _sharedPreferences.setString(UserKeyManager.url, url);
  }

  Future<void> setAppleUserData(String appleUser) async {
    _sharedPreferences.setString(UserKeyManager.appleUserData, appleUser);
  }

  Future<String> getAppleUserData() async {
    return _sharedPreferences.getString(UserKeyManager.appleUserData) ?? "";
  }

  Future<String?> getUserPreselectionEmail() async {
    return _sharedPreferences.getString(UserKeyManager.p_userEmail);
  }

  Future<String?> getUserPreselectionNameSeparately(
      {required bool isFirstName}) async {
    return _sharedPreferences.getString(
        isFirstName ? UserKeyManager.p_firstName : UserKeyManager.p_lastName);
  }

  Future<String?> getUserPreselectionContact() async {
    return _sharedPreferences.getString(UserKeyManager.p_userContact);
  }

  Future<String?> getUserPreselectionAddress() async {
    return _sharedPreferences.getString(UserKeyManager.p_userAddress);
  }

  Future<String?> getUserPreselectionZip() async {
    return _sharedPreferences.getString(UserKeyManager.p_userZip);
  }

  Future<String?> getUserPreselectionDob() async {
    return _sharedPreferences.getString(UserKeyManager.p_userDob);
  }

  Future<void> setUserPreselectionEmail(String value) async {
    await _sharedPreferences.setString(UserKeyManager.p_userEmail, value);
  }

  Future<void> setUserPreselectionNameSeparately(
      {required bool isFirstName, required String value}) async {
    await _sharedPreferences.setString(
        isFirstName ? UserKeyManager.p_firstName : UserKeyManager.p_lastName,
        value);
  }

  Future<void> setUserPreselectionContact(String value) async {
    await _sharedPreferences.setString(UserKeyManager.p_userContact, value);
  }

  Future<void> setUserPreselectionAddress(String value) async {
    await _sharedPreferences.setString(UserKeyManager.p_userAddress, value);
  }

  Future<void> setUserPreselectionZip(String value) async {
    await _sharedPreferences.setString(UserKeyManager.p_userZip, value);
  }

  Future<void> setUserPreselectionDob(String value) async {
    await _sharedPreferences.setString(UserKeyManager.p_userDob, value);
  }

  //Eraser Function
  removeSharedPreferencesGeneralFunction(String key) async {
    return _sharedPreferences.remove(key);
  }

  // Eraser function for signing out
  removeUserDataCache() async {
    await removeSharedPreferencesGeneralFunction(UserKeyManager.userInfo);
    await removeSharedPreferencesGeneralFunction(UserKeyManager.userId);
    await removeSharedPreferencesGeneralFunction(UserKeyManager.userEmail);
    await removeSharedPreferencesGeneralFunction(UserKeyManager.p_userEmail);
    await removeSharedPreferencesGeneralFunction(UserKeyManager.currentRole);
    await removeSharedPreferencesGeneralFunction(UserKeyManager.firstName);
    await removeSharedPreferencesGeneralFunction(UserKeyManager.lastName);
    await removeSharedPreferencesGeneralFunction(UserKeyManager.url);
    await removeSharedPreferencesGeneralFunction(UserKeyManager.p_userContact);
    await removeSharedPreferencesGeneralFunction(UserKeyManager.p_userDob);
    await removeSharedPreferencesGeneralFunction(UserKeyManager.p_userAddress);
    await removeSharedPreferencesGeneralFunction(UserKeyManager.accessToken);
    await removeSharedPreferencesGeneralFunction(UserKeyManager.isUserSignedIn);
    await removeSharedPreferencesGeneralFunction(UserKeyManager.appleUserData);

    // await removeSharedPreferencesGeneralFunction(UserKeyManager.isFirstTimeUser);
    await removeSharedPreferencesGeneralFunction(HistoryKeyManager.history);
  }

  removePreselectUserData() async {
    String firstName =
        await getUserPreselectionNameSeparately(isFirstName: true) ?? "";
    if (firstName.isNotEmpty) {
      await removeSharedPreferencesGeneralFunction(UserKeyManager.p_firstName);
      await removeSharedPreferencesGeneralFunction(UserKeyManager.p_lastName);
      await removeSharedPreferencesGeneralFunction(
          UserKeyManager.p_userContact);
      await removeSharedPreferencesGeneralFunction(UserKeyManager.p_userDob);
      await removeSharedPreferencesGeneralFunction(
          UserKeyManager.p_userAddress);
      await removeSharedPreferencesGeneralFunction(UserKeyManager.p_userZip);
    }
  }
}

class UserKeyManager {
  static const String isUserSignedIn = 'is-user-signed-in-';
  static const String accessToken = 'access-token';
  static const String userId = 'user-id';
  static const String currentRole = 'user-current-role';
  static const String userInfo = 'user-info';
  static const String userEmail = 'user-email';
  static const String url = 'url';
  static const String p_userEmail = 'p-user-email';
  static const String p_userContact = 'p-user-contact';
  static const String p_userAddress = 'p-user-address';
  static const String p_userZip = 'p-user-zip';
  static const String p_userDob = 'p-user-dob';
  static const String p_lastName = 'p-user-lastName';
  static const String p_firstName = 'p-user-firstName';
  static const String firstName = 'first-name';
  static const String lastName = 'last-name';
  static const String appleUserData = 'apple-user-data';
  static const String isFirstTimeUser = 'is-first-time-user';
}

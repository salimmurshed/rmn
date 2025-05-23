import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../imports/data.dart';

class AthleteCachedData {
  final SharedPreferences _sharedPreferences;

  AthleteCachedData(this._sharedPreferences);

  Future<void> setAthleteDataForPreselection({
    required String email,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String address,
    required String zip,
    required String dob,
    required String wc,
    required String teamName,
    required String grade,
    required String teamId,
    required int gender,
    required bool isRedShirt,
  }) async {
    await setAthletePreselectionEmail(email);
    await setAthletePreselectionNameSeparately(
        isFirstName: true, value: firstName);
    await setAthletePreselectionNameSeparately(
        isFirstName: false, value: lastName);
    await setAthletePreselectionContact(phoneNumber);
    await setAthletePreselectionAddress(address);
    await setAthletePreselectionZip(zip);
    await setAthletePreselectionDob(dob);
    await setAthletePreselectionWC(wc);
    await setAthletePreselectionGender(gender);
    await setAthletePreselectionTeamName(teamName);
    await setAthletePreselectionGradeName(grade);
    await setAthletePreselectionTeamId(teamId);
    await setRedshirt(isRedShirt);

    debugPrint('Email $email');
    debugPrint('first $firstName');
    debugPrint('last $lastName');
    debugPrint('Phone $phoneNumber');
    debugPrint('Zip $zip');
    debugPrint('Address $address');
    debugPrint('Gender $gender');
    debugPrint('DOB $dob');
    debugPrint('teamName $teamName');
    debugPrint('teamId $teamId');
    debugPrint('grade $grade');
    debugPrint('red $isRedShirt');
  }

  Future<String?> getAthletePreselectionEmail() async {
    return _sharedPreferences.getString(AthleteKeyManager.p_athleteEmail);
  }

  Future<String?> getAthletePreselectionNameSeparately(
      {required bool isFirstName}) async {
    return _sharedPreferences.getString(isFirstName
        ? AthleteKeyManager.p_athleteFirstName
        : AthleteKeyManager.p_athleteLastName);
  }

  Future<String?> getAthletePreselectionContact() async {
    return _sharedPreferences.getString(AthleteKeyManager.p_athleteContact);
  }

  Future<String?> getAthletePreselectionAddress() async {
    return _sharedPreferences.getString(AthleteKeyManager.p_athleteAddress);
  }

  Future<String?> getAthletePreselectionZip() async {
    return _sharedPreferences.getString(AthleteKeyManager.p_athleteZip);
  }

  Future<String?> getAthletePreselectionDob() async {
    return _sharedPreferences.getString(AthleteKeyManager.p_athleteDob);
  }

  Future<String?> getAthletePreselectionWC() async {
    return _sharedPreferences.getString(AthleteKeyManager.p_athleteWc);
  }

  Future<int?> getAthletePreselectionGender() async {
    return _sharedPreferences.getInt(AthleteKeyManager.p_athleteGender);
  }

  Future<String?> getAthletePreselectionTeamName() async {
    return _sharedPreferences.getString(AthleteKeyManager.p_athleteTeamName);
  }

  Future<String?> getAthletePreselectionGradeName() async {
    return _sharedPreferences.getString(AthleteKeyManager.p_athleteGradeName);
  }

  Future<String?> getAthletePreselectionTeamId() async {
    return _sharedPreferences.getString(AthleteKeyManager.p_athleteTeamId);
  }

  Future<void> setAthletePreselectionEmail(String value) async {
    await _sharedPreferences.setString(AthleteKeyManager.p_athleteEmail, value);
  }

  Future<void> setAthletePreselectionNameSeparately(
      {required bool isFirstName, required String value}) async {
    await _sharedPreferences.setString(
        isFirstName
            ? AthleteKeyManager.p_athleteFirstName
            : AthleteKeyManager.p_athleteLastName,
        value);
  }

  Future<void> setAthletePreselectionContact(String value) async {
    await _sharedPreferences.setString(
        AthleteKeyManager.p_athleteContact, value);
  }

  Future<void> setAthletePreselectionAddress(String value) async {
    await _sharedPreferences.setString(
        AthleteKeyManager.p_athleteAddress, value);
  }

  Future<void> setAthletePreselectionZip(String value) async {
    await _sharedPreferences.setString(AthleteKeyManager.p_athleteZip, value);
  }

  Future<void> setAthletePreselectionDob(String value) async {
    await _sharedPreferences.setString(AthleteKeyManager.p_athleteDob, value);
  }

  Future<void> setAthletePreselectionWC(String value) async {
    await _sharedPreferences.setString(AthleteKeyManager.p_athleteWc, value);
  }

  Future<void> setAthletePreselectionTeamName(String value) async {
    await _sharedPreferences.setString(
        AthleteKeyManager.p_athleteTeamName, value);
  }

  Future<void> setAthletePreselectionGradeName(String value) async {
    await _sharedPreferences.setString(
        AthleteKeyManager.p_athleteGradeName, value);
  }

  Future<void> setAthletePreselectionTeamId(String value) async {
    await _sharedPreferences.setString(
        AthleteKeyManager.p_athleteTeamId, value);
  }

  Future<void> setRedshirt(bool value) async {
    await _sharedPreferences.setBool(AthleteKeyManager.p_redShirt, value);
  }

  Future<bool> getRedshirt() async {
   return  _sharedPreferences.getBool(AthleteKeyManager.p_redShirt) ?? false;
  }

  Future<void> setAthletePreselectionGender(int value) async {
    await _sharedPreferences.setInt(AthleteKeyManager.p_athleteGender, value);
  }

  Future<void> addAthleteToList(CreateProfileRequestModel createProfileRequestModel) async {
    List<String>? athleteJsonList = _sharedPreferences.getStringList('athlete_list') ?? [];
    athleteJsonList.add(jsonEncode(createProfileRequestModel.toJson()));
    await _sharedPreferences.setStringList('athlete_list', athleteJsonList);
  }

  List<String>? getAthleteListJson() {
    return _sharedPreferences.getStringList('athlete_list');
  }
  Future<void> removeAthleteFromList(String athleteId) async {
    List<String>? athleteJsonList = _sharedPreferences.getStringList('athlete_list') ?? [];
    List<CreateProfileRequestModel> athletes = athleteJsonList.map((athleteJson) => CreateProfileRequestModel.fromJson(jsonDecode(athleteJson))).toList();

    debugPrint('athletes $athleteJsonList \n $athleteId');
    athletes.removeWhere((athlete) => athlete.athleteId == athleteId);

    List<String> updatedAthleteJsonList = athletes.map((athlete) => jsonEncode(athlete.toJson())).toList();
    debugPrint('updatedAthleteJsonList $updatedAthleteJsonList');
    await _sharedPreferences.setStringList('athlete_list', updatedAthleteJsonList);
  }

  // List<Athlete>? getAthleteList() {
  //   List<String>? athleteJsonList = _sharedPreferences.getStringList('athlete_list');
  //   if (athleteJsonList == null) return null;
  //   return athleteJsonList.map((athleteJson) => Athlete.fromJson(jsonDecode(athleteJson))).toList();
  // }

  removeSharedPreferencesGeneralFunction(String key) async {
    return _sharedPreferences.remove(key);
  }

  removePreselectAthleteData() async {
    String firstName =
        await getAthletePreselectionNameSeparately(isFirstName: true) ?? "";
    if (firstName.isNotEmpty) {
      await removeSharedPreferencesGeneralFunction(
          AthleteKeyManager.p_athleteFirstName);
      await removeSharedPreferencesGeneralFunction(
          AthleteKeyManager.p_athleteLastName);
      await removeSharedPreferencesGeneralFunction(
          AthleteKeyManager.p_athleteEmail);
      await removeSharedPreferencesGeneralFunction(
          AthleteKeyManager.p_athleteContact);
      await removeSharedPreferencesGeneralFunction(
          AthleteKeyManager.p_athleteAddress);
      await removeSharedPreferencesGeneralFunction(
          AthleteKeyManager.p_athleteDob);
      await removeSharedPreferencesGeneralFunction(
          AthleteKeyManager.p_athleteZip);
      await removeSharedPreferencesGeneralFunction(
          AthleteKeyManager.p_athleteWc);
      await removeSharedPreferencesGeneralFunction(
          AthleteKeyManager.p_athleteGender);
      await removeSharedPreferencesGeneralFunction(
          AthleteKeyManager.p_athleteTeamName);
      await removeSharedPreferencesGeneralFunction(
          AthleteKeyManager.p_athleteGradeName);
      await removeSharedPreferencesGeneralFunction(
          AthleteKeyManager.p_athleteTeamId);
    }
  }
}

class AthleteKeyManager {
  static const String p_athleteEmail = 'p-athlete-email';
  static const String p_athleteFirstName = 'p-athlete-firstName';
  static const String p_athleteLastName = 'p-athlete-lastName';
  static const String p_athleteZip = 'p-athlete-zip';
  static const String p_athleteDob = 'p-athlete-dob';
  static const String p_athleteWc = 'p-athlete-wc';
  static const String p_athleteGender = 'p-athlete-gender';
  static const String p_athleteContact = 'p-athlete-contact';
  static const String p_athleteAddress = 'p-athlete-address';
  static const String p_athleteTeamName = 'p-athlete-teamName';
  static const String p_athleteGradeName = 'p-athlete-gradeName';
  static const String p_athleteTeamId = 'p-athlete-teamId';
  static const String p_redShirt = 'p-redShirt';
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:rmnevents/data/models/request_models/create_profile_request_model.dart';
import 'package:http/http.dart';

import '../../imports/common.dart';
import '../../imports/services.dart';

class OwnerProfileDataSource {
  static Future createEditOwnerProfile(
      {required CreateProfileRequestModel
          createOwnerProfileRequestModel}) async {
    late Map<String, String> data;
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.createOwnerProfile}';
    if (createOwnerProfileRequestModel.isCreateProfile) {
      data = {
        "first_name": createOwnerProfileRequestModel.firstName,
        "last_name": createOwnerProfileRequestModel.lastName,
        "birth_date": createOwnerProfileRequestModel.birthDate,
        "phone_code": createOwnerProfileRequestModel.phoneCode,
        "contact_no": createOwnerProfileRequestModel.contactNumber,
        "address": createOwnerProfileRequestModel.address,
        "gender": createOwnerProfileRequestModel.gender,
        "zipcode": createOwnerProfileRequestModel.zipCode,
        "athlete_flag": AppStrings.global_athlete_flag,
        "city": createOwnerProfileRequestModel.city,
        "state": createOwnerProfileRequestModel.stateName,
      };
    } else {
      data = {
        "first_name": createOwnerProfileRequestModel.firstName,
        "last_name": createOwnerProfileRequestModel.lastName,
        "birth_date": createOwnerProfileRequestModel.birthDate,
        "phone_code": createOwnerProfileRequestModel.phoneCode,
        "contact_no": createOwnerProfileRequestModel.contactNumber,
        "address": createOwnerProfileRequestModel.address,
        "gender": createOwnerProfileRequestModel.gender,
        "zipcode": createOwnerProfileRequestModel.zipCode,
        "city": createOwnerProfileRequestModel.city,
        "state": createOwnerProfileRequestModel.stateName,
      };
    }

    List<MultipartFile> multipartFiles = [];
    if (createOwnerProfileRequestModel.profileImage != null) {
      multipartFiles = await MediaManager.convertFileToMultipartFile(
          file: createOwnerProfileRequestModel.profileImage!,
          isAthleteProfile: false);
    }

    debugPrint('multipartFiles: $multipartFiles');
    debugPrint('data: $data');

    dynamic response = await HttpFactoryServices.postMultiPartResponse(
        url: url,
        header: await setHeader(true, isMultipart: true),
        bodyData: data,
        listFile: multipartFiles);

    return response;
  }

  static Future changeEmail({required String email}) async {
    final data = jsonEncode({
      "email": email,
    });
    final String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.changeEmail}';

    dynamic response = await HttpFactoryServices.postMethod(url,
        data: data, header: await setHeader(true));

    return response;
  }

  static Future updateEmail(
      {required String email, required String otp}) async {
    final data = jsonEncode({
      "email": email,
      "otp": otp,
    });
    final String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.updateEmail}';

    dynamic response = await HttpFactoryServices.postMethod(url,
        data: data, header: await setHeader(true));

    return response;
  }

  static Future changePassword(
      {required String oldPassword, required String newPassword}) async {
    final data =
        jsonEncode({"old_password": oldPassword, "new_password": newPassword});
    final String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.changePassword}';

    dynamic response = await HttpFactoryServices.postMethod(url,
        data: data, header: await setHeader(true));

    return response;
  }

  static Future deleteAccount() async {
    final String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.deleteAccount}';

    dynamic response = await HttpFactoryServices.postMethod(url,
        header: await setHeader(true));

    return response;
  }

  static Future getProfile() async {
    final String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.getProfile}';

    dynamic response = await HttpFactoryServices.getMethod(url,
        header: await setHeader(true));

    return response;
  }
}

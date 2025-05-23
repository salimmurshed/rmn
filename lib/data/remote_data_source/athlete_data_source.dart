import 'dart:convert';

import 'package:rmnevents/data/models/request_models/create_profile_request_model.dart';
import 'package:http/http.dart';

import '../../imports/common.dart';
import '../../imports/services.dart';

class AthleteDataSource {
  static Future createAthlete(
      {required CreateProfileRequestModel createProfileRequestModel}) async {
    final String url = createProfileRequestModel.isCreateProfile
        ? '${UrlPrefixes.baseUrl}${UrlSuffixes.createAthleteProfile}'
        : '${UrlPrefixes.baseUrl}${UrlSuffixes.updateAthleteProfile}';
    late Map<String, String> data;
    data = {
      "first_name": createProfileRequestModel.firstName,
      "last_name": createProfileRequestModel.lastName,
      "email": createProfileRequestModel.email,
      "birth_date": createProfileRequestModel.birthDate,
      "weight": createProfileRequestModel.weight,
      "phone_code": createProfileRequestModel.phoneCode,
      "contact_no": createProfileRequestModel.contactNumber,
      "gender": createProfileRequestModel.gender,
      "address": createProfileRequestModel.address,
      "pincode": createProfileRequestModel.zipCode,
      "city": createProfileRequestModel.city,
      "grade": createProfileRequestModel.gradeValue,
      "is_redshirt": createProfileRequestModel.isRedshirt ? "true" : "false",
      "state": createProfileRequestModel.stateName,
      "is_user_parent": createProfileRequestModel.isUserParent.toString(),
      "team_id": createProfileRequestModel.teamId,
    };

    if (!createProfileRequestModel.isCreateProfile) {
      data['id'] = createProfileRequestModel
          .athleteId; // Add the 'id' only if not creating a profile
    }

    List<MultipartFile> multipartFiles = [];
    if (createProfileRequestModel.profileImage != null) {
      multipartFiles = await MediaManager.convertFileToMultipartFile(
          file: createProfileRequestModel.profileImage!,
          isAthleteProfile: true);
    }

    dynamic response = await HttpFactoryServices.postMultiPartResponse(
        url: url,
        header: await setHeader(true, isMultipart: true),
        bodyData: data,
        listFile: multipartFiles);

    return response;
  }

  static Future deleteAthleteAccount({required String athleteId}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.deleteAthleteProfile}';
    final data = jsonEncode({
      "athlete_id": athleteId,
    });

    dynamic response = await HttpFactoryServices.postMethod(
      url,
      header: await setHeader(true, isMultipart: false),
      data: data,
    );

    return response;
  }

  static Future getHomeAthletes() async {
    final String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.homeAthlete}';
    dynamic response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }

  static Future myAthletes(
      {required int page,
      String searchKey = AppStrings.global_empty_string}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.myAthletes(page: page, searchKey: searchKey)}';
    dynamic response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(true));
    return response;
  }

  static Future getEventWiseAthletes({required String eventId}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.getEventWiseAthletes(eventId: eventId)}';
    dynamic response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }

  static Future allAthletes({required int page}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.allAthletes(page: page)}';
    dynamic response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }

  static Future searchAthlete({required String searchKey}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.findAthletes(searchKey: searchKey)}';

    dynamic response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }

  static Future receivedAthleteRequests(
      {required int page,
      String searchKey = AppStrings.global_empty_string}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.receivedAthleteRequests(page: page, searchKey: searchKey)}';
    dynamic response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }

  static Future sendRequestForAthlete(
      {required String accessType, required String athleteId}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.sendRequestToAnAthlete}';
    final data =
        jsonEncode({"athlete_id": athleteId, "access_type": accessType});
    dynamic response = await HttpFactoryServices.postMethod(url,
        data: data, header: await setHeader(true));

    return response;
  }

  static Future cancelSentRequestForAthlete({required String athleteId}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.cancelRequestToAnAthlete}';
    final data = jsonEncode({
      "athlete_id": athleteId,
    });
    dynamic response = await HttpFactoryServices.postMethod(url,
        data: data, header: await setHeader(true));

    return response;
  }

  static Future acceptReject(
      {required String requestId, required bool isAccepted}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.acceptRejectRequests}';
    final data = jsonEncode({"request_id": requestId, "is_accept": isAccepted});
    dynamic response = await HttpFactoryServices.postMethod(url,
        data: data, header: await setHeader(true));

    return response;
  }

  static Future getAthleteDetails(
      {required String athleteId,
      String seasonId = AppStrings.global_empty_string}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.getAthleteDetails(athleteId: athleteId, seasonId: seasonId)}';

    dynamic response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(true));
    return response;
  }

  static Future getAthletePartialOwnerList(
      {required String athleteId, required bool isViewer}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.getAthletePartialOwnerList(athleteId: athleteId, isViewer: isViewer)}';

    dynamic response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(true));
    return response;
  }

  static Future removeAthletePartialOwner(
      {required String athleteId,
      required String userId,
      required bool isViewer}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.removeAthletePartialOwner(athleteId: athleteId, isViewer: isViewer)}';
    final data = jsonEncode({
      "user_id": userId,
    });
    dynamic response = await HttpFactoryServices.postMethod(url,
        data: data, header: await setHeader(true));
    return response;
  }

  static Future getAthletesWithoutSeasonPass() async {
    String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.getAthletesWithoutSeasonPass}';
    dynamic response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(true));
    return response;
  }

  static Future teamNameRequest({required String teamName}) async {
    String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.teamNameRequest}';

    final data = jsonEncode({"team": teamName});
    final response = await HttpFactoryServices.postMethod(url,
        data: data, header: await setHeader(true));

    return response;
  }

  static Future getCustomerAthletes(
      {required String userId, required String eventId}) async {
    String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.getCustomerAthletes(
      eventId: eventId,
      userId: userId,
    )}';

    final response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }
}

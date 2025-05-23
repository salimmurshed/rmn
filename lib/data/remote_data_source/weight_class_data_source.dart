import 'dart:convert';

import '../../imports/common.dart';
import '../../imports/data.dart';
import '../../imports/services.dart';

class WeightClassDataSource {
  static Future getWeightClasses({required String divId, required String eventID}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.getDivsWeights(divId: divId, eventID: eventID)}';
    dynamic response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }

  static Future changeWc(
      {required ChangeWCRequestModel changeWCRequest}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.changeWC(eventId: changeWCRequest.eventId)}';
    final data = json.encode({
      "athlete_id": changeWCRequest.athleteId,
      "division_id": changeWCRequest.divisionId,
      "weight_classes": changeWCRequest.weightClasses
    });

    dynamic response = await HttpFactoryServices.postMethod(url,
        data: data, header: await setHeader(true));

    return response;
  }
}

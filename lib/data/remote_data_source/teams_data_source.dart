import 'dart:convert';

import '../../imports/common.dart';
import '../../imports/services.dart';

class TeamsDataSource {
  static Future getTeams() async {
    final String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.getTeams}';
    dynamic response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }

  static Future changeTeam(
      {required String athleteId,
      required String eventId,
      required String teamId}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.changeTeam(athleteId: athleteId)}';
    final data = json.encode({
      "event_id": eventId,
      "team_id": teamId // "0" or te
    });
    dynamic response = await HttpFactoryServices.postMethod(url,
        data: data, header: await setHeader(true));

    return response;
  }
}

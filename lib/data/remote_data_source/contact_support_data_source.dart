import 'dart:convert';

import '../../imports/common.dart';
import '../../imports/services.dart';

class ContactSupportDataSource {
  static Future askContactSupport({required String athleteId}) async {
    final String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.askContactSupport}';
    String athleteIdEncoded = jsonEncode({
      'athlete_id': athleteId,
    });
    dynamic response = await HttpFactoryServices.postMethod(url,
        data: athleteIdEncoded,
        header: await setHeader(true));

    return response;
  }
}

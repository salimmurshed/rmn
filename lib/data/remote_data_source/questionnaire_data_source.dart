import '../../imports/common.dart';
import '../../imports/services.dart';

class QuestionnaireDataSource {
  static Future getQuestionnaire({required String eventId}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.getQuestionnaire(eventId: eventId)}';
    dynamic response =
    await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }
}
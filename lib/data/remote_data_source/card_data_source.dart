
import '../../imports/common.dart';
import '../../imports/services.dart';

class CardDataSource{
  static Future getCardList() async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.getCardList}';
    dynamic response =
    await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }
}
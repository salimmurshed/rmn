import '../../imports/common.dart';
import '../../imports/services.dart';

class CurrentSeasonDataSource{
  static Future getCurrentSeason() async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.getCurrentSeason}';
    dynamic response =
    await HttpFactoryServices.getMethod(url, header: await setHeader(false));

    return response;
  }
}
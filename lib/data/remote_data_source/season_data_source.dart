import '../../imports/common.dart';
import '../../imports/services.dart';

class SeasonDataSource {
  static Future getSeasons() async {
    final String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.getSeasons}';
    dynamic response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }

  static Future getMyPurchasesSeasonPasses() async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.getMyPurchasesSeasonPasses}';
    dynamic response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }

  static Future getSeasonPasses() async {
    final String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.getSeasonPasses}';
    dynamic response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(false));

    return response;
  }
}

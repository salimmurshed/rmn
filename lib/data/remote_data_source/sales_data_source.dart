import '../../imports/common.dart';
import '../../imports/services.dart';

class SalesDataSource{
  static Future getSales({required int page}) async {
    final String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.getSales(page: page)}';
    dynamic response =
    await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }
}
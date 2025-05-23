
import '../../common/resources/app_urls.dart';

import '../../imports/services.dart';

class FAQDataSource {
  static Future getFaqs() async {
    String baseUrl = '${UrlPrefixes.baseUrl}${UrlSuffixes.getFAQs}';
    final response = await HttpFactoryServices.getMethod(baseUrl,
        header: await setHeader(true));
    return response;
  }
}

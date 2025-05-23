import '../../imports/common.dart';
import '../../imports/services.dart';

class LegalsDataSource{
  static Future listCms() async {
    String baseUrl ='${UrlPrefixes.baseUrl}${UrlSuffixes.listCMS}';
    final response = await HttpFactoryServices.postMethod(
      baseUrl,
    );
    return response;
  }
}
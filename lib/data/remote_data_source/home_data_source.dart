import '../../imports/common.dart';
import '../../imports/services.dart';

class HomeDataSource{
  static Future getClientHome() async{
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.home}';
    dynamic response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(true));
    return response;
  }
}
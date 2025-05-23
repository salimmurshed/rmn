import '../../imports/common.dart';
import '../../imports/services.dart';

class GradeDataSource{
  static Future getGrades() async{
    String baseUrl = '${UrlPrefixes.baseUrl}${UrlSuffixes.getGrades}';
    final response = await HttpFactoryServices.getMethod(baseUrl,
        header: await setHeader(true));
    return response;
  }
  static Future getUnreadCount() async{
    String baseUrl = '${UrlPrefixes.baseUrl}${UrlSuffixes.getUnreadCount}';
    final response = await HttpFactoryServices.getMethod(baseUrl,
        header: await setHeader(true));
    return response;
  }
}
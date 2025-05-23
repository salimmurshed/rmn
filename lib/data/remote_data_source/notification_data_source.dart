import '../../imports/common.dart';
import '../../imports/services.dart';

class NotificationDataSource {
  static Future getNotificationList() async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.getNotificationList}';
    dynamic response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(true));
    return response;
  }
  static Future getNotificationCount() async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.getNotificationCount}';
    dynamic response =
    await HttpFactoryServices.getMethod(url, header: await setHeader(true));
    return response;
  }
}

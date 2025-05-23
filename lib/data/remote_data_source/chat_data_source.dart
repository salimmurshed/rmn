import '../../imports/common.dart';
import '../../imports/services.dart';

class ChatDataSource {
  static Future getEventChat({required String eventId}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.getEventChat(eventId: eventId)}';
    dynamic response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(true));
    return response;
  }
  static Future getGeneralChats({required String eventId}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.getGeneralChats(eventId: eventId)}';
    dynamic response =
    await HttpFactoryServices.getMethod(url, header: await setHeader(true));
    return response;
  }
  static Future unReadMessage({required String roomId}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.unReadMessage(roomId: roomId)}';
    dynamic response =
    await HttpFactoryServices.postMethod(url, header: await setHeader(true));
    return response;
  }

  static Future markAsRead({required String roomId}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.markAsRead(roomId: roomId)}';
    dynamic response =
    await HttpFactoryServices.postMethod(url, header: await setHeader(true));
    return response;
  }
}

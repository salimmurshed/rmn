
import 'package:rmnevents/common/resources/app_enums.dart';

import '../../common/resources/app_urls.dart';
import '../../services/http_services/http_factory_services.dart';
import '../../services/http_services/http_service_header.dart';
import '../models/request_models/chat_list_request_model.dart';

class GenralchatDatasource{
  static Future getGeneralChatList({required ChatListRequestModel chatRequestModel}) async{
    String baseUrl = '${UrlPrefixes.baseUrl}${UrlSuffixes.getGeneralChatList(page: chatRequestModel.page, status: getEnumKeyAsString(chatRequestModel.type))}';
    final response = await HttpFactoryServices.getMethod(baseUrl,
        header: await setHeader(true));
    return response;
  }
  static Future getEventChatList() async{
    String baseUrl = '${UrlPrefixes.baseUrl}${UrlSuffixes.getEventChatList()}';
    final response = await HttpFactoryServices.getMethod(baseUrl,
        header: await setHeader(true));
    return response;
  }
  static Future deleteGenralChat(String roomId) async{
    String baseUrl = '${UrlPrefixes.baseUrl}${UrlSuffixes.deleteGeneralChat(roomId: roomId)}';
    final response = await HttpFactoryServices.postMethod(baseUrl,
        header: await setHeader(true));
    return response;
  }

  static Future addToArchiveChat(String roomId) async{
    String baseUrl = '${UrlPrefixes.baseUrl}${UrlSuffixes.addToArchiveChat(roomId: roomId)}';
    final response = await HttpFactoryServices.postMethod(baseUrl,
        header: await setHeader(true));
    return response;
  }
  static Future unArchiveAll(String eventId) async{
    String baseUrl = '${UrlPrefixes.baseUrl}${UrlSuffixes.unArchiveAll(eventId: eventId)}';
    final response = await HttpFactoryServices.postMethod(baseUrl,
        header: await setHeader(true));
    return response;
  }
  static Future unReadCount(String eventId) async{
    String baseUrl = '${UrlPrefixes.baseUrl}${UrlSuffixes.unReadCount(eventId: eventId)}';
    final response = await HttpFactoryServices.getMethod(baseUrl,
        header: await setHeader(true));
    return response;
  }
  static Future removeFromArchiveChat(String roomId) async{
    String baseUrl = '${UrlPrefixes.baseUrl}${UrlSuffixes.removeFromArchiveChat(roomId: roomId)}';
    final response = await HttpFactoryServices.postMethod(baseUrl,
        header: await setHeader(true));
    return response;
  }
  static Future fetchEventChatsData({required ChatListRequestModel chatRequestModel}) async{
    String baseUrl = '${UrlPrefixes.baseUrl}${UrlSuffixes.fetchEventChatsData(eventId: chatRequestModel.eventId ?? '', page: chatRequestModel.page, status:  getEnumKeyAsString(chatRequestModel.type))}';
    final response = await HttpFactoryServices.getMethod(baseUrl,
        header: await setHeader(true));
    return response;
  }

}

String getEnumKeyAsString(ChatType value) {
  return value.toString().split('.').last.toLowerCase();
}
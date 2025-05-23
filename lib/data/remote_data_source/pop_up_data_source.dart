import '../../imports/common.dart';
import '../../imports/services.dart';

class PopUpDataSource {
 static Future getPopUpList() async{
   final String url =
       '${UrlPrefixes.baseUrl}${UrlSuffixes.getPopUps}';
   dynamic response =
       await HttpFactoryServices.getMethod(url, header: await setHeader(true));
   return response;
 }
}
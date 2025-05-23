import '../../imports/common.dart';
import '../../imports/services.dart';

class PlacementDataSource {
  static Future getPlacement({required String id}) async{
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.getPlacements(id: id)}';
    dynamic response =
    await HttpFactoryServices.getMethod(url, header: await setHeader(true));
    return response;
  }
}
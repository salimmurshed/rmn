import '../../imports/common.dart';
import '../../imports/services.dart';

class ProductsDataSource{
  static Future getMyPurchasesProducts() async {
    final String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.getMyPurchasesProducts}';
    dynamic response =
    await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }  static Future getMyPurchasedProductDetailEventWise({required String eventId}) async {
    final String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.getMyPurchasedProductDetailEventWise(eventId: eventId)}';
    dynamic response =
    await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }
}
import 'dart:convert';

import '../../imports/common.dart';
import '../../imports/services.dart';

class StaffCustomerPurchasesDataSource {
  static Future getCustomerPurchases(
      {required String eventId, required String userId}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.getCustomerPurchases(
      eventId: eventId,
      userId: userId,
    )}';

    dynamic response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(true));
    return response;
  }

  static Future markAsScanned({required String purchaseId}) async {
    final String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.markAsScanned(
      purchaseId: purchaseId,
    )}';
    final data = jsonEncode({"scanned": true});
    dynamic response = await HttpFactoryServices.postMethod(url,
        data: data, header: await setHeader(true));
    return response;
  }
}

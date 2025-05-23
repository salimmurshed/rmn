import 'dart:convert';

import '../../imports/common.dart';
import '../../imports/services.dart';

class QRDataSource {
  static Future postOrGetQRID(
      {required String id, required bool isPost}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.postOrGetQRId(id: id)}';
    final data = jsonEncode({
      "scanned": true,
    });
    dynamic response = isPost
        ? await HttpFactoryServices.postMethod(url,
            data: data, header: await setHeader(true))
        : await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }
}

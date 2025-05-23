import 'package:flutter/cupertino.dart';

import '../../imports/common.dart';
import '../../imports/services.dart';

class HistoryDataSource{
  static Future getHistory(
      {required int page, required String type}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.getHistory(page: page,type: type)}';

    dynamic response =
    await HttpFactoryServices.getMethod(url, header: await setHeader(true));
    return response;
  }
}
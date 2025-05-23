import 'dart:convert';

import '../../common/resources/app_urls.dart';
import '../../imports/data.dart';
import '../../imports/services.dart';

class GetInTouchDataSource {
  static Future postContact(
      {required GetInTouchRequestModel getInTouchRequestModel}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.submitQueries}';
    final data = jsonEncode({
      "first_name": getInTouchRequestModel.firstName,
      "last_name": getInTouchRequestModel.lastName,
      "phone_code": getInTouchRequestModel.countryCode,
      "contact_no": getInTouchRequestModel.phone,
      "email": getInTouchRequestModel.email,
      "query": getInTouchRequestModel.message,
    });

    dynamic response = await HttpFactoryServices.postMethod(
      url,
      data: data,
      header: await setHeader(true),
    );

    return response;
  }
}

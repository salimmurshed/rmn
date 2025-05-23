import 'package:flutter/cupertino.dart';
import 'package:rmnevents/imports/services.dart';

import '../../app_configurations/app_environments.dart';
import '../../di/di.dart';
import '../../imports/common.dart';

Future<Map<String, String>> setHeader(bool isTokenRequired,
    {bool isStripeTokenRequired = false, bool isMultipart = false}) async {
  Map<String, String> headers;
  UserCachedData userData = instance<UserCachedData>();

  if (isTokenRequired) {
    headers = {
      KeyManager.key_content_type: isMultipart
          ? ValueManager.value_multipart_data
          : ValueManager.value_application_json,
      KeyManager.key_access_token: await userData.getUserAccessToken() ?? AppStrings.global_empty_string,
          //"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2NjdhNzBkYTEzYTdmNGJmY2Y0MThiMDQiLCJpYXQiOjE3MTkzMDAzMTgsImV4cCI6MTcxOTkwNTExOH0.dncZ0k_U69Wj7QOn5TTnlRq1qO0xvoUnYwXxTQS3OkI"
    };
  }
  else if (isStripeTokenRequired) {
    String authToken = 'Bearer ${AppEnvironments.stripePublishableKey}';
    headers = {
      KeyManager.key_content_type: ValueManager.value_url_encoded,
      KeyManager.key_authorization: authToken,
    };
  }
  else {
    headers = {
      KeyManager.key_content_type: isMultipart
          ? ValueManager.value_multipart_data
          : ValueManager.value_application_json,
    };
  }
 debugPrint("header *************: $headers");
  return headers;
}

class KeyManager {
  static const String key_content_type = "Content-Type";
  static const String key_access_token = "access-token";
  static const String key_authorization = "Authorization";
}

class ValueManager {
  static const String value_application_json = "application/json";
  static const String value_multipart_data = "multipart/form-data";
  static String value_url_encoded = "application/x-www-form-urlencoded";
}

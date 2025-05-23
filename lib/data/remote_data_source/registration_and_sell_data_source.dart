import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../imports/common.dart';
import '../../imports/services.dart';
import '../models/request_models/employee_checkout_request_model.dart';

class RegistrationAndSellDataSource {
  static Future postProduct(
      {required String eventId,
      required EmployeeCheckoutRequestModel products}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.postProduct(eventId: eventId)}';
    final data = jsonEncode({
      "reader_id": products.readerId,
      "coupon": products.coupon ?? AppStrings.global_empty_string,
      "products": products.products?.map((e) => e.toJson()).toList(),
    });
    dynamic response = await HttpFactoryServices.postMethod(url,
        data: data,
        header: await setHeader(true));
    debugPrint(data, wrapWidth: 2000);
    debugPrint(response.body, wrapWidth: 2000);
    return response;
  }

  static Future postRegistration(
      {required String eventId,
        required EmployeeCheckoutRequestModel registration}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.postRegistration(eventId: eventId)}';
    final data = jsonEncode(registration.toJson());

    debugPrint('$data\n', wrapWidth: 4000);
    dynamic response = await HttpFactoryServices.postMethod(url,
        data: data,
        header: await setHeader(true));
    debugPrint(data.toString(), wrapWidth: 2000);
    debugPrint(response.body, wrapWidth: 2000);
    return response;
  }

  static Future cancelPurchase(
      {required String readerId,
        required String paymentId}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.cancelPurchase(paymentId: paymentId)}';

    final data = jsonEncode({
      "reader_id": readerId,
    });
    dynamic response = await HttpFactoryServices.postMethod(url,
        data: data,
        header: await setHeader(true));
    debugPrint(data.toString(), wrapWidth: 2000);
    debugPrint(response.body, wrapWidth: 2000);
    return response;
  }
}

import 'dart:convert';

import '../../imports/common.dart';
import '../../imports/services.dart';
import '../models/request_models/purchase_member_ship_request_model.dart';

class PaymentDataSource {
  static Future makePayment(
      {required PurchaseRequestModel purchaseRequestModel}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.purchaseMembership}';
    final data = jsonEncode({
      "card_token": purchaseRequestModel.cardToken,
      "save_card": purchaseRequestModel.saveCard,
      "existing": purchaseRequestModel.isExisting,
      "purchases": purchaseRequestModel.athleteWithAssignedSeasonPass
          .map((e) =>
              {'athlete_id': e.athleteId, 'membership_id': e.seasonPassId})
          .toList(),
      "products": purchaseRequestModel.productsForPurchase
          .map((e) => {
                'product_id': e.productId,
                'quantity': e.quantity,
                'variant': e.variant,
              })
          .toList(),
      "coupon": purchaseRequestModel.coupon,
    });
    print(data);

    dynamic response = await HttpFactoryServices.postMethod(
      url,
      data: data,
      header: await setHeader(true),
    );

    return response;
  }

  static Future removeCard({required String cardId}) async {
    final String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.removeCard}';
    final data = jsonEncode({
      "card_id": cardId,
    });

    dynamic response = await HttpFactoryServices.postMethod(
      url,
      data: data,
      header: await setHeader(true),
    );

    return response;
  }
}

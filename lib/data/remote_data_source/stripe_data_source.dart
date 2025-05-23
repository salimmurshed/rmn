import 'package:rmnevents/app_configurations/app_environments.dart';
import 'package:rmnevents/data/models/request_models/create_stripe_token_request_model.dart';
import 'package:rmnevents/imports/services.dart';

import '../../common/resources/app_urls.dart';

class StripeDataSource {
  static Future createStripeToken(
      {required CreateStripeTokenRequestModel createStripeTokenRequest}) async {
    String baseUrl = AppEnvironments.stripeTokenUrl;

    Map<String, dynamic> data = {
      "card[number]": createStripeTokenRequest.cardNumber.trim(),
      "card[exp_month]": createStripeTokenRequest.expiryMonth.trim(),
      "card[exp_year]": createStripeTokenRequest.expiryYear.trim(),
      "card[cvc]": createStripeTokenRequest.cvc.trim(),
      "card[name]": createStripeTokenRequest.cardHolderName.trim(),
    };

    final response = await HttpFactoryServices.postMethod(baseUrl,
        data: data,
        header: await setHeader(false, isStripeTokenRequired: true));

    return response;
  }
  static Future getStripeReaders() async {
    final String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.getStripeReaders}';
    dynamic response =
    await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }
}

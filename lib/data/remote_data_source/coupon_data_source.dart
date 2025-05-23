import '../../imports/common.dart';
import '../../imports/services.dart';

class CouponDataSource{
  static Future getCouponDetails({required String couponCode, required String module}) async {
    final String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.getCouponDetails(code: couponCode, module: module)}';
    dynamic response =
    await HttpFactoryServices.getMethod(url, header: await setHeader(true));
    return response;
  }
}
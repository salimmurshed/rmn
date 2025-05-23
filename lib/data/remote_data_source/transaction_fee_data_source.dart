import '../../imports/common.dart';
import '../../imports/services.dart';

class TransactionFeeDataSource{
  static Future getTransactionFee() async {
    final String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.getTransactionFee}';
    dynamic response =
    await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }
}
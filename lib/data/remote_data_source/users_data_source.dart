import '../../imports/common.dart';
import '../../imports/services.dart';

class UsersDataSource{
  static Future getUsers({required String searchKey, required int page}) async {
    final String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.getUsers(
      page: page,
      searchKey: searchKey,
    )}';
    dynamic response =
    await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }
}
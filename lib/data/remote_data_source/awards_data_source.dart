import '../../imports/common.dart';
import '../../imports/services.dart';

class AwardsDataSource {
  static Future getAwardsForSpecificAthlete(
      {required String athleteId,
      String seasonId = AppStrings.global_empty_string}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.getAwardsForSpecificAthlete(athleteId: athleteId, seasonId: seasonId)}';

    dynamic response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(true));
    return response;
  }
}

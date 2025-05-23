import '../../imports/common.dart';
import '../../imports/services.dart';

class RankDataSource{
  static Future getRankForSpecificAthlete(
      {required String athleteId, required
        String seasonId }) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.getRanksForSpecificAthlete(athleteId: athleteId, seasonId: seasonId)}';

    dynamic response =
    await HttpFactoryServices.getMethod(url, header: await setHeader(true));
    return response;
  }
}
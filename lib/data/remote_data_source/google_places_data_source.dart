import 'package:rmnevents/app_configurations/app_environments.dart';
import 'package:rmnevents/imports/services.dart';

class GooglePlacesDataSource {
  static Future getGooglePlaceApi({required String placeId}) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=${AppEnvironments.googlePlacesAPIKey}";
    final response = await HttpFactoryServices.getMethod(url,
        header: await setHeader(false));
    return response;
  }
}

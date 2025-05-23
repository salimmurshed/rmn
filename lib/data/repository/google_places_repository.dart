import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:google_places_autocomplete_text_field/model/place_details.dart';
import 'package:rmnevents/data/remote_data_source/google_places_data_source.dart';

import '../../imports/common.dart';

class GooglePlacesRepository {
  static Future<Either<Failure, PlaceDetails>> getGooglePlaceApi(
      {required String placeId}) async {
    final response =
        await GooglePlacesDataSource.getGooglePlaceApi(placeId: placeId);

    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = jsonDecode(response.body);

      PlaceDetails placeDetails = PlaceDetails.fromJson(responseJson);
      return Right(placeDetails);
    } else {
      return Left(Failure(
          code: response.statusCode,
          message: AppStrings.global_google_places_error));
    }
  }
}

import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';

class AwardsRepository {
  static Future<Either<Failure, AwardsResponseModel>>
      getAwardsForSpecificAthlete(
          {required String athleteId,
          String seasonId = AppStrings.global_empty_string}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await AwardsDataSource.getAwardsForSpecificAthlete(
            athleteId: athleteId, seasonId: seasonId);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        AwardsResponseModel awardsResponseModel =
            AwardsResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (awardsResponseModel.status!) {
            return Right(awardsResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: awardsResponseModel.responseData?.message ??
                  AppStrings.global_empty_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: awardsResponseModel.responseData?.message ??
                AppStrings.global_empty_string,
          )).failure);
        }
      } catch (error) {
        return Left(AppExceptions.handle(
            caughtFailure: Failure(
          code: ResponseCode.DEFAULT,
          message: extractErrorMessage(error),
        )).failure);
      }
    } else {
      return Left(AppExceptions.handle(
              caughtFailure: Failure(code: ResponseCode.NO_INTERNET_CONNECTION))
          .failure);
    }
  }
}

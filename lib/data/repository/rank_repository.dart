import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';

class RankRepository {
  static Future<Either<Failure, AthleteDetailsRankResponseModel>> getRanksForSpecificAthlete(
      {required String athleteId,
      String seasonId = AppStrings.global_empty_string}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await RankDataSource.getRankForSpecificAthlete(
            athleteId: athleteId, seasonId: seasonId);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        AthleteDetailsRankResponseModel rankResponseModel =
            AthleteDetailsRankResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (rankResponseModel.status!) {
            return Right(rankResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: rankResponseModel.responseData?.message ?? AppStrings.global_error_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: rankResponseModel.responseData?.message ?? AppStrings.global_error_string,
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

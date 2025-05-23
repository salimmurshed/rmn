import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';

class CurrentSeasonRepository {
  static Future<Either<Failure, CurrentSeasonResponseModel>>
      getCurrentSeason() async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
    dynamic response;
    try {
      response = await CurrentSeasonDataSource.getCurrentSeason();

      Map<String, dynamic> responseJson = jsonDecode(response.body);

      CurrentSeasonResponseModel currentSeasonResponseModel =
          CurrentSeasonResponseModel.fromJson(responseJson);

      if (response.statusCode == 200) {
        if (currentSeasonResponseModel.status!) {
          return Right(currentSeasonResponseModel);
        } else {
          return Left(AppExceptions.handle(
                  caughtFailure: Failure(
                      code: response.statusCode,
                      message: 'Encountered status: ${response.statusCode}'))
              .failure);
        }
      } else {
        return Left(AppExceptions.handle(
                caughtFailure: Failure(
                    code: response.statusCode,
                    message: 'Encountered status: ${response.statusCode}'))
            .failure);
      }
    } catch (error) {
      return Left(AppExceptions.handle(
          caughtFailure: Failure(
        code: ResponseCode.DEFAULT,
        message: extractErrorMessage(error),
      )).failure);
    }
    } else {
      return Left(AppExceptions
          .handle(
          caughtFailure: Failure(code: ResponseCode.NO_INTERNET_CONNECTION))
          .failure);
    }
  }
}

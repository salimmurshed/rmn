import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:rmnevents/data/models/response_models/season_passes_response_model.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';

class SeasonRepository {
  static Future<Either<Failure, SeasonListResponseModel>> getSeasons() async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await SeasonDataSource.getSeasons();

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        SeasonListResponseModel seasonListResponseModel =
            SeasonListResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (seasonListResponseModel.status!) {
            return Right(seasonListResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: AppStrings.global_error_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: AppStrings.global_error_string,
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

  static Future<Either<Failure, MyPurchasedSeasonPasses>>
      getMyPurchasesSeasonPasses() async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await SeasonDataSource.getMyPurchasesSeasonPasses();

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        MyPurchasedSeasonPasses myPurchasedSeasonPasses =
            MyPurchasedSeasonPasses.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (myPurchasedSeasonPasses.status!) {
            return Right(myPurchasedSeasonPasses);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: AppStrings.global_error_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: AppStrings.global_error_string,
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

  static Future<Either<Failure, SeasonPassesResponseModel>>
  getSeasonPasses() async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await SeasonDataSource.getSeasonPasses();

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        SeasonPassesResponseModel seasonPassesResponseModel =
        SeasonPassesResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (seasonPassesResponseModel.status!) {
            return Right(seasonPassesResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
                  code: response.statusCode,
                  message: AppStrings.global_error_string,
                )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
                code: response.statusCode,
                message: AppStrings.global_error_string,
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

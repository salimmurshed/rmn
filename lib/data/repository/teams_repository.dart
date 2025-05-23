import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';

class TeamsRepository {
  static Future<Either<Failure, TeamsResponseModel>> getTeams() async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await TeamsDataSource.getTeams();

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        TeamsResponseModel teamsResponseModel =
            TeamsResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (teamsResponseModel.status!) {
            return Right(teamsResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: teamsResponseModel.responseData?.message ??
                  AppStrings.global_empty_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: teamsResponseModel.responseData?.message ??
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

  static Future<Either<Failure, CommonResponseModel>> changeTeam(
      {required String athleteId,
      required String eventId,
      required String teamId}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await TeamsDataSource.changeTeam(athleteId: athleteId, eventId: eventId, teamId: teamId);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        CommonResponseModel commonResponseModel =
            CommonResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (commonResponseModel.status!) {
            return Right(commonResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: commonResponseModel.responseData?.message ??
                  AppStrings.global_empty_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: commonResponseModel.responseData?.message ??
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

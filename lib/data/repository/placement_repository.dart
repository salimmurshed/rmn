import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:rmnevents/data/models/response_models/rank_response_model.dart';
import 'package:rmnevents/data/remote_data_source/placement_data_source.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';

class PlacementRepository {
  static Future<Either<Failure, RankResponseModel>> getRanks(
      {required String id}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await PlacementDataSource.getPlacement(id: id);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        RankResponseModel rankResponseModel =
        RankResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (rankResponseModel.status!) {
            return Right(rankResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
                  code: response.statusCode,
                  message: rankResponseModel.responseData?.message ??
                      AppStrings.global_empty_string,
                )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
                code: response.statusCode,
                message: rankResponseModel.responseData?.message ??
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
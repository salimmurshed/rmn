import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';

class LegalsRepository{
  static Future<Either<Failure, LegalsResponseModel>> listCms(
    ) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await LegalsDataSource.listCms();

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        LegalsResponseModel legalsResponseModel =
        LegalsResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (legalsResponseModel.status!) {
            return Right(legalsResponseModel);
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
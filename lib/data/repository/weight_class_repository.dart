import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';

class WeightClassRepository {
  static Future<Either<Failure, AvailableWeightClassResponseModel>>
      getWeightClasses({required String divId, required String eventID}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await WeightClassDataSource.getWeightClasses(divId: divId, eventID: eventID);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        AvailableWeightClassResponseModel weightClassResponseModel =
            AvailableWeightClassResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (weightClassResponseModel.status!) {
            return Right(weightClassResponseModel);
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

  static Future<Either<Failure, CommonResponseModel>> changeWc(
      {required ChangeWCRequestModel changeWCRequestModel}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await WeightClassDataSource.changeWc(
            changeWCRequest: changeWCRequestModel);

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
                  AppStrings.global_error_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: commonResponseModel.responseData?.message ??
                AppStrings.global_error_string,
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

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:rmnevents/data/remote_data_source/grade_data_source.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';

class GradeRepository{
  static Future<Either<Failure, GradeResponseModel>> getGrades() async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await GradeDataSource.getGrades();

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        GradeResponseModel gradeResponseModel =
        GradeResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (gradeResponseModel.status!) {
            return Right(gradeResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
                  code: response.statusCode,
                  message: gradeResponseModel.responseData?.message ??
                      AppStrings.global_empty_string,
                )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
                code: response.statusCode,
                message: gradeResponseModel.responseData?.message ??
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

  static Future<Either<Failure, CommonResponseModel>>
  getUnreadCount() async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await GradeDataSource.getUnreadCount();
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        print(responseJson);
        CommonResponseModel commonResponseModel =
        CommonResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (commonResponseModel.status!) {
            return Right(commonResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
                  code: response.statusCode,
                  message: commonResponseModel.responseData?.message ?? AppStrings.global_empty_string,
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
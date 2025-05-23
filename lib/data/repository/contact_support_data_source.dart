import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';
import '../remote_data_source/contact_support_data_source.dart';

class ContactSupportRepository{
  static Future<Either<Failure, CommonResponseModel>> askContactSupport(
      {required String athleteId}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await ContactSupportDataSource.askContactSupport(athleteId: athleteId);

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
                  message: commonResponseModel.responseData?.message ?? AppStrings.global_error_string,
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
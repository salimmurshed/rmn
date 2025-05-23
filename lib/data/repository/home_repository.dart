import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';

class HomeRepository {
  static Future<Either<Failure, ClientHomeResponseModel>>
      getClientHome() async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await HomeDataSource.getClientHome();

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        ClientHomeResponseModel clientHomeResponseModel =
            ClientHomeResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (clientHomeResponseModel.status!) {
            return Right(clientHomeResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: clientHomeResponseModel.responseData?.message ??
                  AppStrings.global_empty_string,
            )).failure);
          }
        } else {

          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: clientHomeResponseModel.responseData?.message ??
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

import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';

class TransactionFeeRepository{
  static Future<Either<Failure, TransactionFeeResponseModel>>
  getTransactionFee() async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await TransactionFeeDataSource.getTransactionFee();

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        TransactionFeeResponseModel transactionFeeResponseModel =
        TransactionFeeResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (transactionFeeResponseModel.status!) {
            return Right(transactionFeeResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
                  code: response.statusCode,
                  message:  AppStrings.global_error_string,

                )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
                code: response.statusCode,
                message:
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
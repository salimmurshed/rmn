import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:rmnevents/data/remote_data_source/sales_data_source.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';
import '../models/response_models/sales_transaction_response_model.dart';

class SalesRepository{
  static Future<Either<Failure, SalesTransactionResponseModel>> getSales({required int page}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await SalesDataSource.getSales(page: page);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        SalesTransactionResponseModel sales =
        SalesTransactionResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (sales.status!) {
            return Right(sales);
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
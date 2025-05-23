import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:rmnevents/data/remote_data_source/history_data_source.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';
import '../models/response_models/history_response_model.dart';

class HistoryRepository {
  static Future<Either<Failure, HistoryResponseModel>> getHistory({required int page, required String type}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await HistoryDataSource.getHistory(page: page, type: type);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        HistoryResponseModel historyResponseModel =
        HistoryResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (historyResponseModel.status!) {
            return Right(historyResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
                  code: response.statusCode,
                  message: historyResponseModel.responseData?.message ??
                      AppStrings.global_empty_string,
                )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
                code: response.statusCode,
                message: historyResponseModel.responseData?.message ??
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
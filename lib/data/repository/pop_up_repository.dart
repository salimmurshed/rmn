
import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';
import '../remote_data_source/pop_up_data_source.dart';

class PopUpRepository{
  static Future<Either<Failure, PopUpListResponseModel>> getPopUpList() async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await PopUpDataSource.getPopUpList();

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        PopUpListResponseModel popUpListResponseModel =
        PopUpListResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (popUpListResponseModel.status!) {
            return Right(popUpListResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
                  code: response.statusCode,
                  message: popUpListResponseModel.responseData?.message ??
                      AppStrings.global_empty_string,
                )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
                code: response.statusCode,
                message: popUpListResponseModel.responseData?.message ??
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
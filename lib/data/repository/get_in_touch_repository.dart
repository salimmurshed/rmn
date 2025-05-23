import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:rmnevents/data/remote_data_source/get_in_touch_datat_source.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';

class GetInTouchRepository {
  static Future<Either<Failure, GetInTouchResponseModel>> postContact(
      {required GetInTouchRequestModel getInTouchRequestModel}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await GetInTouchDataSource.postContact(
            getInTouchRequestModel: getInTouchRequestModel);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        GetInTouchResponseModel getInTouchResponseModel =
            GetInTouchResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (getInTouchResponseModel.status!) {
            return Right(getInTouchResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: getInTouchResponseModel.responseData!.message!,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: getInTouchResponseModel.responseData!.message!,
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

  static Future<Either<Failure, NotificationCountReadResponseModel>>
      getNotificationCount() async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await NotificationDataSource.getNotificationCount();

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        NotificationCountReadResponseModel notificationCountReadResponseModel =
            NotificationCountReadResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (notificationCountReadResponseModel.status!) {
            return Right(notificationCountReadResponseModel);
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
          message: error.toString(),
        )).failure);
      }
    } else {
      return Left(AppExceptions.handle(
              caughtFailure: Failure(code: ResponseCode.NO_INTERNET_CONNECTION))
          .failure);
    }
  }
}

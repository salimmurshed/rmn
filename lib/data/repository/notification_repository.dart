import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:rmnevents/data/models/response_models/notification_count_read_response_model.dart';
import 'package:rmnevents/data/models/response_models/notification_response_model.dart';
import 'package:rmnevents/data/remote_data_source/notification_data_source.dart';
import 'package:rmnevents/data/repository/repository_dependencies.dart';

import '../../imports/common.dart';

class NotificationRepository {
  static Future<Either<Failure, NotificationResponseModel>> getNotificationList(
     ) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await NotificationDataSource.getNotificationList();

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        NotificationResponseModel notificationResponseModel =
            NotificationResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (notificationResponseModel.status!) {
            return Right(notificationResponseModel);
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
  static Future<Either<Failure, NotificationCountReadResponseModel>> getNotificationCount(
      ) async {
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

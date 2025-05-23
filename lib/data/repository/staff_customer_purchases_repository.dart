import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:rmnevents/data/models/response_models/staff_customer_purchases.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';
import '../remote_data_source/staff_customer_purchases_data_source.dart';

class StaffCustomerPurchasesRepository {
  static Future<Either<Failure, StaffCustomerPurchases>>
  getUsers({required String eventId, required String userId}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await StaffCustomerPurchasesDataSource.getCustomerPurchases(
          eventId: eventId,
          userId: userId,
        );

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        StaffCustomerPurchases staffCustomerPurchases =
        StaffCustomerPurchases.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (staffCustomerPurchases.status!) {
            return Right(staffCustomerPurchases);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
                  code: response.statusCode,
                  message:
                  AppStrings.global_error_string,
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

  static Future<Either<Failure, QrIdScannedResponseModel>>
  markAsScanned({required String purchaseId}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await StaffCustomerPurchasesDataSource.markAsScanned(
          purchaseId: purchaseId,
        );

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        QrIdScannedResponseModel qrIdScannedResponseModel =
        QrIdScannedResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (qrIdScannedResponseModel.status!) {
            return Right(qrIdScannedResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
                  code: response.statusCode,
                  message:
                  AppStrings.global_error_string,
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

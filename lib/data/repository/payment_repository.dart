import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';
import '../models/response_models/purchase_response_model.dart';
import '../remote_data_source/payment_data_source.dart';

class PaymentRepository {
  static Future<Either<Failure, PurchaseResponseModel>> makePayment(
      {required PurchaseRequestModel purchaseRequestModel}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await PaymentDataSource.makePayment(
            purchaseRequestModel: purchaseRequestModel);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        PurchaseResponseModel purchaseMembershipResponseModel =
            PurchaseResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (purchaseMembershipResponseModel.status!) {
            return Right(purchaseMembershipResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: purchaseMembershipResponseModel.responseData?.message ??
                  AppStrings.global_empty_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: purchaseMembershipResponseModel.responseData?.message ??
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

  static Future<Either<Failure, CommonResponseModel>> removeCard(
      {required String cardId}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await PaymentDataSource.removeCard(cardId: cardId);

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
              message: commonResponseModel.responseData?.error ??
                  AppStrings.global_empty_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: commonResponseModel.responseData?.error ??
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

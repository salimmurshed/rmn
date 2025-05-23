import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:rmnevents/data/models/response_models/common_response_model.dart';
import 'package:rmnevents/data/models/response_models/registration_and_sell_response_model.dart';
import 'package:rmnevents/data/remote_data_source/registration_and_sell_data_source.dart';
import 'package:rmnevents/data/repository/repository_dependencies.dart';

import '../../imports/common.dart';
import '../models/request_models/employee_checkout_request_model.dart';

class RegisterAndSellRepository {
  static Future<Either<Failure, RegistrationAndSellResponseModel>> postProduct(
      {required String eventId,
      required EmployeeCheckoutRequestModel products}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await RegistrationAndSellDataSource.postProduct(
            eventId: eventId, products: products);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        RegistrationAndSellResponseModel responseModel =
            RegistrationAndSellResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (responseModel.status!) {
            return Right(responseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: responseModel.responseData?.message ??
                  AppStrings.global_error_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: responseModel.responseData?.message ??
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

  static Future<Either<Failure, RegistrationAndSellResponseModel>> postRegistration(
      {required String eventId,
        required EmployeeCheckoutRequestModel registrations}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await RegistrationAndSellDataSource.postRegistration(
            eventId: eventId, registration: registrations);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        RegistrationAndSellResponseModel responseModel =
        RegistrationAndSellResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (responseModel.status!) {
            return Right(responseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
                  code: response.statusCode,
                  message: responseModel.responseData?.message ??
                      AppStrings.global_error_string,
                )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
                code: response.statusCode,
                message: responseModel.responseData?.message ??
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

  static Future<Either<Failure, CommonResponseModel>> cancelPurchase(
      {required String readerId,
        required String paymentId}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await RegistrationAndSellDataSource.cancelPurchase(
        paymentId: paymentId, readerId: readerId);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        CommonResponseModel responseModel =
        CommonResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (responseModel.status!) {
            return Right(responseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
                  code: response.statusCode,
                  message: responseModel.responseData?.message ??
                      AppStrings.global_error_string,
                )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
                code: response.statusCode,
                message: responseModel.responseData?.message ??
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

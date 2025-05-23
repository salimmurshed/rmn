import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../imports/common.dart';

import '../../imports/data.dart';
import '../models/response_models/stripe_readers_response_model.dart';

class StripeRepository {
  static Future<Either<Failure, StripePaymentCardResponseModel>>
      createStripeToken(
          {required CreateStripeTokenRequestModel
              createStripeTokenRequest})
  async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await StripeDataSource.createStripeToken(
            createStripeTokenRequest: createStripeTokenRequest);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        StripePaymentCardResponseModel stripePaymentCardResponseModel =
            StripePaymentCardResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          return Right(stripePaymentCardResponseModel);
        } else {
          Map<String, dynamic> responseJson = jsonDecode(response.body);

          StripeErrorResponse stripeErrorResponse =
          StripeErrorResponse.fromJson(responseJson);
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: stripeErrorResponse.error?.message ??
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

  static Future<Either<Failure, StripeReadersResponseModel>>
  getStripeReaders() async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await StripeDataSource.getStripeReaders();

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        StripeReadersResponseModel stripeReadersResponseModel =
        StripeReadersResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          return Right(stripeReadersResponseModel);
        } else {
          Map<String, dynamic> responseJson = jsonDecode(response.body);

          StripeErrorResponse stripeErrorResponse =
          StripeErrorResponse.fromJson(responseJson);
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
                code: response.statusCode,
                message: stripeErrorResponse.error?.message ??
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

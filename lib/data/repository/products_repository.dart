import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';

class ProductsRepository {
  static Future<Either<Failure, MyPurchasedProductsResponseModel>>
      getMyPurchasesProducts() async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await ProductsDataSource.getMyPurchasesProducts();

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        MyPurchasedProductsResponseModel myPurchasedProductsResponseModel =
            MyPurchasedProductsResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (myPurchasedProductsResponseModel.status!) {
            return Right(myPurchasedProductsResponseModel);
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
          message:extractErrorMessage(error),
        )).failure);
      }
    } else {
      return Left(AppExceptions.handle(
              caughtFailure: Failure(code: ResponseCode.NO_INTERNET_CONNECTION))
          .failure);
    }
  }

  static Future<
          Either<Failure, MyPurchasedProductsDetailEventWiseResponseModel>>
      getMyPurchasedProductDetailEventWise({required String eventId}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await ProductsDataSource.getMyPurchasedProductDetailEventWise(eventId: eventId);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        MyPurchasedProductsDetailEventWiseResponseModel
            myPurchasedProductsDetailEventWiseResponseModel =
            MyPurchasedProductsDetailEventWiseResponseModel.fromJson(
                responseJson);

        if (response.statusCode == 200) {
          if (myPurchasedProductsDetailEventWiseResponseModel.status!) {
            return Right(myPurchasedProductsDetailEventWiseResponseModel);
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

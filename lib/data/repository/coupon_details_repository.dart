import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';

class CouponDetailsRepository {
  static Future<Either<Failure, CouponDetailResponseModel>> getCouponDetails(
      {required String couponCode, required String module}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await CouponDataSource.getCouponDetails(
            couponCode: couponCode, module: module);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        CouponDetailResponseModel couponDetailResponseModel =
            CouponDetailResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (couponDetailResponseModel.status!) {
            return Right(couponDetailResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: couponDetailResponseModel.responseData?.message ?? AppStrings.global_error_string,
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

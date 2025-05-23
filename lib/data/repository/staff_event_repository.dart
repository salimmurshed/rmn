import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';
import '../models/response_models/staff_event_data_response_model.dart';
import '../remote_data_source/staff_event_data_source.dart';

class StaffEventRepository {
  static Future<Either<Failure, StaffEventDataResponseModel>> getStaffEventData(
      {required String id}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await StaffEventDataSource.getStaffEventData(id: id);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        StaffEventDataResponseModel purchaseMembershipResponseModel =
            StaffEventDataResponseModel.fromJson(responseJson);

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
}

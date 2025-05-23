import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:rmnevents/data/models/response_models/users_response_model.dart';
import 'package:rmnevents/data/remote_data_source/users_data_source.dart';
import '../../imports/common.dart';
import '../../imports/data.dart';

class UsersRepository {
  static Future<Either<Failure, UsersResponse>>
  getUsers({required String searchKey, required int page}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await UsersDataSource.getUsers(searchKey: searchKey, page: page);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        UsersResponse usersResponse =
        UsersResponse.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (usersResponse.status!) {
            return Right(usersResponse);
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

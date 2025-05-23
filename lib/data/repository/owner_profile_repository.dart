import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';
import '../../imports/services.dart';

class OwnerProfileRepository {
  static Future<Either<Failure, UserResponseModel>> createOwnerProfile(
      {required CreateProfileRequestModel
          createOwnerProfileRequestModel})
  async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await OwnerProfileDataSource.createEditOwnerProfile(
            createOwnerProfileRequestModel: createOwnerProfileRequestModel);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        UserResponseModel createOwnerProfileResponseModel =
            UserResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (createOwnerProfileResponseModel.status!) {
            await RepositoryDependencies.userCachedData
                .removeSharedPreferencesGeneralFunction(UserKeyManager.userId);
            await RepositoryDependencies.userCachedData
                .removeSharedPreferencesGeneralFunction(
                    UserKeyManager.userEmail);

            //Access Token is not returned in the response
            //So we cant update it and so we dont need to remove it
            // await RepositoryDependencies.userCachedData
            //     .removeSharedPreferencesGeneralFunction(
            //         UserKeyManager.accessToken);
            createOwnerProfileResponseModel.responseData?.user?.token =
                await RepositoryDependencies.userCachedData
                    .getUserAccessToken();
            UserResponseModel updatedCreateOwnerResponseModel =
                await GlobalHandlers.updateResponseModel(
                    responseModel: createOwnerProfileResponseModel);
            await RepositoryDependencies.userCachedData
                .setUserSession(value: true);
            return Right(updatedCreateOwnerResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: createOwnerProfileResponseModel.responseData?.message ??
                  AppStrings.global_empty_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: createOwnerProfileResponseModel.responseData?.message ??
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
  static Future<Either<Failure, UserResponseModel>> getProfile()
  async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await OwnerProfileDataSource.getProfile();

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        UserResponseModel createOwnerProfileResponseModel =
            UserResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (createOwnerProfileResponseModel.status!) {
            await RepositoryDependencies.userCachedData
                .removeSharedPreferencesGeneralFunction(UserKeyManager.userId);
            await RepositoryDependencies.userCachedData
                .removeSharedPreferencesGeneralFunction(
                    UserKeyManager.userEmail);

            //Access Token is not returned in the response
            //So we cant update it and so we dont need to remove it
            // await RepositoryDependencies.userCachedData
            //     .removeSharedPreferencesGeneralFunction(
            //         UserKeyManager.accessToken);
            createOwnerProfileResponseModel.responseData?.user?.token =
                await RepositoryDependencies.userCachedData
                    .getUserAccessToken();
            UserResponseModel updatedCreateOwnerResponseModel =
                await GlobalHandlers.updateResponseModel(
                    responseModel: createOwnerProfileResponseModel);
            await RepositoryDependencies.userCachedData
                .setUserSession(value: true);
            return Right(updatedCreateOwnerResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: createOwnerProfileResponseModel.responseData?.message ??
                  AppStrings.global_empty_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: createOwnerProfileResponseModel.responseData?.message ??
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

  static Future<Either<Failure, CommonResponseModel>> changeEmail(
      {required String email})
  async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await OwnerProfileDataSource.changeEmail(email: email);

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
              message: commonResponseModel.responseData?.message ??
                  AppStrings.global_empty_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: commonResponseModel.responseData?.message ??
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
  static Future<Either<Failure, CommonResponseModel>> updateEmail(
      {required String email, required String otp})
  async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await OwnerProfileDataSource.updateEmail(email: email, otp: otp);

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
                  message: commonResponseModel.responseData?.message ??
                      AppStrings.global_empty_string,
                )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
                code: response.statusCode,
                message: commonResponseModel.responseData?.message ??
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

  static Future<Either<Failure, CommonResponseModel>> changePassword(
      {required String oldPassword, required String newPassword})
  async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await OwnerProfileDataSource.changePassword(newPassword: newPassword, oldPassword: oldPassword);

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
                  message: commonResponseModel.responseData?.message ??
                      AppStrings.global_empty_string,
                )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
                code: response.statusCode,
                message: commonResponseModel.responseData?.message ??
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
  static Future<Either<Failure, CommonResponseModel>> deleteAccount()
  async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await OwnerProfileDataSource.deleteAccount();

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
                  message: commonResponseModel.responseData?.message ??
                      AppStrings.global_empty_string,
                )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
                code: response.statusCode,
                message: commonResponseModel.responseData?.message ??
                    AppStrings.global_empty_string,
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
}

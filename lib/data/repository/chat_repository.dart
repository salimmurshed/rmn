import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';
class ChatRepository{
  static Future<Either<Failure, ChatResponseModel>> getEventChat(
      {required String eventId}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await ChatDataSource.getEventChat(eventId: eventId);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        ChatResponseModel chatResponseModel =
        ChatResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (chatResponseModel.status!) {
            return Right(chatResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
                  code: response.statusCode,
                  message: chatResponseModel.responseData!.message ?? AppStrings.global_error_string,
                )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
                code: response.statusCode,
                message:chatResponseModel.responseData!.message ?? AppStrings.global_error_string,
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

  static Future<Either<Failure, ChatResponseModel>> getGeneralChat(
      {required String eventId}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await ChatDataSource.getGeneralChats(eventId: eventId);

        Map<String, dynamic> responseJson = jsonDecode(response.body);
        ChatResponseModel chatResponseModel =
        ChatResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (chatResponseModel.status!) {
            return Right(chatResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
                  code: response.statusCode,
                  message: chatResponseModel.responseData!.message ?? AppStrings.global_error_string,
                )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
                code: response.statusCode,
                message:chatResponseModel.responseData!.message ?? AppStrings.global_error_string,
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

  static Future<Either<Failure, CommonResponseModel>>
  unReadMessage({required String roomId}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await ChatDataSource.unReadMessage(roomId: roomId);
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        print(responseJson);
        CommonResponseModel commonResponseModel =
        CommonResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (commonResponseModel.status!) {
            return Right(commonResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
                  code: response.statusCode,
                  message: commonResponseModel.responseData?.message ?? AppStrings.global_empty_string,
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
  static Future<Either<Failure, CommonResponseModel>>
  markAsRead({required String roomId}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await ChatDataSource.markAsRead(roomId: roomId);
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        print(responseJson);
        CommonResponseModel commonResponseModel =
        CommonResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (commonResponseModel.status!) {
            return Right(commonResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
                  code: response.statusCode,
                  message: commonResponseModel.responseData?.message ?? AppStrings.global_empty_string,
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
}
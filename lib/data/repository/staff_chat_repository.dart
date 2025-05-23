import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:rmnevents/data/remote_data_source/general_chat_data_source.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';
import '../models/request_models/chat_list_request_model.dart';
import '../models/response_models/event_list_chat.dart';
import '../models/response_models/general_chat_list_response_model.dart';

class GeneralChatRepository {
  static Future<Either<Failure, GeneralChatListResponseModel>>
  getGenralChatList({required ChatListRequestModel chatRequestModel}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await GenralchatDatasource.getGeneralChatList(chatRequestModel: chatRequestModel);
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        print(responseJson);
        GeneralChatListResponseModel genralChatListResponseModel =
        GeneralChatListResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (genralChatListResponseModel.status!) {
            return Right(genralChatListResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
                  code: response.statusCode,
                  message: genralChatListResponseModel.generalListresponseData?.message ??
                      AppStrings.global_empty_string,
                )).failure);
          }
        } else {

          return Left(AppExceptions.handle(
              caughtFailure: Failure(
                code: response.statusCode,
                message: genralChatListResponseModel.generalListresponseData?.message ??
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
  static Future<Either<Failure, ChatEventListResponse>>
  getEventList() async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await GenralchatDatasource.getEventChatList();
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        print(responseJson);
        ChatEventListResponse chatEventListResponse =
        ChatEventListResponse.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (chatEventListResponse.status!) {
            return Right(chatEventListResponse);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
                  code: response.statusCode,
                  message: chatEventListResponse.responseData?.message ??
                      AppStrings.global_empty_string,
                )).failure);
          }
        } else {

          return Left(AppExceptions.handle(
              caughtFailure: Failure(
                code: response.statusCode,
                message: chatEventListResponse.responseData?.message ??
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
  deleteGeneralChat({required String roomId}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await GenralchatDatasource.deleteGenralChat(roomId);
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
  addToArchiveChat({required String roomId}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await GenralchatDatasource.addToArchiveChat(roomId);
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
  removeFromArchiveChat({required String roomId}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await GenralchatDatasource.removeFromArchiveChat(roomId);
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
              message:extractErrorMessage(error),
            )).failure);
      }
    } else {
      return Left(AppExceptions.handle(
          caughtFailure: Failure(code: ResponseCode.NO_INTERNET_CONNECTION))
          .failure);
    }
  }

  static Future<Either<Failure, GeneralChatListResponseModel>>
  fetchEventChatsData({required ChatListRequestModel chatRequestModel}) async {
    print('inside api call');
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await GenralchatDatasource.fetchEventChatsData(chatRequestModel: chatRequestModel);
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        print(responseJson);
        GeneralChatListResponseModel genralChatListResponseModel =
        GeneralChatListResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (genralChatListResponseModel.status!) {
            return Right(genralChatListResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
                  code: response.statusCode,
                  message: genralChatListResponseModel.generalListresponseData?.message ??
                      AppStrings.global_empty_string,
                )).failure);
          }
        } else {

          return Left(AppExceptions.handle(
              caughtFailure: Failure(
                code: response.statusCode,
                message: genralChatListResponseModel.generalListresponseData?.message ??
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
  unArchiveAll({required String eventId}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await GenralchatDatasource.unArchiveAll(eventId);
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
  fetchUnreadCounts({required String eventId}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await GenralchatDatasource.unReadCount(eventId);
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

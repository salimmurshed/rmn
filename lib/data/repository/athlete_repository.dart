import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:rmnevents/data/models/response_models/athlete_partial_owner_list_response_model.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';

class AthleteRepository {
  static Future<Either<Failure, CreateAthleteResponseModel>> createAthlete(
      {required CreateProfileRequestModel createProfileRequestModel}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await AthleteDataSource.createAthlete(
            createProfileRequestModel: createProfileRequestModel);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        CreateAthleteResponseModel createAthleteResponseModel =
            CreateAthleteResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (createAthleteResponseModel.status!) {
            return Right(createAthleteResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: createAthleteResponseModel.responseData?.message ??
                  AppStrings.global_empty_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: createAthleteResponseModel.responseData?.message ??
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

  static Future<Either<Failure, ReceivedAthleteRequestModelResponse>>
      getReceivedRequests(
          {required int page, required String searchKey}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await AthleteDataSource.receivedAthleteRequests(
            page: page, searchKey: searchKey);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        ReceivedAthleteRequestModelResponse receivedRequestModelResponse =
            ReceivedAthleteRequestModelResponse.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (receivedRequestModelResponse.status!) {
            return Right(receivedRequestModelResponse);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: receivedRequestModelResponse.responseData?.message ??
                  AppStrings.global_empty_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: receivedRequestModelResponse.responseData?.message ??
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

  static Future<Either<Failure, AthleteResponseModel>>
      getAthletesOrSearchAthletes(
          {required AthleteApiType athleteApiType,
          int page = 1,
          String eventId = AppStrings.global_empty_string,
          String searchKey = AppStrings.global_empty_string}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        switch (athleteApiType) {
          case AthleteApiType.eventWiseAthletes:
            response =
                await AthleteDataSource.getEventWiseAthletes(eventId: eventId);
            break;
          case AthleteApiType.homeAthletes:
            response = await AthleteDataSource.myAthletes(page: page);
            break;
          case AthleteApiType.myAthletes:
            response = await AthleteDataSource.myAthletes(
                page: page, searchKey: searchKey);
            break;
          default:
            response = await AthleteDataSource.myAthletes(
                page: page, searchKey: searchKey);
            break;
        }

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        AthleteResponseModel athleteResponseModel =
            AthleteResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (athleteResponseModel.status!) {
            return Right(athleteResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: athleteResponseModel.responseData?.message ??
                  AppStrings.global_empty_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: athleteResponseModel.responseData?.message ??
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

  static Future<Either<Failure, AllAthletesResponseModel>>
      getAllOrSearchAthletes(
          {required AthleteApiType athleteApiType,
          int page = 1,
          String searchKey = AppStrings.global_empty_string}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        switch (athleteApiType) {
          case AthleteApiType.allAthletes:
            response = await AthleteDataSource.allAthletes(page: page);
            break;
          case AthleteApiType.findAthletes:
            response =
                await AthleteDataSource.searchAthlete(searchKey: searchKey);
            break;
          default:
            response = await AthleteDataSource.allAthletes(page: page);
            break;
        }

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        AllAthletesResponseModel athleteResponseModel =
            AllAthletesResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (athleteResponseModel.status!) {
            return Right(athleteResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: response.statusCode.toString(),
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: response.statusCode.toString(),
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

  static Future<Either<Failure, SendRequestResponseModel>>
      sendRequestForAthlete(
          {required String accessType, required String athleteId}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await AthleteDataSource.sendRequestForAthlete(
            accessType: accessType, athleteId: athleteId);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        SendRequestResponseModel sendRequestResponseModel =
            SendRequestResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (sendRequestResponseModel.status!) {
            return Right(sendRequestResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: sendRequestResponseModel.responseData?.message ??
                  AppStrings.global_empty_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: sendRequestResponseModel.responseData?.message ??
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
      cancelSentRequestForAthlete({required String athleteId}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await AthleteDataSource.cancelSentRequestForAthlete(
            athleteId: athleteId);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        CommonResponseModel cancelSentRequestResponseModel =
            CommonResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (cancelSentRequestResponseModel.status!) {
            return Right(cancelSentRequestResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: cancelSentRequestResponseModel.responseData?.message ??
                  AppStrings.global_empty_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: cancelSentRequestResponseModel.responseData?.message ??
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

  static Future<Either<Failure, CommonResponseModel>> acceptReject(
      {required String requestId, required bool isAccepted}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await AthleteDataSource.acceptReject(
            requestId: requestId, isAccepted: isAccepted);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        CommonResponseModel acceptRejectResponse =
            CommonResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (acceptRejectResponse.status!) {
            return Right(acceptRejectResponse);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: acceptRejectResponse.responseData?.message ??
                  AppStrings.global_empty_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: acceptRejectResponse.responseData?.message ??
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

  static Future<Either<Failure, AthleteDetailsResponseModel>> getAthleteDetails(
      {required String athleteId,
      String seasonId = AppStrings.global_empty_string}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await AthleteDataSource.getAthleteDetails(
            athleteId: athleteId, seasonId: seasonId);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        AthleteDetailsResponseModel athleteDetailsResponseModel =
            AthleteDetailsResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (athleteDetailsResponseModel.status!) {
            return Right(athleteDetailsResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: athleteDetailsResponseModel.responseData?.message ??
                  AppStrings.global_empty_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: athleteDetailsResponseModel.responseData?.message ??
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

  static Future<Either<Failure, AthletePartialOwnerListResponseModel>>
      getAthletePartialOwnerList(
          {required String athleteId, required bool isViewer}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await AthleteDataSource.getAthletePartialOwnerList(
            athleteId: athleteId, isViewer: isViewer);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        AthletePartialOwnerListResponseModel
            athletePartialOwnerListResponseModel =
            AthletePartialOwnerListResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (athletePartialOwnerListResponseModel.status!) {
            return Right(athletePartialOwnerListResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message:
                  athletePartialOwnerListResponseModel.responseData?.message ??
                      AppStrings.global_empty_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message:
                athletePartialOwnerListResponseModel.responseData?.message ??
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

  static Future<Either<Failure, CommonResponseModel>> removeAthletePartialOwner(
      {required String athleteId,
      required String userId,
      required bool isViewer}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await AthleteDataSource.removeAthletePartialOwner(
            userId: userId, athleteId: athleteId, isViewer: isViewer);

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

  static Future<Either<Failure, AthleteWithoutSeasonPassResponseModel>>
      getAthletesWithoutSeasonPass() async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await AthleteDataSource.getAthletesWithoutSeasonPass();

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        AthleteWithoutSeasonPassResponseModel
            athleteWithoutSeasonPassResponseModel =
            AthleteWithoutSeasonPassResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (athleteWithoutSeasonPassResponseModel.status!) {
            return Right(athleteWithoutSeasonPassResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message:
                  athleteWithoutSeasonPassResponseModel.responseData?.message ??
                      AppStrings.global_empty_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message:
                athleteWithoutSeasonPassResponseModel.responseData?.message ??
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

  static Future<Either<Failure, CommonResponseModel>> deleteAthleteAccount(
      {required String athleteId}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response =
            await AthleteDataSource.deleteAthleteAccount(athleteId: athleteId);
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

  static Future<Either<Failure, CommonResponseModel>> teamNameRequest(
      {required String teamName}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await AthleteDataSource.teamNameRequest(teamName: teamName);
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
  static Future<Either<Failure, CustomerAthleteResponseModel>>
  getCustomerAthletes(
      {required String eventId, required String userId}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response =
        await AthleteDataSource.getCustomerAthletes(eventId: eventId, userId: userId);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        CustomerAthleteResponseModel athleteResponseModel =
        CustomerAthleteResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (athleteResponseModel.status!) {
            return Right(athleteResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
                  code: response.statusCode,
                  message: athleteResponseModel.responseData?.message ??
                      AppStrings.global_empty_string,
                )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
                code: response.statusCode,
                message: athleteResponseModel.responseData?.message ??
                    AppStrings.global_empty_string,
              )).failure);
        }
      } catch (error) {
        return Left(AppExceptions.handle(
            caughtFailure: Failure(
              code: ResponseCode.DEFAULT,
              message: error.toString(),
            )).failure);
      }
    } else {
      return Left(AppExceptions.handle(
          caughtFailure: Failure(code: ResponseCode.NO_INTERNET_CONNECTION))
          .failure);
    }
  }
}

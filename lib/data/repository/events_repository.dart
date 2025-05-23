import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';
import '../models/request_models/event_purchase_request_model.dart';
import '../models/response_models/employee_event_list_response.dart';
import '../models/response_models/registration_list_model.dart';

class EventsRepository {
  static Future<Either<Failure, AllEventsResponseModel>> getAllEvents(
      {required num page}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await EventDataSource.getAllEvents(page: page);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        AllEventsResponseModel allEventsResponseModel =
            AllEventsResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (allEventsResponseModel.status!) {
            return Right(allEventsResponseModel);
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

  static Future<Either<Failure, EmployeeEventListResponse>> getEmployeeEventList(
     ) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await EventDataSource.getEmployeeEventList();

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        EmployeeEventListResponse allEventsResponseModel =
        EmployeeEventListResponse.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (allEventsResponseModel.status!) {
            return Right(allEventsResponseModel);
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
          message: error.toString(),
        )).failure);
      }
    } else {
      return Left(AppExceptions.handle(
              caughtFailure: Failure(code: ResponseCode.NO_INTERNET_CONNECTION))
          .failure);
    }
  }

  static Future<Either<Failure, EventsOnMapResponseModel>> getEventsOnMap(
      {FilterType filterType = FilterType.none}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = filterType == FilterType.none
            ? await EventDataSource.getEventsOnMap()
            : await EventDataSource.getFilteredEventsOnMaps(
                filterType: filterType);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        EventsOnMapResponseModel eventsOnMapResponseModel =
            EventsOnMapResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (eventsOnMapResponseModel.status!) {
            return Right(eventsOnMapResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: eventsOnMapResponseModel.responseData?.message ??
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
          message: error.toString(),
        )).failure);
      }
    } else {
      return Left(AppExceptions.handle(
              caughtFailure: Failure(code: ResponseCode.NO_INTERNET_CONNECTION))
          .failure);
    }
  }

  static Future<Either<Failure, EventsOnMapResponseModel>> getSearchEventsOnMap(
      {required String searchKey}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response =
            await EventDataSource.getSearchEventsOnMap(searchKey: searchKey);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        EventsOnMapResponseModel eventsOnMapResponseModel =
            EventsOnMapResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (eventsOnMapResponseModel.status!) {
            return Right(eventsOnMapResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: eventsOnMapResponseModel.responseData?.message ??
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
          message: error.toString(),
        )).failure);
      }
    } else {
      return Left(AppExceptions.handle(
              caughtFailure: Failure(code: ResponseCode.NO_INTERNET_CONNECTION))
          .failure);
    }
  }

  static Future<Either<Failure, AllEventsResponseModel>> getFilteredEvents(
      {required num page, required FilterType filterType}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await EventDataSource.getFilteredEvents(
            page: page, filterType: filterType);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        AllEventsResponseModel allEventsResponseModel =
            AllEventsResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (allEventsResponseModel.status!) {
            return Right(allEventsResponseModel);
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
          message: error.toString(),
        )).failure);
      }
    } else {
      return Left(AppExceptions.handle(
              caughtFailure: Failure(code: ResponseCode.NO_INTERNET_CONNECTION))
          .failure);
    }
  }

  static Future<Either<Failure, AllEventsResponseModel>> getSearchResults(
      {required num page,
      required FilterType filterType,
      required String searchKeyword}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await EventDataSource.getSearchResults(
            page: page, filterType: filterType, searchKeyword: searchKeyword);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        AllEventsResponseModel allEventsResponseModel =
            AllEventsResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (allEventsResponseModel.status!) {
            return Right(allEventsResponseModel);
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
          message: error.toString(),
        )).failure);
      }
    } else {
      return Left(AppExceptions.handle(
              caughtFailure: Failure(code: ResponseCode.NO_INTERNET_CONNECTION))
          .failure);
    }
  }

  static Future<Either<Failure, EventDetailsResponseModel>> getEventDetailsData(
      {required String eventId}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await EventDataSource.getEventDetailsData(eventId: eventId);
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        debugPrint(responseJson.toString());
        EventDetailsResponseModel eventDetailsResponseModel =
            EventDetailsResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (eventDetailsResponseModel.status!) {
            return Right(eventDetailsResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: eventDetailsResponseModel.responseData?.message ??
                  AppStrings.global_empty_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: eventDetailsResponseModel.responseData?.message ??
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

  static Future<Either<Failure, AthleteDetailsEventsResponseModel>>
      getEventListSeasonWiseForSpecificAthlete(
          {required String seasonId,
          required String athleteId,
          required String eventType}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response =
            await EventDataSource.getEventListSeasonWiseForSpecificAthlete(
                seasonId: seasonId, athleteId: athleteId, eventType: eventType);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        AthleteDetailsEventsResponseModel athleteDetailsEventsResponseModel =
            AthleteDetailsEventsResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (athleteDetailsEventsResponseModel.status!) {
            return Right(athleteDetailsEventsResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message:
                  athleteDetailsEventsResponseModel.responseData?.message ??
                      AppStrings.global_empty_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: athleteDetailsEventsResponseModel.responseData?.message ??
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

  static Future<Either<Failure, CommonResponseModel>> eventPurchase(
      {required RegisterEventRequestModel eventRegisterRequestModel,
      required CouponModules couponModule}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await EventDataSource.registerEvent(
          couponModule: couponModule,
            eventRegisterRequestModel: eventRegisterRequestModel);

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
        debugPrint('error: $error');
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

  static Future<Either<Failure, RegistrationListResponseModel>> getRegistrationList(
      {required String eventId}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await EventDataSource.getRegistrationList(eventId);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        RegistrationListResponseModel registrationListResponseModel =
        RegistrationListResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (registrationListResponseModel.status!) {
            return Right(registrationListResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
                  code: response.statusCode,
                  message: registrationListResponseModel.responseData?.message ??
                      AppStrings.global_empty_string,
                )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
                code: response.statusCode,
                message: registrationListResponseModel.responseData?.message ??
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

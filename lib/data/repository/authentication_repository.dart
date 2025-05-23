import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:rmnevents/imports/data.dart';
import 'package:rmnevents/services/shared_preferences_services/athlete_cached_data.dart';
import 'package:rmnevents/services/shared_preferences_services/pop_up_cached_data.dart';

import '../../di/di.dart';
import '../../imports/common.dart';
import '../../presentation/base/bloc/base_bloc.dart';
import '../../services/firebase_services/firebase_cloud_messaging.dart';
import '../../services/shared_preferences_services/history_cached_data.dart';
import '../../services/shared_preferences_services/staff_event_cached_data.dart';
import '../../services/shared_preferences_services/stripe_reader_cached_data.dart';
import '../models/request_models/reset_password_request_model.dart';

class AuthenticationRepository {
  static Future<Either<Failure, UserResponseModel>> signIn(
      {required AuthenticationSignUpSignInRequestModel
          signInSignUpRequestModel}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await AuthenticationDataSource.signInOrSignUp(
            isSignIn: true,
            authenticationSignUpSignInRequestModel: signInSignUpRequestModel);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        UserResponseModel signInResponseModel =
            UserResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (signInResponseModel.status!) {
            UserResponseModel updatedSignInResponseModel =
                await GlobalHandlers.updateResponseModel(
                    responseModel: signInResponseModel);

            return Right(updatedSignInResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: signInResponseModel.responseData?.message ??
                  AppStrings.global_empty_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: signInResponseModel.responseData?.message ??
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

  static Future<Either<Failure, AuthenticationSignUpResponseModel>> signUp(
      {required AuthenticationSignUpSignInRequestModel
          signInSignUpRequestModel}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await AuthenticationDataSource.signInOrSignUp(
            isSignIn: false,
            authenticationSignUpSignInRequestModel: signInSignUpRequestModel);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        AuthenticationSignUpResponseModel signUpResponseModel =
            AuthenticationSignUpResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (signUpResponseModel.status!) {
            return Right(signUpResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: signUpResponseModel.responseData?.message ??
                  AppStrings.global_empty_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: signUpResponseModel.responseData?.message ??
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

  static Future<Either<Failure, UserResponseModel>> signInSignUpSocially(
      {required AuthenticationSignUpSignInRequestModel
          signInSignUpRequestModel}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await AuthenticationDataSource.signInOrSignUpSocially(
            isSignIn: true,
            authenticationSignUpSignInRequestModel: signInSignUpRequestModel);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        UserResponseModel signInResponseModel =
            UserResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (signInResponseModel.status!) {
            UserResponseModel updatedSignInResponseModel =
                await GlobalHandlers.updateResponseModel(
                    responseModel: signInResponseModel);

            return Right(updatedSignInResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: signInResponseModel.responseData?.message ??
                  AppStrings.global_empty_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: signInResponseModel.responseData?.message ??
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

  static Future<Either<Failure, UserResponseModel>> verifyEmail(
      {required VerifyEmailRequestModel verifyEmailRequestModel}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await AuthenticationDataSource.verifyEmail(
            verifyEmailRequestModel: verifyEmailRequestModel);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        UserResponseModel verifyEmailResponseModel =
            UserResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (verifyEmailResponseModel.status!) {
            await RepositoryDependencies.userCachedData.removeUserDataCache();
            UserResponseModel updatedVerifyEmailResponseModel =
                await GlobalHandlers.updateResponseModel(
                    responseModel: verifyEmailResponseModel);
            return Right(updatedVerifyEmailResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: verifyEmailResponseModel.responseData?.message ??
                  AppStrings.global_empty_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: verifyEmailResponseModel.responseData?.message ??
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

  static Future<Either<Failure, AuthenticationSignUpResponseModel>> resendOtp(
      {required String encryptedEmail}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await AuthenticationDataSource.resendOtp(
            encryptedEmail: encryptedEmail);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        AuthenticationSignUpResponseModel resendOtpResponseModel =
            AuthenticationSignUpResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (resendOtpResponseModel.status!) {
            return Right(resendOtpResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: resendOtpResponseModel.responseData?.message ??
                  AppStrings.global_empty_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: resendOtpResponseModel.responseData?.message ??
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

  static Future<Either<Failure, CommonResponseModel>> logOut() async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await AuthenticationDataSource.logout();

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        CommonResponseModel logoutResponseModel =
            CommonResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (logoutResponseModel.status!) {
            String id =
                await RepositoryDependencies.userCachedData.getUserId() ?? '';
            await messaging.unsubscribeFromTopic(id);
            await RepositoryDependencies.userCachedData.removeUserDataCache();
            await instance<PopUpCachedData>()
                .removeSharedPreferencesGeneralFunction(PopKeyManager.popUPId);
            await instance<HistoryCachedData>()
                .removeSharedPreferencesGeneralFunction(
                    HistoryKeyManager.history);
            await instance<AthleteCachedData>()
                .removeSharedPreferencesGeneralFunction('athlete_list');
            await instance<AthleteCachedData>().removePreselectAthleteData();
            await instance<StripeReaderCachedData>()
                .removeSharedPreferencesGeneralFunction(
                    StripeReaderManager.stripeReader);
            await instance<StaffEventCachedData>()
                .removeSharedPreferencesGeneralFunction(
                    EventDataManager.eventData);
            isPopShown = false;

            return Right(logoutResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: logoutResponseModel.responseData?.message ??
                  AppStrings.global_empty_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: logoutResponseModel.responseData?.message ??
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

  static Future<Either<Failure, CommonResponseModel>> forgotPassword(
      {required String email}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await AuthenticationDataSource.forgotPassword(email: email);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        CommonResponseModel logoutResponseModel =
            CommonResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (logoutResponseModel.status!) {
            await RepositoryDependencies.userCachedData.removeUserDataCache();

            return Right(logoutResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: logoutResponseModel.responseData?.message ??
                  AppStrings.global_empty_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: logoutResponseModel.responseData?.message ??
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

  static Future<Either<Failure, CommonResponseModel>> resetPassword(
      {required ResetPasswordRequestModel resetPasswordRequest}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await AuthenticationDataSource.resetPassword(
            resetPasswordRequest: resetPasswordRequest);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        CommonResponseModel logoutResponseModel =
            CommonResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (logoutResponseModel.status!) {
            await RepositoryDependencies.userCachedData.removeUserDataCache();

            return Right(logoutResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: logoutResponseModel.responseData?.message ??
                  AppStrings.global_empty_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: logoutResponseModel.responseData?.message ??
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

  static Future<Either<Failure, CommonResponseModel>> changeInitialPassword(
      {required String newPassword}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await AuthenticationDataSource.changeInitialPassword(
            newPassword: newPassword);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        CommonResponseModel responseModel =
            CommonResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (responseModel.status!) {
            return Right(responseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: responseModel.responseData?.message ??
                  AppStrings.global_empty_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: responseModel.responseData?.message ??
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

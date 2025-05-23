import 'dart:convert';

import '../../device_variables.dart';
import '../../imports/common.dart';
import '../../imports/data.dart';
import '../../imports/services.dart';
import '../models/request_models/reset_password_request_model.dart';

class AuthenticationDataSource {
  static Future signInOrSignUp({required AuthenticationSignUpSignInRequestModel
  authenticationSignUpSignInRequestModel,
    required bool isSignIn}) async {
    final String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.signInSignUp}';

    Map<String, dynamic> data = isSignIn
        ? {
      "email": authenticationSignUpSignInRequestModel.email,
      "password": authenticationSignUpSignInRequestModel.password,
      "is_login": authenticationSignUpSignInRequestModel.isLogin,
      "device_type": authenticationSignUpSignInRequestModel.deviceType,
      "device_token": authenticationSignUpSignInRequestModel.deviceToken
    }
        : {
      "email": authenticationSignUpSignInRequestModel.email,
      "password": authenticationSignUpSignInRequestModel.password,
    };

    final response = await HttpFactoryServices.postMethod(
      url,
      data: data,
    );
    return response;
  }

  static Future signInOrSignUpSocially(
      {required AuthenticationSignUpSignInRequestModel
      authenticationSignUpSignInRequestModel,
        required bool isSignIn}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.signInSignUpSocially}';

    final data = jsonEncode({
      "first_name": authenticationSignUpSignInRequestModel.firstName,
      "last_name": authenticationSignUpSignInRequestModel.lastName,
      "email": authenticationSignUpSignInRequestModel.email,
      "profile": authenticationSignUpSignInRequestModel.profile,
      "type": authenticationSignUpSignInRequestModel.type,
      "social_id": authenticationSignUpSignInRequestModel.socialId,
      "is_email_verified":
      authenticationSignUpSignInRequestModel.isEmailVerified,
      "is_policy_accepted":
      authenticationSignUpSignInRequestModel.isPolicyAccepted
    });

    final response = await HttpFactoryServices.postMethod(
      url,
      data: data,
      header: await setHeader(false),
    );
    return response;
  }

  static Future verifyEmail(
      {required VerifyEmailRequestModel verifyEmailRequestModel}) async {
    final String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.verifyEmail}';

    final data = jsonEncode({
      "user_id": verifyEmailRequestModel.encryptedUserId,
      "otp": verifyEmailRequestModel.encryptedOtp,
      "device_type": DeviceVariables.deviceType,
      "device_token": await DeviceVariables.deviceToken()
    });
    final response = await HttpFactoryServices.postMethod(
      url,
      data: data,
      header: await setHeader(false),
    );
    return response;
  }

  static Future resendOtp({required String encryptedEmail}) async {
    final String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.resendOtp}';
    Map<String, dynamic> data = {"email": encryptedEmail};
    final response = await HttpFactoryServices.postMethod(
      url,
      data: data,
    );
    return response;
  }

  static Future logout() async {
    final String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.logout}';
    final response = await HttpFactoryServices.postMethod(url,
        header: await setHeader(true));
    return response;
  }

  static Future forgotPassword({required String email}) async {
    final String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.forgotPassword}';
    Map<String, dynamic> data = {
      "email": email,
    };
    final response = await HttpFactoryServices.postMethod(
      url,
      data: data,
    );
    return response;
  }

  static Future resetPassword(
      {required ResetPasswordRequestModel resetPasswordRequest}) async {
    final String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.resetPassword}';
    Map<String, dynamic> data = {
      "new_password": resetPasswordRequest.newPassword,
      "confirm_password": resetPasswordRequest.confirmPassword,
      "forgot_password_token": resetPasswordRequest.token
    };

    final response = await HttpFactoryServices.postMethod(
      url,
      data: data,
    );
    return response;
  }

  static Future changeInitialPassword({required String newPassword}) async {
    final String url = '${UrlPrefixes.baseUrl}${UrlSuffixes
        .changeInitialPassword}';

    final data = jsonEncode({
      "new_password": newPassword,
    });
    final response = await HttpFactoryServices.postMethod(
      url,
      data: data,
      header: await setHeader(true),
    );
    return response;
  }
}

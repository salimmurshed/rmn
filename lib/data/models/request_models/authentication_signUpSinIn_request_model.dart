import 'package:rmnevents/common/resources/app_strings.dart';

class AuthenticationSignUpSignInRequestModel {
  String email;
  String password;
  String isLogin;
  String deviceType;
  String deviceToken;
  String firstName;
  String lastName;
  String profile;
  String type;
  String socialId;
  bool isEmailVerified;
  bool isPolicyAccepted;

  AuthenticationSignUpSignInRequestModel({
    this.email = AppStrings.global_empty_string,
    this.password = AppStrings.global_empty_string,
    this.isLogin = AppStrings.global_empty_string,
    this.deviceType = AppStrings.global_empty_string,
    this.deviceToken = AppStrings.global_empty_string,
    this.firstName = AppStrings.global_empty_string,
    this.lastName = AppStrings.global_empty_string,
    this.profile = AppStrings.global_empty_string,
    this.type = AppStrings.global_empty_string,
    this.socialId = AppStrings.global_empty_string,
    this.isEmailVerified = false,
    this.isPolicyAccepted = false,
  });
}

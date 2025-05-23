import '../../../imports/common.dart';

class VerifyEmailRequestModel{
  final String encryptedOtp;
  final String encryptedUserId;
  const VerifyEmailRequestModel({this.encryptedOtp = AppStrings.global_empty_string, this.encryptedUserId = AppStrings.global_empty_string});
}
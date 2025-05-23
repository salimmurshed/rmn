import 'package:flutter/material.dart';

import '../../../imports/common.dart';

Text buildOtpResetTitle({ bool? isChangePassword, bool isOtp = true}) {
  return Text(
    isChangePassword != null?
    'Change Your Password':
    (isOtp
        ? AppStrings.authentication_otpVerification_title
        : AppStrings.authentication_resetPassword_title),
    style: AppTextStyles.landingTitle(),
  );
}

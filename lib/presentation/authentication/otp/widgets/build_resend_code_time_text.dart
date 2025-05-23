import 'package:flutter/material.dart';

import '../../../../imports/common.dart';

Container buildResendCodeTimeText() {
  return Container(
    margin: EdgeInsets.only(bottom: Dimensions.generalGap),
    child: Text(
      AppStrings
          .authentication_otpVerification_resendSuggestion_text,
      style: AppTextStyles.regularPrimary(
          color: AppColors.colorPrimaryNeutralText),
    ),
  );
}
import 'package:flutter/material.dart';

import '../../../imports/common.dart';

RichText buildSubtitle({required String email}) {
  return RichText(
    textAlign: TextAlign.left,
    text: TextSpan(
      children: [
        TextSpan(
          text: AppStrings.authentication_otpVerification_subTitle1,
          style: AppTextStyles.regularPrimary(
              color: AppColors.colorPrimaryNeutralText),
        ),
        TextSpan(
          text: email,
          style:
              AppTextStyles.regularPrimary(color: AppColors.colorPrimaryAccent, isBold: true),
        ),
        TextSpan(
          text: AppStrings.authentication_otpVerification_subTitle2,
          style: AppTextStyles.regularPrimary(
              color: AppColors.colorPrimaryNeutralText),
        ),
      ],
    ),
  );
}

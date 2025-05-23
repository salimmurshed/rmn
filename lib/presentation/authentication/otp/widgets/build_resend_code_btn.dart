import 'package:flutter/material.dart';

import '../../../../imports/common.dart';

Widget buildResendCodeBtn({required void Function() onPressed}) {
  return GestureDetector(
    onTap: onPressed,
    child: Text(
      AppStrings.authentication_otpVerification_resendCodeBtn,
      style: AppTextStyles.buttonTitle(color: AppColors.colorPrimaryAccent),
    ),
  );
}
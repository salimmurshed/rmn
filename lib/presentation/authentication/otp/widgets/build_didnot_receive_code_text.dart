import 'package:flutter/material.dart';

import '../../../../imports/common.dart';

Widget buildDidNotReceiveCodeText() {
  return Container(
    margin: EdgeInsets.only(top: Dimensions.generalGapSmall),
    child: Text(
      AppStrings.authentication_otpVerification_didNotReceiveCode_text,
      style:
          AppTextStyles.regularPrimary(color: AppColors.colorPrimaryNeutralText),
    ),
  );
}

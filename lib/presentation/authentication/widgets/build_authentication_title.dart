import 'package:flutter/material.dart';

import '../../../imports/common.dart';

Text buildAuthenticationTitle({required Authentication authentication}) {
  return Text(
    authentication == Authentication.signIn? AppStrings.authentication_signIn_title: AppStrings.authentication_signUp_title,
    style: AppTextStyles.extraLargeTitle(),
  );
}
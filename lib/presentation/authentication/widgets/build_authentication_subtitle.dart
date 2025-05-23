import 'package:flutter/material.dart';

import '../../../imports/common.dart';

Text buildAuthenticationSubtitle({required Authentication authentication}){
  return Text(
    authentication == Authentication.signIn? AppStrings.authentication_signIn_subTitle : AppStrings.authentication_signUp_subTitle,
    style: AppTextStyles.subtitle(),
  );
}
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../imports/common.dart';

Widget buildAuthenticationRoutingTextBtn({required Authentication authentication, required void Function() onTapGestureRecogniser}) {
  return Padding(
    padding:  EdgeInsets.only(bottom: Dimensions.buttonTextGap),
    child: Center(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: authentication == Authentication.signIn ?
              AppStrings.authentication_signIn_noAccount_text: Authentication.signUp == authentication ?
              AppStrings.authentication_signUp_alreadyHaveAccount_text:
              Authentication.signUpMask == authentication ?
              AppStrings.authentication_signUp_alreadyHaveAccount_text:
              AppStrings.authentication_resetPassword_rememberPassword_text,
              style: AppTextStyles.regularPrimary(),
            ),
            WidgetSpan(
              child: SizedBox(width: Dimensions.buttonTextGap), // Add space between the texts
            ),
            TextSpan(
              text: authentication == Authentication.signIn ? AppStrings.authentication_signIn_signUpBtn : AppStrings.authentication_signUp_signInBtn,
              style: AppTextStyles.regularPrimary(color: AppColors.colorPrimaryAccent),
              recognizer: TapGestureRecognizer()
                ..onTap = onTapGestureRecogniser,
            ),
          ],
        ),
      ),
    ),
  );
}
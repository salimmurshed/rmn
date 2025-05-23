import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../imports/common.dart';

Container buildAuthenticationCheckBox({required void Function(bool?)? onChanged, required bool isChecked}) {
  return Container(
    margin: EdgeInsets.only(top:Dimensions.authenticationCheckBoxGap),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildCustomCheckbox(isChecked: isChecked, onChanged: onChanged, isDisabled: false),
        Flexible(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text:  AppStrings.authentication_signUp_condition_preceeding_text,
                  style: AppTextStyles.normalPrimary(color: AppColors.colorPrimaryInverseText),
                  recognizer: TapGestureRecognizer()
                    ..onTap = (){
                      onChanged!(isChecked);
                    }
                ),
                TextSpan(
                    text:  AppStrings.authentication_signUp_termsAndConditionsBtn,
                    style: AppTextStyles.normalPrimary(color: AppColors.colorPrimaryAccent),
                    recognizer: TapGestureRecognizer()
                      ..onTap = (){
                        GlobalHandlers.urlLaunch(
                            UrlSuffixes.termsAndConditions);
                      }
                ),
                TextSpan(
                  text:  AppStrings.authentication_signUp_condition_joiner_text,
                  style: AppTextStyles.normalPrimary(color: AppColors.colorPrimaryInverseText),
                    recognizer: TapGestureRecognizer()
                      ..onTap = (){
                        onChanged!(isChecked);
                      }
                ),
                TextSpan(
                    text:  AppStrings.authentication_signUp_privacyPolicyBtn,
                    style: AppTextStyles.normalPrimary(color: AppColors.colorPrimaryAccent),
                    recognizer: TapGestureRecognizer()
                      ..onTap = (){
                        GlobalHandlers.urlLaunch(
                            UrlSuffixes.privacyPolicy);
                      }
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}


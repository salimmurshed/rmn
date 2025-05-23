import 'package:flutter/material.dart';

import '../../../imports/common.dart';

Widget buildCustomCheckboxesForPasswordField(
    {required bool isAtLeastEightCharChecked,
    required bool isAtLeastOneLowerCaseChecked,
    required bool isAtLeastOneUpperCaseChecked,
    required bool isAtLeastOneDigitChecked,
    required bool isAtLeastOneSpecialCharChecked,
    void Function(bool?)? onChanged}) {
  return Container(
    margin: EdgeInsets.only(top: Dimensions.textFormFieldVerticalGap),
    child: Column(
      children: [
        passwordChecker(
            isChecked: isAtLeastEightCharChecked,
            label: AppStrings.passwordValidation_minLengthCheck_text),
        passwordChecker(
            isChecked: isAtLeastOneLowerCaseChecked,
            label: AppStrings.passwordValidation_minLowerCaseCheck_text),
        passwordChecker(
            isChecked: isAtLeastOneUpperCaseChecked,
            label: AppStrings.passwordValidation_minUpperCaseCheck_text),
        passwordChecker(
            isChecked: isAtLeastOneDigitChecked,
            label: AppStrings.passwordValidation_minDigitCheck_text),
        passwordChecker(
            isChecked: isAtLeastOneSpecialCharChecked,
            label: AppStrings.passwordValidation_minSpecialCharCheck_text),
      ],
    ),
  );
}

Row passwordChecker({required bool isChecked, required String label}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildCustomCheckbox(
        isChecked: isChecked,
        onChanged: (value) {},
      ),
      Flexible(
        child: Text(
          label,
          style: AppTextStyles.normalPrimary(color: AppColors.colorPrimaryAccent),
        ),
      ),
    ],
  );
}

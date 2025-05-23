import 'package:flutter/material.dart';

import '../../../imports/common.dart';

Widget customGenderRadioButtons({required int currentlySelectedGroupValue, required void Function() onTapSelectMale, required void Function() onTapSelectFemale}){
  return buildCustomRadioButtonsInARow(
    isAsteriskPresent: true,
    label: AppStrings.textfield_selectGender_label,
    leftRadioButtonLabel: AppStrings.radio_genderMale,
    rightRadioButtonLabel: AppStrings.radio_genderFemale,
    onTapLeft:onTapSelectMale,
    onTapRight: onTapSelectFemale,
    currentlySelectedGroupValue: currentlySelectedGroupValue,
  );
}
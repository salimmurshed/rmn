import 'package:flutter/material.dart';

import '../../../imports/common.dart';

Row buildNameSection({
  required TextEditingController firstNameEditingController,
  required TextEditingController lastNameEditingController,
  required FocusNode firstNameFocusNode,
  required FocusNode lastNameFocusNode,
  String? firstNameError,
  String? lastNameError,
   String? Function(String?)? firstNameValidator,
   String? Function(String?)? lastNameValidator,
  required void Function(String) onChangedFirstName,
  required void Function(String) onChangedLastName,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: CustomTextFormFields(
          maxLength: 20,
          textInputType: TextInputType.name,
          errorText: firstNameError,
          textEditingController: firstNameEditingController,
          focusNode: firstNameFocusNode,
          label: AppStrings.textfield_addFirstName_label,
          hint: AppStrings.textfield_addFirstName_hint,
          isAsteriskPresent: true,
          onChanged: onChangedFirstName,
          validator: firstNameValidator,
        ),
      ),
      SizedBox(width: Dimensions.generalGap),
      Expanded(
        child: CustomTextFormFields(
            maxLength: 20,
            textInputType: TextInputType.name,
            textEditingController: lastNameEditingController,
            focusNode: lastNameFocusNode,
            label: AppStrings.textfield_addLastName_label,
            hint: AppStrings.textfield_addLastName_hint,
            isAsteriskPresent: true,
            errorText: lastNameError,
            onChanged: onChangedLastName,
            validator: lastNameValidator),
      ),
    ],
  );
}

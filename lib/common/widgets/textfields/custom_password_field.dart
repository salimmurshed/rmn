import 'package:flutter/material.dart';

import '../../../imports/common.dart';

CustomTextFormFields buildCustomPasswordField(
    {Authentication? authenticationType,
    void Function(String)? onChanged,
    void Function()? onTap,
    required bool isObscure,
    required TextEditingController textEditingController,
    required FocusNode focusNode,
    required String? Function(String?) validator,
    required String label,
    required String hint,
    required void Function() onTapToHideUnhide}) {
  // print('isObscure $isObscure');
  // print( [AutofillHints.password]);
  return CustomTextFormFields(
    textInputType: TextInputType.visiblePassword,
    suffixIcon: buildCustomPasswordHideUnHideBtn(
        onTap: onTapToHideUnhide, isObscure: isObscure),
    textEditingController: textEditingController,
    isObscure: isObscure,
    onEditingComplete: () {

    },
    autoFillHints: authenticationType == Authentication.signIn
        ? [AutofillHints.password]
        : null,
    focusNode: focusNode,
    label: label,
    hint: hint,
    onTap: onTap,
    onChanged: onChanged,
    validator: validator,
  );
}

import 'package:flutter/material.dart';

import '../../../imports/common.dart';

CustomTextFormFields buildCustomEmailField({
  required void Function(String) onChanged,
  bool isReadOnly = false,
  bool isDisabled = false,
  String? errorText,
  void Function()? onTap,
  Authentication? authenticationType,
  required TextEditingController emailAddressController,
  required FocusNode emailFocusNode,
  required String? Function(String?) validator,
}) {
  return CustomTextFormFields(
    textInputType: TextInputType.emailAddress,
    textEditingController: emailAddressController,
    focusNode: emailFocusNode,
    autoFillHints: authenticationType == Authentication.signIn
        ? [AutofillHints.email]
        : null,
    errorText: errorText,
    onTap: onTap,
    label: AppStrings.textfield_addEmail_label,
    hint: AppStrings.textfield_addEmail_hint,
    validator: validator,
    onChanged: onChanged,
    isDisabled: isDisabled,
    isReadOnly: isReadOnly,
  );
}

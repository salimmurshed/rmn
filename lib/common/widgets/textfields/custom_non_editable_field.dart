
import 'package:flutter/material.dart';

import '../../../imports/common.dart';

CustomTextFormFields buildCustomNonEditableField(
    {required TextEditingController textEditingController,
      required FocusNode focusNode}) {
  return CustomTextFormFields(
    textInputType: TextInputType.emailAddress,
    textEditingController: textEditingController,
    focusNode: focusNode,
    label: AppStrings.textfield_addEmail_label,
    hint: AppStrings.textfield_addEmail_hint,
    isAsteriskPresent: true,
    isReadOnly: true,
    isDisabled: true,
  );
}
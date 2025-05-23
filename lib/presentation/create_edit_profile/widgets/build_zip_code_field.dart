import 'package:flutter/cupertino.dart';

import '../../../imports/common.dart';

Widget buildZipCodeField(
    {String? Function(String?)? validator,
    required TextEditingController zipCodeEditingController,
    required void Function(String) onChanged,
    required String? zipError,
    required FocusNode zipCodeFocusNode}) {
  return CustomTextFormFields(
    textInputType: TextInputType.number,
    maxLength: 5,
    errorText: zipError,
    hintMaxLines: zipCodeEditingController.text.isNotEmpty ? 1 : 2,
    onChanged: onChanged,
    textEditingController: zipCodeEditingController,
    focusNode: zipCodeFocusNode,
    label: AppStrings.textfield_addZip_label,
    hint: AppStrings.textfield_addZip_hint,
    isAsteriskPresent: true,
    validator: validator,
  );
}

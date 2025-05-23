import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../imports/common.dart';

Container buildOtpFields({required List<FocusNode> pinFocusNodes,
  required List<TextEditingController> pinControllers,
  required bool isErrorTextHidden,
  required bool isFailure,
  required bool isFromChangeEmail,
  required String encryptedUserId,
  required int noOfPinFields, required BuildContext context}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: Dimensions.generalGap),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 0; i < noOfPinFields; i++)
              SizedBox(
                width: 40.w,
                child: CustomPinField(
                  pinControllers: pinControllers,
                  index: i,
                  isFailure: isFailure,
                  isFromChangeEmail: isFromChangeEmail,
                  encryptedUserId: encryptedUserId,
                  focusNodes: pinFocusNodes,
                ),
              ),
          ],
        ),
        if (!isErrorTextHidden)
          Padding(
            padding: EdgeInsets.all(8.r),
            child: Text(
              AppStrings.textfield_addPin_invalidInput_error,
              style: AppTextStyles.textFormFieldErrorStyle(),
            ),
          )
      ],
    ),
  );
}
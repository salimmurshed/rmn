import 'package:flutter/material.dart';

import '../../../imports/common.dart';

Widget buildCustomPasswordHideUnHideBtn({required void Function() onTap, required bool isObscure}) {
  return InkWell(
    splashColor: Colors.transparent,
    onTap: onTap,
    child: SizedBox(
      width: Dimensions.textFormFieldIconWidth,
      height: Dimensions.textFormFieldIconHeight,
      child: Icon(
        isObscure? Icons.visibility_off: Icons.visibility,
        color: AppColors.colorPrimaryNeutralText,
      ),
    ),
  );
}
import 'package:flutter/material.dart';

import '../../../imports/common.dart';

Center buildViewAllButton({required void Function()? onPressed}) {
  return Center(
    child: TextButton(
      onPressed: onPressed,
      child: Text(
        AppStrings.clientHome_viewAll_button_text,
        style: AppTextStyles.buttonTitle(color: AppColors.colorPrimaryAccent),
      ),
    ),
  );
}
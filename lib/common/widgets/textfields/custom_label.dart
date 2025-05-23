import 'package:flutter/material.dart';

import '../../../imports/common.dart';

buildCustomLabel({required String label, bool isAsteriskPresent = false}) =>
    Container(
      margin: EdgeInsets.only(
          left: Dimensions.textFormFieldLabelHorizontalGap,
          bottom: Dimensions.textFormFieldLabelVerticalGap,
          top: Dimensions.textFormFieldVerticalGap),
      child: isAsteriskPresent
          ? RichText(
              text: TextSpan(
                text: label,
                style: AppTextStyles.regularPrimary(),
                children: [
                  TextSpan(
                      text: ' *',
                      style: AppTextStyles.regularPrimary(
                          color: AppColors.colorPrimaryAccent)),
                ],
              ),
            )
          : Text(
              label,
              style: AppTextStyles.regularPrimary(),
            ),
    );

import 'package:flutter/material.dart';

import '../../../imports/common.dart';

Expanded customRadioButton(
    {bool isForRequest = false,
    required int value,
    required dynamic groupValue,
    required void Function() onTap,
    required String radioButtonLabel}) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppWidgetStyles.textFormFieldFillColor(),
          borderRadius: BorderRadius.circular(
            Dimensions.textFormFieldBorderRadius,
          ),
          border: Border.all(color: AppColors.colorTertiary),
        ),
        child: Row(
          children: [
            Radio(
              value: value,
              groupValue: groupValue,
              fillColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                    return AppColors.colorPrimaryAccent;
                  }),
              onChanged: (value) {
                onTap();
              },
            ),
            Text(
              radioButtonLabel,
              style: isForRequest
                  ? AppTextStyles.smallTitle()
                  : AppTextStyles.textFormFieldELabelStyle(),
            ),
          ],
        ),
      ),
    ),
  );
}

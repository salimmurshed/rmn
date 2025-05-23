import 'package:flutter/material.dart';

import '../../../imports/common.dart';

Widget buildCustomCheckBoxWithSingleText(
    {required void Function(bool?)? onChanged,
    required String singleText,
      bool noTopMargin = false,

    required bool isChecked}) {
  return GestureDetector(
    onTap: onChanged != null? () {
      onChanged(isChecked);
    }: null,
    child: Container(
      margin:noTopMargin ? null: EdgeInsets.only(top: Dimensions.screenVerticalSpacing),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildCustomCheckbox(isChecked: isChecked, onChanged: onChanged),
          Flexible(
            child: Text(singleText, style: AppTextStyles.subtitle()),
          ),
        ],
      ),
    ),
  );
}

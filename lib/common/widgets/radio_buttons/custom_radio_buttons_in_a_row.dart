import 'package:flutter/material.dart';

import '../../../imports/common.dart';

Column buildCustomRadioButtonsInARow(
    {required String label,
      required bool isAsteriskPresent,
      required String leftRadioButtonLabel,
      required String rightRadioButtonLabel,
      required int currentlySelectedGroupValue,
      required void Function() onTapLeft,
      required void Function() onTapRight}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildCustomLabel(label: label, isAsteriskPresent: isAsteriskPresent),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          customRadioButton(
            value: 0, groupValue: currentlySelectedGroupValue,
              onTap: onTapLeft, radioButtonLabel: leftRadioButtonLabel),
          SizedBox(
            width: Dimensions.generalGap,
          ),
          customRadioButton(
              value: 1, groupValue: currentlySelectedGroupValue,
              onTap: onTapRight, radioButtonLabel: rightRadioButtonLabel)
        ],
      ),
    ],
  );
}


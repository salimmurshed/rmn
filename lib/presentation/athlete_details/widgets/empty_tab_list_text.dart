import 'package:flutter/material.dart';

import '../../../imports/common.dart';

Column emptyTabListText({required String text}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        height: Dimensions.getScreenHeight() * 0.18,
      ),
      Center(
          child: Text(
            text,
            style: AppTextStyles.smallTitle(),
          ))
    ],
  );
}
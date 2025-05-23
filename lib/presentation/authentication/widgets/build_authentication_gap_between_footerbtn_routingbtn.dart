import 'package:flutter/material.dart';

import '../../../imports/common.dart';

SizedBox buildAuthenticationGapBetweenFooterBtnAndRoutingBtn(
    {required BuildContext context,
    required Authentication authentication,
    }) {
  return SizedBox(
      height: authentication == Authentication.signIn
          ? Dimensions.getScreenHeight() * 0.05
              : authentication == Authentication.signUp
                  ? Dimensions.getScreenHeight() * 0.01
                  : Dimensions.getScreenHeight() * 0.2);
}

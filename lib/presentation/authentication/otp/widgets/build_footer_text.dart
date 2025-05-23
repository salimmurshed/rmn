
import 'package:flutter/cupertino.dart';

import '../../../../imports/common.dart';

Container buildFooterText() {
  return Container(
    margin: EdgeInsets.only(top: Dimensions.generalGap),
    child: Text(
      AppStrings
          .authentication_otpVerification_checkSpamFolder_text,
      textAlign: TextAlign.center,
      style: AppTextStyles.subtitle(),
    ),
  );
}
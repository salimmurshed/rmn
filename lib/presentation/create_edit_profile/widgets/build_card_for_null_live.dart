import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';

Widget buildCardForNullLive() {
  return Container(
    height: 170.h,
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.colorSecondary,
      borderRadius: BorderRadius.circular(Dimensions.generalRadius),
    ),
    child: Center(
      child: Text(
        AppStrings.clientHome_nullLiveCard_text,
        style: AppTextStyles.smallTitle(),
      ),
    ),
  );
}

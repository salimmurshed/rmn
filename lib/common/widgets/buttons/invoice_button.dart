import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';

Widget buildInvoiceButton(
    {required BuildContext context,
    required bool isLoading,
      bool isActionBar = true,
      required void Function() onTap,
 }) {
  return InkWell(
    splashColor: Colors.transparent,
   onTap: onTap,
    child: buildInvoiceButtonBody(isLoading, isActionBar),
  );
}

Container buildInvoiceButtonBody(bool isLoading, bool isActionBar) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          Dimensions.generalSmallRadius,
        ),
        color: AppColors.colorSecondaryAccent),
    padding: EdgeInsets.all(10.r),
    child: Center(
      child: isLoading
          ? SizedBox(
        height: isActionBar? 15.h: 19.h,
        width: isActionBar?16.w: 21.w,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.colorPrimaryNeutralText),
        ),
      )
          : SizedBox(
        height: isActionBar? 15.h: 19.h,
        width: isActionBar?16.w: 21.w,
            child: SvgPicture.asset(
            fit: BoxFit.cover, AppAssets.icDownloadInvoice),
          ),
    ),
  );
}
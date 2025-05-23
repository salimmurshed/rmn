import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';

void buildCustomToast({bool? isFailure, required String msg}) {
  switch (isFailure) {
    case true:
      buildToastBody(
          msg: msg,
          color: AppColors.colorError,
          imageUrl: AppAssets.icToastFailure);
      break;
    case false:
      buildToastBody(
          msg: msg,
          color: AppColors.colorSuccess,
          imageUrl: AppAssets.icToastSuccess);
      break;
    default:
      buildToastBody(msg: msg, color: AppColors.colorWarning, imageUrl: null);
  }
}

CancelFunc buildToastBody(
    {required String msg, required Color? color, required String? imageUrl}) {
  return BotToast.showCustomNotification(
    duration: const Duration(seconds: 5),
    toastBuilder: (cancelFunc) {
      return Padding(
        padding: EdgeInsets.only(top: Dimensions.screenVerticalSpacing),
        child: Material(
          elevation: Dimensions.toastElevation,
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.colorSecondary,
              borderRadius: BorderRadius.circular(Dimensions.generalRadius),
            ),
            child: IntrinsicWidth(
              child: ListTile(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: Dimensions.textFormFieldIconHeight,
                        width: Dimensions.textFormFieldIconWidth,
                        child: imageUrl != null
                            ? SvgPicture.asset(
                                imageUrl,
                                fit: BoxFit.contain,
                              )
                            : Container()),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(msg,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.toastTextStyle(color: color)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

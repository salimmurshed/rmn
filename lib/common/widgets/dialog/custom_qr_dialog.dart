import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';

Dialog customQRDialog(Uint8List? image, String status) {
  return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Container(
        width: 200.w,
        decoration: BoxDecoration(
          color: AppColors.colorTertiary,
          borderRadius: BorderRadius.circular(10.r),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 25.w,
        ),
        // height: 200.h,
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.r),
                  child: Image.memory(
                    height: 160.h,
                    image,
                    fit: BoxFit.cover,
                    width: 170.w,
                  ),
                ),
              SizedBox(
                height: 2.h,
              ),
              if (status != AppStrings.myPurchases_qrCode_noScanDetails_text) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check,
                      color: AppColors.colorPrimaryAccent,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      status,
                      style: AppTextStyles.subtitle(isOutFit: false),
                    )
                  ],
                )
              ]
              else ...[
                Text(
                  status,
                  style: AppTextStyles.subtitle(isOutFit: false,
                      color: AppColors.colorPrimaryInverseText),
                )
              ],
              SizedBox(height: 5.h)
            ],
          ),
        ),
        // ),
      ));
}

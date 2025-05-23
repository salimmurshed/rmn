import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';

Stack buildQrCode({required String qrCodeStatus, required qrCode}) {
  print('qrCodeStatus: $qrCodeStatus');
  return Stack(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: SizedBox(
          width: 80.w,
          child: Image.memory(
            GlobalHandlers.convertQRCodeToImage(qrCode: qrCode),
            fit: BoxFit.cover,
          ),
        ),
      ),
      if (qrCodeStatus != AppStrings.myPurchases_qrCode_noScanDetails_text)
        Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: qrCodeStatus ==
                      AppStrings.myPurchases_qrCode_scanDetailsConfirmed_text
                      ? AppColors.colorSuccessOpaque
                      : AppColors.colorRedOpaque),
              width: 80.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check,
                    color: AppColors.colorPrimaryInverse,
                    size: 30.h,
                  ),
                  Text(
                    qrCodeStatus,
                    style: AppTextStyles.subtitle(isOutFit: false),
                  )
                ],
              ),
            )),
    ],
  );
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';

class PopUpScanTitleSpace extends StatelessWidget {
  const PopUpScanTitleSpace({
    super.key,
    required this.scanType,
    required this.title,
  });

  final ScanType scanType;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.colorSecondary,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildScanTypeIndicator(),
          SizedBox(height: 10.h),
          buildTitle(),
        ],
      ),
    );
  }

  Row buildTitle() {
    return Row(
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.largeTitle(),
            ),
          ),
        ),
      ],
    );
  }

  Container buildScanTypeIndicator() {
    return Container(
      decoration: BoxDecoration(
        color: scanType == ScanType.purchase
            ? AppColors.colorGreenAccent
            : AppColors.colorPrimaryAccent,
        borderRadius: BorderRadius.circular(100.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.h),
      child: Material(
        color: Colors.transparent,
        child: Text(
          scanType == ScanType.purchase
              ? AppStrings.qrCode_popUp_product_status
              : AppStrings.qrCode_popUp_registration_status,
          style: AppTextStyles.subtitle(isOutFit: false),
        ),
      ),
    );
  }
}
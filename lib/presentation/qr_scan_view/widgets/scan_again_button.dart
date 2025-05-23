import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';
class ScanAgainButton extends StatelessWidget {
  const ScanAgainButton({
    super.key,
    required this.scanAgain,
  });

  final void Function() scanAgain;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: scanAgain,
      child: Container(
        margin: EdgeInsets.only(top: 20.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(AppAssets.icRefresh),
            SizedBox(width: 10.w),
            Material(
              color: Colors.transparent,
              child: Text(
                AppStrings.btn_scanAgain,
                style: AppTextStyles.smallTitle(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
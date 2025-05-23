import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';

class StackedDeclineButton extends StatelessWidget {
  const StackedDeclineButton({
    super.key,
    required this.decline,
  });

  final void Function() decline;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5.r),
        child: InkWell(
            onTap: decline,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.r),
              child: SizedBox(
                width: Dimensions.getScreenWidth(),
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      left: 0,
                      bottom: -2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.r),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            color: AppColors.colorSecondaryAccent,
                          ),
                          width: Dimensions.getScreenWidth(),
                          height: 10.h,
                        ),
                      ),
                    ),
                    Positioned(
                        top: 0,
                        right: 0,
                        left: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.r),
                          child: Container(
                            color: AppColors.colorPrimaryInverse,
                            height: 38.h,
                            child: Center(
                              child: Text(
                                AppStrings.btn_decline,
                                style: AppTextStyles.buttonTitle(
                                    color: AppColors.colorSecondaryAccent),
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

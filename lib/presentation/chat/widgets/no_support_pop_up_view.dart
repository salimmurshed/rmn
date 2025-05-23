import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rmnevents/imports/common.dart';

import '../../../common/resources/app_colors.dart';
import '../../../common/resources/app_text_styles.dart';

class NoSupportAgentAvailabel extends StatelessWidget {
  final VoidCallback onDismiss;

  const NoSupportAgentAvailabel({
    super.key,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 10.0),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.colorSecondary,
              border:
                  Border.all(color: AppColors.colorPrimaryInverse, width: 1.0),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppAssets.icCustomerCare,
                        height: 65.h, width: 77.w),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'No Support Agents Currently Available',
                            style: AppTextStyles.smallTitle(
                                isBold: false, isOutFit: false),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'No one is currently available for chat support. RMN Events will respond once support staff are back online. Thank you for your patience.',
                            style: AppTextStyles.smallTitle(
                                isBold: false,
                                isOutFit: true,
                                fontSize: AppFontSizes.normal,
                                color: AppColors.colorPrimaryNeutralText),
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: (){
              onDismiss();
            },
            child:  Container(
              height: 32.h,
              width: 32.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                Border.all(color: AppColors.colorSecondary, width: 2.w),
                color: AppColors.colorPrimaryInverse,
              ),
              child: Center(
                child: SvgPicture.asset(AppAssets.icCross, height: 18.h,width: 18.w),
              ),
            ),
          ),
        )
      ],
    );
  }
}

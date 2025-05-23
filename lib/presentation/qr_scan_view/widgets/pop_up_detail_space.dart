import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';

class PopUpDetailSpace extends StatelessWidget {
  const PopUpDetailSpace({
    super.key,
    required this.scanType,
    required this.imageUrl,
    required this.productTitle,
    required this.metric1,
    required this.metric2,
    required this.metric3,
  });

  final ScanType scanType;
  final String imageUrl;
  final String productTitle;
  final String metric1, metric2, metric3;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildInfoTitle(),
        SizedBox(height: 12.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildPopUpImage(),
            SizedBox(width: 10.w),
            Material(
              color: Colors.transparent,
              child: SizedBox(
                height: 70.h,
                width: Dimensions.getScreenWidth() * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildProductTitle(),
                    SizedBox(width: 10.h,),
                    if (metric1.isNotEmpty)
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: metric1,
                              style: AppTextStyles.normalNeutral(
                                  fontWeight: FontWeight.w500),
                            ),
                            if (metric2.isNotEmpty) ...[
                              TextSpan(
                                text: ' | ',
                                style: AppTextStyles.normalNeutral(),
                              ),
                              TextSpan(
                                text: metric2,
                                style: AppTextStyles.normalNeutral(
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                            if (metric3.isNotEmpty) ...[
                              TextSpan(
                                text: ' | ',
                                style: AppTextStyles.normalNeutral(),
                              ),
                              TextSpan(
                                text: metric3,
                                style: AppTextStyles.normalNeutral(
                                    fontWeight: FontWeight.w500),
                              ),
                            ]
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildProductTitle() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        productTitle,
        maxLines: 2,
        style: AppTextStyles.subtitle(isBold: true),
      ),
    );
  }

  ClipRRect buildPopUpImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        color: AppColors.colorPrimary,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          height: 70.h,
          width: 70.w,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }

  Material buildInfoTitle() {
    return Material(
      color: Colors.transparent,
      child: Text(
        scanType == ScanType.purchase
            ? AppStrings.qrCode_popUp_product_title
            : AppStrings.qrCode_popUp_registration_title,
        style: AppTextStyles.regularPrimary(isOutFit: false),
      ),
    );
  }
}

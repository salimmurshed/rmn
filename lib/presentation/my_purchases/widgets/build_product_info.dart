import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';

Widget buildProductInfo(
    {required BuildContext context,
    required String totalCount,
    required String productTitle,
    required ProductCardType productCardType,
    required num totalAmount,
    required String purchasedDate}) {
  return Expanded(
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  productTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.subtitle(isOutFit: true, isBold: true),
                ),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (totalCount.isNotEmpty) ...[
                SvgPicture.asset(AppAssets.icProductPurchased),
                Container(
                  margin: EdgeInsets.only(left: 4.w),
                  child: Text(
                    totalCount,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.normalNeutral(isSquada: true),
                  ),
                )
              ],
              Container(
                margin: EdgeInsets.only(left: totalCount.isNotEmpty ? 10.w : 0),
                child: SvgPicture.asset(
                  AppAssets.icCart,
                  colorFilter: ColorFilter.mode(
                      AppColors.colorPrimaryAccent, BlendMode.srcIn),
                  height: 12.h,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 4.w, right: 12.w),
                child: Text(
                  purchasedDate,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.normalNeutral(isSquada: true),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8.h,
          ),
        ],
      ),
    ),
  );
  //   Expanded(
  //   flex: 4,
  //   child: SizedBox(
  //     height: 70.h,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Container(
  //           margin: EdgeInsets.symmetric(
  //             horizontal: 5.w,
  //           ),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             crossAxisAlignment: CrossAxisAlignment.end,
  //             children: [
  //               Expanded(
  //                 child: Text(
  //                   productTitle,
  //                   maxLines: 1,
  //                   overflow: TextOverflow.ellipsis,
  //                   style: AppTextStyles.subtitle(
  //                       isOutFit: productCardType == ProductCardType.eventProds ? true : false),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Container(
  //           margin: EdgeInsets.only(
  //             right: 5.w,
  //           ),
  //           child: Row(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               if (totalCount.isNotEmpty) ...[
  //                 Container(
  //                     margin: EdgeInsets.only(
  //                       left: 4.w,
  //                     ),
  //                     child: SvgPicture.asset(AppAssets.icProductPurchased)),
  //                 Container(
  //                   margin: EdgeInsets.only(left: 4.w),
  //                   child: Text(
  //                     totalCount,
  //                     overflow: TextOverflow.ellipsis,
  //                     style: AppTextStyles.normalNeutral(isSquada: true),
  //                   ),
  //                 ),
  //               ],
  //               Container(
  //                 margin:
  //                     EdgeInsets.only(left: totalCount.isNotEmpty ?
  //                     10.w:4.w),
  //                 child: SvgPicture.asset(
  //                   AppAssets.icCart,
  //                   colorFilter: ColorFilter.mode(
  //                       AppColors.colorPrimaryAccent, BlendMode.srcIn),
  //                   height: 12.h,
  //                 ),
  //               ),
  //               Container(
  //                 margin: EdgeInsets.only(left: 4.w, right: 12.w),
  //                 child: Text(
  //                   purchasedDate,
  //                   overflow: TextOverflow.ellipsis,
  //                   style: AppTextStyles.normalNeutral(isSquada: true),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         if(productCardType != ProductCardType.eventProds)
  //         ...[const Spacer(),
  //         SizedBox(
  //           width: Dimensions.getScreenWidth(),
  //           child: Row(
  //             children: [
  //               const Spacer(
  //                 flex: 4,
  //               ),
  //               buildProductPrice(totalAmount: totalAmount)
  //             ],
  //           ),
  //         )]
  //       ],
  //     ),
  //   ),
  // );
}

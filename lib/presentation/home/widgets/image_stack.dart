import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/common/resources/app_assets.dart';

class ImageStack extends StatelessWidget {
  ImageStack(
      {super.key,
      required this.imageUrl,
      this.isLocal = true,
      required this.address,
      required this.date,
      required this.title});

  bool isLocal;
  final String imageUrl;
  final String address;
  final String date;
  final String title;

  @override
  Widget build(BuildContext context) {
    return isLocal
        ? Image.asset(
            imageUrl,
            fit: BoxFit.cover,
            height: 150.h,
            width: double.infinity,

            // CachedNetworkImage(
            //   imageUrl: imageUrl,
            //   fit: BoxFit.cover,
            //   height: 190.h,
            //   width: double.infinity,
            // ),
          )
        : Stack(
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                height: 190.h,
                width: double.infinity,
              ),
              Image.asset(AppAssets.imgRmnLogoStack,
                  height: 190.h, width: double.infinity),
            ],
          );
    //   SizedBox(
    //   height: 190.h,
    //   child: Stack(
    //     children: [
    //       Positioned(
    //         top: 0,
    //         left: 0,
    //         right: 0,
    //         child:
    //
    //         CachedNetworkImage(
    //           imageUrl: imageUrl,
    //           fit: BoxFit.cover,
    //           height: 190.h,
    //           width: double.infinity,
    //         ),
    //       ),
    //       // Later
    //       // Align(
    //       //   alignment: Alignment.center,
    //       //   child: IntrinsicHeight(
    //       //     child: Container(
    //       //       margin: EdgeInsets.symmetric(horizontal: 15.w),
    //       //       padding: EdgeInsets.symmetric(
    //       //           horizontal: 15.w, vertical: 8.h),
    //       //       width: Dimensions.getScreenWidth(),
    //       //       decoration: BoxDecoration(
    //       //         color: AppColors.colorTertiary,
    //       //         borderRadius: BorderRadius.circular(10.r),
    //       //       ),
    //       //       child: Column(
    //       //         crossAxisAlignment: CrossAxisAlignment.start,
    //       //         mainAxisAlignment: MainAxisAlignment.center,
    //       //         children: [
    //       //           Flexible(
    //       //             child: Text(
    //       //               '$address  |  $date',
    //       //               maxLines: 2,
    //       //               overflow: TextOverflow.ellipsis,
    //       //               style: AppTextStyles.regularPrimary(
    //       //                   isOutFit: false,
    //       //                   color: AppColors.colorPrimaryAccent),
    //       //             ),
    //       //           ),
    //       //           Flexible(
    //       //             child: Text(
    //       //               title,
    //       //               maxLines: 2,
    //       //               overflow: TextOverflow.ellipsis,
    //       //               style: AppTextStyles.largeTitle(),
    //       //             ),
    //       //           ),
    //       //         ],
    //       //       ),
    //       //     ),
    //       //   ),
    //       // ),
    //     ],
    //   ),
    // );
  }
}

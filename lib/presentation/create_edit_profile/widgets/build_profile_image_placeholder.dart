import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rmnevents/data/models/response_models/my_purchased_season_passes.dart';

import '../../../imports/common.dart';
import '../../../root_app.dart';

Widget buildProfileImagePlaceHolder(
    {required File? file,
    required String networkImageUrl,
    required String label,
    required bool isEditAthlete,
    required Memberships? membership,
    void Function()? onTap}) {
  print('networkImageUrl: $networkImageUrl');
  return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.r),
        child: Container(
          color: Colors.black12,
          height: 140.h,
          width: isTablet ? 110.w : 150.w,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5.r),
                child: file == null
                    ? (networkImageUrl.isNotEmpty && networkImageUrl.contains('https')
                        ? CachedNetworkImage(
                            fit: BoxFit.cover,
                            height: 130.h,
                            width: isTablet ? 100.w : 140.w,
                            imageUrl: networkImageUrl):
                networkImageUrl.isNotEmpty && !networkImageUrl.contains('https') ?
                    Image.file(File(networkImageUrl),
                      fit: BoxFit.cover,
                      height: 130.h,
                      width: isTablet ? 100.w : 140.w,
                    )

                        : SvgPicture.asset(
                            AppAssets.icProfileAvatar,
                            fit: BoxFit.cover,
                            height: 130.h,
                            width: isTablet ? 100.w : 140.w,
                          ))
                    : Image(
                        image: FileImage(file),
                        fit: BoxFit.cover,
                        height: 130.h,
                        width: isTablet ? 100.w : 140.w,
                      ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: SvgPicture.asset(
                  AppAssets.icCamera,
                  height: 25.h,
                  width: 30.w,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      )
      // SizedBox(
      //   height: 150.h,
      //   width: 120.w,
      //   child: Stack(
      //     fit: StackFit.loose,
      //     children: [
      //       ClipRRect(
      //         borderRadius: BorderRadius.circular(Dimensions.generalRadius),
      //         child: buildImagePlaceHolder(
      //             networkImageUrl: networkImageUrl, file: file),
      //       ),
      //       // if (label.isNotEmpty && isEditAthlete)
      //       //   Container(
      //       //
      //       //     padding: EdgeInsets.symmetric(
      //       //         horizontal: 6.w, vertical: 2.h),
      //       //     decoration: BoxDecoration(
      //       //       color: AppColors.colorGreenOpaque,
      //       //       borderRadius: BorderRadius.only(
      //       //          topLeft: Radius.circular(Dimensions.generalRadius),
      //       //           bottomRight: Radius.circular(Dimensions.generalRadius)),
      //       //     ),
      //       //     child: Row(
      //       //       mainAxisSize: MainAxisSize.min,
      //       //       crossAxisAlignment: CrossAxisAlignment.center,
      //       //       mainAxisAlignment: MainAxisAlignment.start,
      //       //       children: [
      //       //         svgPlaceHolder(
      //       //           sizeType: SizeType.medium,
      //       //           typeOfMetric: TypeOfMetric.none,
      //       //           isMetric: false,
      //       //           imageUrl: label == TypeOfAccess.owner.name
      //       //               ? AppAssets.icOwner
      //       //               : label == TypeOfAccess.view.name
      //       //               ? AppAssets.icViewer
      //       //               : AppAssets.icCoach,
      //       //         ),
      //       //         SizedBox(
      //       //           width: 5.w,
      //       //         ),
      //       //         Text(StringManipulation.capitalizeTheInitial(value: label),
      //       //           style: AppTextStyles.componentLabels(),
      //       //         ),
      //       //       ],
      //       //     ),
      //       //   ),
      //       //   if(isEditAthlete)...[
      //       //     Positioned(
      //       //       left: 0,
      //       //         bottom: 10.h,
      //       //         child: ClipRRect(
      //       //             borderRadius: BorderRadius.only(
      //       //                 bottomLeft: Radius.circular(Dimensions.generalRadius),
      //       //                 topRight: Radius.circular(Dimensions.generalRadius)),
      //       //             child: memberShip(sizeType: SizeType.medium, membership: membership))),
      //       //   ],
      //
      //       Align(
      //         alignment: Alignment.bottomRight,
      //         child: GestureDetector(
      //           onTap: onTap,
      //           child: SvgPicture.asset(
      //             AppAssets.icCamera,
      //             height: 25.h,
      //             width: 30.w,
      //             fit: BoxFit.cover,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      );
}

Widget buildImagePlaceHolder(
    {required String networkImageUrl, required File? file}) {
  if (file == null) {
    if (networkImageUrl.isEmpty || !networkImageUrl.contains('https')) {
      return SvgPicture.asset(
        fit: BoxFit.cover,
        AppAssets.icProfileAvatar,
        height: 140.h,
        width: 80.w,
      );
    } else {
      return CachedNetworkImage(
          imageUrl: networkImageUrl,
          fit: BoxFit.contain,
          height: 145.h,
          width: 155.w);
    }
  } else {
    return Image(
        image: FileImage(file), fit: BoxFit.cover, height: 145.h, width: 155.w);
  }
}

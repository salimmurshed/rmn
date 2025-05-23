import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../data/models/response_models/season_passes_response_model.dart';
import '../../../../imports/common.dart';
import '../../../../imports/data.dart';

Widget buildCustomImagePlaceHolder(
    {required SizeType sizeType,
    required String imageUrl,
    //required String athleteId,
    //required List<Team> teams,
    required List<SeasonPass> seasons,
    required String userStatus,
    required void Function()? onTapImage,
    Memberships? membership}) {
  return sizeType == SizeType.small
      ? buildPicture(
          onTapImage: onTapImage,
         // athleteId: athleteId,
          //teams: teams,
          seasons: seasons,
          sizeType: sizeType,
          imageUrl: imageUrl,
          userStatus: userStatus,
          membership: membership)
      : Expanded(
          child: buildPicture(
             // athleteId: athleteId,
              onTapImage: onTapImage,
             // teams: teams,
              seasons: seasons,
              sizeType: sizeType,
              imageUrl: imageUrl,
              userStatus: userStatus,
              membership: membership),
        );
}

ClipRRect buildPicture(
    {
      //required String athleteId,
    //required List<Team> teams,
    required List<SeasonPass> seasons,
    required SizeType sizeType,
    required String imageUrl,
    required String userStatus,
      required void Function()? onTapImage,
    Memberships? membership}) {


  return ClipRRect(
    borderRadius: BorderRadius.circular(Dimensions.generalRadius),
    child: Stack(
      children: [
        GestureDetector(
          onTap:onTapImage,
          child: pictureContainer(
            sizeType: sizeType,
            child: imageUrl.isEmpty
                ? SvgPicture.asset(
                    AppAssets.icProfileAvatar,
                    fit: BoxFit.cover,
                    // height: 30,
                  )
                : CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
              errorWidget: (_, __, ___) => SvgPicture.asset(
                    AppAssets.icProfileAvatar,
                    fit: BoxFit.cover,
                  ),
                    placeholder: (context, url) => SvgPicture.asset(
                      AppAssets.icProfileAvatar,
                      fit: BoxFit.cover,
                    ),
                    // height: 30,
                  ),
          ),
        ),
        if (userStatus.isNotEmpty) ...[
          if (sizeType != SizeType.small) ...[
            Align(
                alignment: Alignment.topLeft,
                child: assessType(sizeType: sizeType, userStatus: userStatus)),
          ] else ...[
            if (StringManipulation.capitalizeTheInitial(value: userStatus) ==
                AppStrings.global_athleteAccessType_owner_title) ...[
              Align(
                  alignment: Alignment.topLeft,
                  child:
                      assessType(sizeType: sizeType, userStatus: userStatus)),
            ]
          ]
        ],
        if (sizeType != SizeType.small) ...[
          Positioned(
              left: 0,
              bottom: 0,
              child: memberShip(sizeType: sizeType, membership: membership)),
        ] else ...[
          if (membership == null) ...[
            Positioned(
                left: 0,
                bottom: 0,
                child: memberShip(sizeType: sizeType, membership: membership)),
          ]
        ]
      ],
    ),
  );
}

Widget pictureContainer({required SizeType sizeType, required Widget child}) =>
    Container(
        margin: EdgeInsets.only(
            right: 5.w),
        height: sizeType == SizeType.large
            ? 250.h
            : sizeType == SizeType.medium
                ? 160.h
                : 120.h,
        width: sizeType == SizeType.large
            ? 200.w
            : sizeType == SizeType.medium
                ? 170.h
                : 100.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.generalRadius),
            color: AppColors.colorPrimary),
        child: child);

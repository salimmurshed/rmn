import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';

Container buildAuthenticationSocialBtns({
  required void Function() googleOnTap,
  required void Function() faceBookOnTap,
  required void Function() appleOnTap,
}) {
  return Container(
    margin: EdgeInsets.only(bottom: Dimensions.screenVerticalGap),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildSocialBtn(onTap: googleOnTap, imageUrl: AppAssets.icSocialsGoogle),
        SizedBox(
          width: Dimensions.screenHorizontalGap,
        ),
        buildSocialBtn(onTap: faceBookOnTap, imageUrl: AppAssets.icSocialsFacebook),
       if(Platform.isIOS)... [SizedBox(
          width: Dimensions.screenHorizontalGap,
        ),
        buildSocialBtn(onTap: appleOnTap, imageUrl: AppAssets.icSocialsApple),]
      ],
    ),
  );
}

InkWell buildSocialBtn({required void Function() onTap, required String imageUrl}) => InkWell(onTap: onTap,child: SvgPicture.asset(imageUrl));
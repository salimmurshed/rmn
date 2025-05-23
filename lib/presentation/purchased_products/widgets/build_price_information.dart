import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rmnevents/root_app.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';
String appBarTitle = AppStrings.global_empty_string;
Widget buildPriceInformation({
  String title = AppStrings.global_empty_string,
  String status = AppStrings.global_empty_string,
  required List<Registrations> registrations,
  Uint8List? image,
  required num price,
  required ProductCardType productCardType,
  // required bool isMyProductDetail,
  // bool isEventRegistration = false,
  // bool isSeasonPass = true
}) {

  appBarTitle = title;
  return Container(
    //margin: EdgeInsets.only(right: 2.w),
    // height: productCardType == ProductCardType.eventRegs ? 82.h :
    // (productCardType == ProductCardType.eventProds ? 70.h : null),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 5.h,
        ),
        GestureDetector(
          onTap: () async {
            if (productCardType == ProductCardType.eventRegs) {
              Navigator.pushNamed(navigatorKey.currentState!.context,
                  AppRouteNames.routeQRCodes,
                  arguments: registrations);
            } else {
              await showDialog(
                  context: navigatorKey.currentState!.context,
                  builder: (_) => customQRDialog(image, status));
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.r),
            child: SizedBox(
              height: 40.h,
              width: 40.w,
              child: SvgPicture.asset(
                AppAssets.icQRWhiteBg,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const Spacer(
          flex: 2,
        ),
        Text('${StringManipulation.addADollarSign(price: price)}',
            style: AppTextStyles.subtitle(isOutFit: false)),
        SizedBox(
          height: 5.h,
        ),
      ],
    ),
  );
}

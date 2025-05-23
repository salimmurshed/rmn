import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../root_app.dart';

class Dimensions {
  //Every screen
  static double screenHorizontalGap = 10.w;
  static double screenVerticalGap = 10.h;
  static double screenVerticalSpacing = 28.h;
  static double screenToastSpacing = 43.h;

  static double dividerTitleGap = 5.h;
  static double titleSubtitleGap = 10.h;
  static double subtitleBodyGap = 20.h;

  //Appbar
  static double appBarHeight = 60.h;
  static double appBarHeightLarge = 150.h;

  static double appBarToolHorizontalGap = 15.w;
  static double appBarToolVerticalGap = 10.h;
  static double appBarToolVerticalGapSmall = 5.h;
  static double appBarToolHeight = 48.h;
  static double appBarToolHeightLarge = 120.h;
  static double appBarToolRadius = 3.r;

  static double appBarLeadingWidth = 60.w;
  static double appBarActionsHeight = 60.h;
  static double appBarActionsWidth = 40.w;

  //divider
  static double dividerWidthForLandingTitle = 80.w;

  //TextFormFields
  static double textFormFieldLabelHorizontalGap = 2.w;
  static double textFormFieldLabelVerticalGap = 5.h;
  static double textFormFieldVerticalGap = 15.h;
  static double textFormFieldBorderRadius = 5.r;
  static double textFormFieldIconWidth = 15.w;
  static double textFormFieldIconHeight = 15.h;
  static double textFormFieldForPinHeight = 40.h;
  static double textFormFieldForPinWidth = 45.w;
  static double textFormFieldContentPaddingVertical = 10.h;
  static double textFormFieldContentPaddingHorizontal = 2.w;
  static double textFormFieldForPinContentPaddingHorizontal = 2.w;
  static double textFormFieldForPinContentPaddingVertical = 5.h;

  //Images
  static double imageWithStackPlaceHolderHeight = 120.h;
  static double imageWithStackPlaceHolderWidth = 135.w;
  static double imageHeightForCreateEditFeature = 115.h;
  static double imageWidthForCreateEditFeature = 100.w;

  //Buttons
  static double buttonVerticalGap = 20.h;
  static double buttonHorizontalGap = 10.h;
  static double buttonBorderRadius = 5.r;
  static double buttonLargePadding = 12.r;
  static double buttonTextGap = 8.w;

  //general
  static double generalRadius = 10.r;
  static double generalGap = 20.h;
  static double generalGapSmall = 10.h;
  static double generalGapSmallAtComponentLabel = 5.w;
  static double generalPaddingAllAroundSmall = 3.r;
  static double generalSmallRadius = 5.r;

  //Checkboxes
  static double authenticationCheckBoxGap = 5.h;
  static double authenticationCheckBoxHeight = 20.h;
  static double authenticationCheckBoxWidth = 20.w;

  //Toast
  static double toastElevation = 15.h;

  //dropDown padding
  static double dropDownVerticalGap = 12.w;

  //Bottom sheet
  static double bottomSheetRadius = 20.r;
  static double bottomSheetHorizontalGap = 5.w;
  static double bottomSheetVerticalGap = 20.h;
  static double bottomSheetBodyWidgetVerticalGap = 10.h;
  static double bottomSheetBodyStyleTabPadding = 8.r;

  static double bottomSheetGapBetweenBodyAndButtons = 20.h;

  static getScreenHeight() =>
      MediaQuery.of(navigatorKey.currentContext!).size.height;

  static getScreenWidth() =>
      MediaQuery.of(navigatorKey.currentContext!).size.width;

  static getBottomSheetHeight() => Dimensions.getScreenHeight() * 0.5;
}

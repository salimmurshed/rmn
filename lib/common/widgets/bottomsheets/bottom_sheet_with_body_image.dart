import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';

buildBottomSheetWithBodyImage(
    {required BuildContext context,
    required String title,
    String highlightedString = AppStrings.global_empty_string,
    bool isHighlightedStringBold = false,
    bool isHighlightedStringAccented = true,
    required String footerNote,
    bool isFooterNoteCentered = true,
    required String buttonText,
    String rightText = AppStrings.global_empty_string,
    String leftText = AppStrings.global_empty_string,
    required String imageUrl,
    required bool isSingleButtonPresent,
    void Function()? onLeftButtonPressed,
    void Function()? onRightButtonPressed,
    required void Function() onButtonPressed,
    required void Function()? navigatorFunction}) {
  buildCustomShowModalBottomSheetParent(
      ctx: context,
      isNavigationRequired: true,
      navigatorFunction: navigatorFunction,
      child: customBottomSheetBasicBody(
        leftButtonText: leftText,
        rightButtonText: rightText,
        isActive: true,
        isFooterNoteCentered: isFooterNoteCentered,
        onLeftButtonPressed: onLeftButtonPressed ?? () {},
        onRightButtonPressed: onRightButtonPressed ?? () {},
        title: title,
        isButtonPresent: true,
        highLightedAthleteName: highlightedString,
        context: context,
        footerNote: footerNote,
        singleButtonText: buttonText,
        isAccentedHighlight: isHighlightedStringAccented,
        isHighlightedTextBold: true,
        highLightedString: highlightedString,
        isSubtitleAsFooter: true,
        singleButtonFunction: onButtonPressed,
        widget: imageUrl.contains('.svg')
            ? SvgPicture.asset(
                imageUrl,
                height: 200.h,
                width: 200.w,
              )
            : SizedBox(
                height: 200.h,
                width: 200.w,
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
        isSingleButtonColorFilled: true,
        isSingeButtonPresent: isSingleButtonPresent,
      ));
}

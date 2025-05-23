import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';

buildBottomSheetWithBodyText({
  required BuildContext context,
  required String title,
  required String subtitle,
  String leftButtonText = AppStrings.global_empty_string,
  String rightButtonText = AppStrings.global_empty_string,
  required bool isSingeButtonPresent,
  String highLightedAthleteName = AppStrings.global_empty_string,
  bool isSingleButtonColorFilled = true,
  String singleButtonText = AppStrings.btn_ok,
  void Function()? singleButtonFunction,
  bool isAccentedHighlight = false,
  required void Function() onLeftButtonPressed,
  required void Function() onRightButtonPressed,
  void Function()? navigatorFunction,
  RichText? richText,
}) {
  buildCustomShowModalBottomSheetParent(
      ctx: context,
      isNavigationRequired: true,
      navigatorFunction: navigatorFunction,
      child: customBottomSheetBasicBody(
          isActive: true,
          footerNote: subtitle,
          isSubtitleAsFooter: false,
          title: title,
          richText: richText,
          isAccentedHighlight: isAccentedHighlight,
          highLightedAthleteName: highLightedAthleteName,
          widget: null,
          isButtonPresent: true,
          isSingeButtonPresent: isSingeButtonPresent,
          onLeftButtonPressed: onLeftButtonPressed,
          leftButtonText: leftButtonText,
          onRightButtonPressed: onRightButtonPressed,
          rightButtonText: rightButtonText,
          singleButtonFunction: singleButtonFunction,
          context: context,
          singleButtonText: singleButtonText,
          isSingleButtonColorFilled: isSingleButtonColorFilled));
}

Widget customBottomSheetBasicBody(
    {required String title,
    required String highLightedAthleteName,
    Widget? widget,
    bool isButtonPresent = true,
    bool isFooterNoteCentered = false,
    required bool isSingeButtonPresent,
    required void Function() onLeftButtonPressed,
    required String leftButtonText,
    required void Function() onRightButtonPressed,
    required String rightButtonText,
    void Function()? singleButtonFunction,
    required BuildContext context,
    required String footerNote,
    RichText? richText,
    required String singleButtonText,
    required bool isActive,
    String highLightedString = AppStrings.global_empty_string,
    String afterHighlighterPortionIntitle = AppStrings.global_empty_string,
    bool isSubtitleAsFooter = false,
    bool isHighlightedTextBold = false,
    bool isAccentedHighlight = false,
    required bool isSingleButtonColorFilled}) {
  //
  final double maxHeight = Dimensions.getScreenHeight() * 0.8;
  return Container(

    constraints: BoxConstraints(
      maxHeight: maxHeight,
    ),
    decoration: BoxDecoration(
      color: AppColors.colorTertiary,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),child:Wrap(
      children: [
        Container(
          constraints: BoxConstraints(
            maxHeight: Dimensions.getScreenHeight() * 0.7,
          ),
          width: Dimensions.getScreenWidth(),
          padding: AppWidgetStyles.buildPaddingForBottomSheet(),
          decoration: AppWidgetStyles.buildBoxDecorationForBottomSheet(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: Dimensions.bottomSheetVerticalGap,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppWidgetStyles.buildTitleForBottomSheet(
                        isCentered: true,
                        isHighlightedTextBold: isHighlightedTextBold,
                        isAccentedHighlight: isAccentedHighlight,
                        title: title,
                        afterHighlighterPortionIntitle: afterHighlighterPortionIntitle,
                        highlightedString: highLightedAthleteName),


                  ],
                ),
                customDivider(isBottomSheetTitle: true),
                if (richText != null) ...[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: richText,
                  ),
                ],
                if (footerNote.isNotEmpty && !isSubtitleAsFooter) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                    ),
                    child: AppWidgetStyles.buildBodyTextForBottomSheet(
                      bodyText: footerNote,
                      isCentered: isFooterNoteCentered,
                    ),
                  ),
                ],
                if (widget != null)
                  Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                      child: widget),
                if (footerNote.isNotEmpty && isSubtitleAsFooter) ...[
                  SizedBox(
                    height: Dimensions.generalGapSmall,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: AppWidgetStyles.buildBodyTextForBottomSheet(
                        bodyText: footerNote, isCentered: isFooterNoteCentered),
                  )
                ],
                AppWidgetStyles.buildGapBetweenBodyAndFooterForBottomSheet(),

              ],
            ),
          ),
        ),
        if (isButtonPresent) ...[
          if (!isSingeButtonPresent) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: buildTwinButtons(
                  onLeftTap: onLeftButtonPressed,
                  onRightTap: onRightButtonPressed,
                  leftBtnLabel: leftButtonText,
                  rightBtnLabel: rightButtonText,
                  isActive: isActive),
            ),
          ] else ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              //margin: AppWidgetStyles.buildPaddingForBottomSheet(),
              child: buildCustomLargeFooterBtn(
                  hasKeyBoardOpened: false,
                  onTap: singleButtonFunction ??
                          () {
                        Navigator.pop(context);
                      },
                  btnLabel: singleButtonText,
                  isActive: isActive,
                  isColorFilledButton: isSingleButtonColorFilled),
            ),
          ],
        ],
        Container(
          padding: EdgeInsets.only(bottom:  1.5 * Dimensions.bottomSheetVerticalGap,),
          width: Dimensions.getScreenWidth(),

        ),
      ],
    ),
  );
}

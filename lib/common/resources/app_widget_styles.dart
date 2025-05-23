// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:rmnevents/root_app.dart';

import '../../imports/common.dart';

class AppWidgetStyles {
  static Color textFormFieldFillColor() => AppColors.colorSecondary;

  static Color textFormCursorColor() => AppColors.colorPrimaryAccent;

  static Color textFormFieldFocusColor() => AppColors.colorPrimaryAccent;

  static WidgetStateProperty<Color> radioButtonFillColor() {
    return WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
      return AppColors.colorPrimaryAccent;
    });
  }

  static BoxDecoration buildBoxDecorationForBottomSheet(
      {bool isLightBg = true}) {
    return BoxDecoration(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(Dimensions.bottomSheetRadius)),
        color: isLightBg ? AppColors.colorTertiary : AppColors.colorSecondary);
  }

  static BoxDecoration buildBoxDecorationForWCTiles({bool? isSoldOut}) {
    return BoxDecoration(
        borderRadius:
            BorderRadius.circular(Dimensions.textFormFieldBorderRadius),
        color: isSoldOut ?? false ? AppColors.colorSoldOut : AppColors.colorPrimary);
  }
  static BoxDecoration buildBoxDecorationForRegistrationLimit({required bool isSoldOut}) {
    return BoxDecoration(
        borderRadius:
        BorderRadius.circular(Dimensions.textFormFieldBorderRadius),
        color: isSoldOut ? AppColors.colorSoldOut :AppColors.colorPrimary);
  }

  static EdgeInsets buildPaddingForBottomSheet() {
    return EdgeInsets.symmetric(
      horizontal: Dimensions.bottomSheetHorizontalGap,
    );
  }

  static buildTitleForBottomSheet(
      {required String title,
      bool isHighlightedTextBold = false,
      bool isAccentedHighlight = true,
      bool isCentered = true,
        String afterHighlighterPortionIntitle = AppStrings.global_empty_string,
      required String highlightedString}) {
    return Expanded(
      child: highlightedString.isEmpty
          ? Text(
              title,
              maxLines: 2,
              textAlign: isCentered ? TextAlign.center : TextAlign.left,
              style: AppTextStyles.bottomSheetTitle(),
            )
          : RichText(
              textAlign: isCentered ? TextAlign.center : TextAlign.left,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: title, style: AppTextStyles.bottomSheetTitle()),
                  TextSpan(
                      text: ' $highlightedString',
                      style: AppTextStyles.bottomSheetTitle(
                          isBold: isAccentedHighlight,
                          color: isAccentedHighlight
                              ? AppColors.colorPrimaryAccent
                              : AppColors.colorPrimaryInverseText)),
                  TextSpan(
                      text: afterHighlighterPortionIntitle, style: AppTextStyles.bottomSheetTitle()),
                ],
              ),
            ),
    );
  }

  static Text buildBodyTextForBottomSheet(
      {required String bodyText, bool isCentered = false}) {
    return Text(bodyText,
        textAlign: isCentered ? TextAlign.center : TextAlign.left,
        style: AppTextStyles.bottomSheetSubtitle(isOutfit: true));
  }

  static RichText buildBodyTextWithHighlightedText(
      {required String precedingText,
      required String highlightedText,
      required String followingText}) {
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
              text: precedingText,
              style: AppTextStyles.regularNeutralOrAccented(isOutfit: true)),
          TextSpan(
              text: highlightedText,
              style: AppTextStyles.regularNeutralOrAccented(
                  isBold: true,
                  color: AppColors.colorPrimaryInverseText,
                  isOutfit: true)),
          TextSpan(
              text: followingText,
              style: AppTextStyles.regularNeutralOrAccented(isOutfit: true)),
        ],
      ),
    );
  }

  static Widget buildFooterForBottomSheet({required int accessType}) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Dimensions.bottomSheetGapBetweenBodyAndButtons,
      ),
      child: Text(
        accessType == 0
            ? AppStrings
                .myAthletes_bottomSheet_acceptRejectBody_viewAccess_footer_text
            : accessType == 1
                ? AppStrings
                    .myAthletes_bottomSheet_acceptRejectBody_ownershipAccess_footer_text
                : AppStrings
                    .myAthletes_bottomSheet_acceptRejectBody_coachAccess_footer_text,
        style: AppTextStyles.subtitle(isBold: true),
      ),
    );
  }

  static Widget buildGapBetweenBodyAndFooterForBottomSheet() {
    return SizedBox(
      height: Dimensions.bottomSheetGapBetweenBodyAndButtons,
    );
  }

  static OutlineInputBorder textFormFieldEnabledBorder(
      {bool isDisabled = false, Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimensions.textFormFieldBorderRadius),
      borderSide: BorderSide(
          color: isDisabled
              ? AppColors.colorPrimary
              : color ?? AppColors.colorTertiary),
    );
  }

  static OutlineInputBorder textFormFieldFocusedBorder(
      {bool isReadOnly = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimensions.textFormFieldBorderRadius),
      borderSide: BorderSide(
          color: isReadOnly
              ? AppColors.colorPrimary
              : AppColors.colorPrimaryNeutral),
    );
  }

  static OutlineInputBorder textFormFieldErrorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimensions.textFormFieldBorderRadius),
      borderSide: BorderSide(color: AppColors.colorPrimaryAccent),
    );
  }

  static OutlineInputBorder textFormFieldFocusedErrorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimensions.textFormFieldBorderRadius),
      borderSide: BorderSide(color: AppColors.colorPrimaryAccent),
    );
  }

  static bottomSheetOpacityValue({required bool isDisabled}) =>
      isDisabled ? 0.5 : 1.0;
}

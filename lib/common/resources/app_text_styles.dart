import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../imports/common.dart';

class AppTextStyles {
  static TextStyle landingTitle({FontWeight? fontWeight, double? fontSize}) {
    return TextStyle(
      fontFamily: AppFontFamilies.squada,
      fontWeight: fontWeight ?? AppFontWeight.titleLargeWeightedSquada,
      fontSize: fontSize ?? AppFontSizes.titleLanding,
      color: AppColors.colorPrimaryInverseText,
    );
  }

  static TextStyle extraLargeTitle({bool isLight = false}) {
    return TextStyle(
      fontFamily: AppFontFamilies.squada,
      fontWeight:
          isLight ? FontWeight.w100 : AppFontWeight.titleLargeWeightedSquada,
      fontSize: AppFontSizes.titleExtraLarge,
      color: AppColors.colorPrimaryInverseText,
    );
  }

  static TextStyle largeTitle(
      {Color? color,
      bool isBold = false,
      bool isSquada = true,
      bool isLinedThrough = false}) {
    return TextStyle(
      decorationStyle: isLinedThrough ? TextDecorationStyle.solid : null,
      decorationThickness: isLinedThrough ? 2 : null,
      decorationColor: AppColors.colorPrimaryInverseText,
      decoration: isLinedThrough ? TextDecoration.lineThrough : null,
      fontFamily: isSquada ? AppFontFamilies.squada : AppFontFamilies.outfit,
      fontWeight:
          isBold ? FontWeight.bold : AppFontWeight.titleMediumWeightedSquada,
      fontSize: isLinedThrough
          ? AppFontSizes.titleSmallLinedThrough
          : AppFontSizes.titleLarge,
      color: color ?? AppColors.colorPrimaryInverseText,
    );
  }
  static TextStyle largeTitleWithoutLingThrough(
      {Color? color,
        bool isBold = false,
        bool isSquada = true,}) {
    return TextStyle(
      decorationColor: AppColors.colorPrimaryInverseText,
      fontFamily: isSquada ? AppFontFamilies.squada : AppFontFamilies.outfit,
      fontWeight:AppFontWeight.titleSmallWeightedOutFit,
      fontSize:
          AppFontSizes.titleSmallLinedThrough,
      color: color ?? AppColors.colorPrimaryInverseText,
    );
  }
  static TextStyle smallTitle(
      {bool isOutFit = false,
      bool isBold = false,
      Color? color,
      double? fontSize,
      bool isUnderlined = false,
      bool isLinedThrough = false}) {
    return TextStyle(
      height: 1,

      decorationStyle: isLinedThrough ? TextDecorationStyle.solid : null,
      decorationThickness: isLinedThrough ? 2 : null,
      decorationColor: AppColors.colorPrimaryInverseText,
      decoration: isUnderlined ? TextDecoration.underline :
      isLinedThrough ? TextDecoration.lineThrough : null,
      fontFamily: isOutFit ? AppFontFamilies.outfit : AppFontFamilies.squada,
      fontWeight:
          isBold ? FontWeight.bold : AppFontWeight.titleSmallWeightedOutFit,
      fontSize: fontSize ??
          (isLinedThrough
              ? AppFontSizes.titleSmallLinedThrough
              : AppFontSizes.titleSmall),
      color: color ?? AppColors.colorPrimaryInverseText,

    );
  }

  static TextStyle dialogTitle(
      {bool isOutFit = false,
      bool isBold = false,
      Color? color,
      bool isLinedThrough = false}) {
    return TextStyle(
      decorationStyle: isLinedThrough ? TextDecorationStyle.solid : null,
      decorationThickness: isLinedThrough ? 2 : null,
      decorationColor: AppColors.colorPrimaryInverseText,
      decoration: isLinedThrough ? TextDecoration.lineThrough : null,
      fontFamily: isOutFit ? AppFontFamilies.outfit : AppFontFamilies.squada,
      fontWeight:
          isBold ? FontWeight.bold : AppFontWeight.titleSmallWeightedOutFit,
      fontSize: isLinedThrough
          ? AppFontSizes.titleSmallLinedThrough
          : AppFontSizes.titleSmall,
      color: color ?? AppColors.colorPrimaryInverseText,
    );
  }

  static TextStyle bottomSheetTitle(
      {bool isOutFit = false,
      bool isBold = false,
      Color? color,
      bool isLinedThrough = false}) {
    return TextStyle(
      decorationStyle: isLinedThrough ? TextDecorationStyle.solid : null,
      decorationThickness: isLinedThrough ? 2 : null,
      decorationColor: AppColors.colorPrimaryInverseText,
      decoration: isLinedThrough ? TextDecoration.lineThrough : null,
      fontFamily: isOutFit ? AppFontFamilies.outfit : AppFontFamilies.squada,
      fontWeight:
          isBold ? FontWeight.bold : AppFontWeight.titleSmallWeightedOutFit,
      fontSize: isLinedThrough
          ? AppFontSizes.titleSmallLinedThrough
          : AppFontSizes.titleBottomSheet,
      color: color ?? AppColors.colorPrimaryInverseText,
    );
  }

  static TextStyle smallTitleForEmptyList(
      {bool isOutFit = false, Color? color, bool isLinedThrough = false}) {
    return TextStyle(
      decorationStyle: isLinedThrough ? TextDecorationStyle.solid : null,
      decorationThickness: isLinedThrough ? 2 : null,
      decorationColor: AppColors.colorPrimaryInverseText,
      decoration: isLinedThrough ? TextDecoration.lineThrough : null,
      fontFamily: isOutFit ? AppFontFamilies.outfit : AppFontFamilies.squada,
      fontWeight: AppFontWeight.titleSmallWeightedOutFit,
      fontSize: isLinedThrough
          ? AppFontSizes.titleSmallLinedThrough
          : AppFontSizes.titleSmall,
      color: color ?? AppColors.colorPrimaryInverseText,
    );
  }

  static TextStyle componentLabels({isOutFit = false,Color? color, bool isNormal = true, bool isBold = false,}) {
    return TextStyle(
      fontFamily: isOutFit ? AppFontFamilies.outfit : AppFontFamilies.squada,
      fontWeight:isBold?
      FontWeight.bold: AppFontWeight.titleLargeWeightedSquada,
      fontSize: isNormal ? AppFontSizes.normal : AppFontSizes.component,
      color: color ?? AppColors.colorPrimaryInverseText,
    );
  }

  static TextStyle buttonTitle({Color? color}) {
    return TextStyle(
      fontFamily: AppFontFamilies.squada,
      fontWeight: AppFontWeight.titleSmallWeightedOutFit,
      fontSize: AppFontSizes.subtitle,
      color: color ?? AppColors.colorPrimaryInverseText,
    );
  }

  static TextStyle tabTitle({Color? color, bool isSmallButtonTitle = true}) {
    return TextStyle(
      fontFamily: AppFontFamilies.squada,
      fontWeight: AppFontWeight.titleSmallWeightedOutFit,
      fontSize:
          isSmallButtonTitle ? AppFontSizes.regular : AppFontSizes.subtitle,
      color: color ?? AppColors.colorPrimaryInverseText,
    );
  }

  static TextStyle subtitle(
      {Color? color,
      isOutFit = true,
      bool isBold = false,
      FontWeight? fontWeight,
      bool isLinedThrough = false}) {
    return TextStyle(
      decorationStyle: isLinedThrough ? TextDecorationStyle.solid : null,
      decorationThickness: isLinedThrough ? 2 : null,
      decorationColor: AppColors.colorPrimaryInverseText,
      decoration: isLinedThrough ? TextDecoration.lineThrough : null,
      fontFamily: isOutFit ? AppFontFamilies.outfit : AppFontFamilies.squada,
      fontWeight: fontWeight ??
          (isBold ? FontWeight.bold : AppFontWeight.subtitleWeightedOutFit),
      fontSize: isLinedThrough ? AppFontSizes.normal : AppFontSizes.subtitle,
      color: color ?? AppColors.colorPrimaryInverseText,
      height: 1
    );
  }

  static TextStyle regularPrimary(
      {bool isOutFit = true, Color? color, bool isBold = false}) {
    return TextStyle(
      fontFamily: isOutFit ? AppFontFamilies.outfit : AppFontFamilies.squada,
      fontWeight:
          isBold ? FontWeight.bold : AppFontWeight.subtitleWeightedOutFit,
      fontSize: AppFontSizes.regular,
      color: color ?? AppColors.colorPrimaryInverseText,
      height: 1,
    );
  }

  static TextStyle superSmallPrimary(
      {bool isOutFit = true, Color? color, bool isBold = false, double? fontSize}) {
    return TextStyle(
      fontFamily: isOutFit ? AppFontFamilies.outfit : AppFontFamilies.squada,
      fontWeight:
          isBold ? FontWeight.bold : AppFontWeight.subtitleWeightedOutFit,
      fontSize: fontSize ?? AppFontSizes.superSmall,
      color: color ?? AppColors.colorPrimaryInverseText,
    );
  }

  static TextStyle regularForMap({Color? color, bool isBold = true}) {
    return TextStyle(
      fontFamily: isBold ? AppFontFamilies.squada : AppFontFamilies.outfit,
      fontWeight: AppFontWeight.subtitleWeightedOutFit,
      fontSize: 10.sp,
      color: color ?? AppColors.colorPrimaryNeutralText,
    );
  }

  static TextStyle regularNeutralOrAccented(
      {Color? color, bool isOutfit = false, bool isBold = false}) {
    return TextStyle(
      fontFamily: isOutfit ? AppFontFamilies.outfit : AppFontFamilies.squada,
      fontWeight:isBold? FontWeight.bold: AppFontWeight.normalWeightedOutFitLight,
      fontSize: AppFontSizes.regular,
      color: color ?? AppColors.colorPrimaryNeutralText,
      height: 1
    );
  }

  static TextStyle bottomSheetSubtitle(
      {Color? color, bool isOutfit = false, isBold = false}) {
    return TextStyle(
      fontFamily: isOutfit ? AppFontFamilies.outfit : AppFontFamilies.squada,
      fontWeight:
          isBold ? FontWeight.bold : AppFontWeight.subtitleWeightedOutFit,
      fontSize: AppFontSizes.regular,
      color: color ?? AppColors.colorPrimaryNeutralText,
    );
  }

  static TextStyle dialogSubtitle(
      {Color? color, bool isOutfit = true, isBold = false}) {
    return TextStyle(
      fontFamily: isOutfit ? AppFontFamilies.outfit : AppFontFamilies.squada,
      fontWeight:
          isBold ? FontWeight.bold : AppFontWeight.subtitleWeightedOutFit,
      fontSize: AppFontSizes.regular,
      color: color ?? AppColors.colorPrimaryNeutralText,
    );
  }

  static TextStyle normalPrimary(
      {Color? color,
      bool isBold = false,
      isOutfit = true,
      FontWeight? fontWeight, double? fontSize}) {
    return TextStyle(
      fontFamily: isOutfit ? AppFontFamilies.outfit : AppFontFamilies.squada,
      fontWeight: fontWeight ??
          (isBold ? FontWeight.w700 : AppFontWeight.normalWeightedOutFitLight),
      fontSize: fontSize ?? AppFontSizes.normal,
      height: 1,
      color: color ?? AppColors.colorPrimaryInverseText,
    );
  }

  static TextStyle subtitleLight({Color? color, isOutfit = true}) {
    return TextStyle(
      fontFamily: isOutfit ? AppFontFamilies.outfit : AppFontFamilies.squada,
      fontWeight: FontWeight.w100,
      fontSize: AppFontSizes.subtitle,
      color: color ?? AppColors.colorPrimaryInverseText,
    );
  }

  static TextStyle normalNeutral(
      {bool isSquada = false, bool isBold = false, FontWeight? fontWeight, double? fonstSize}) {
    return TextStyle(
      fontFamily: isSquada ? AppFontFamilies.squada : AppFontFamilies.outfit,
      fontWeight: fontWeight ??

          (isBold ? FontWeight.bold : AppFontWeight.normalWeightedOutFitLight),
      fontSize:  fonstSize ?? AppFontSizes.normal,
      height: 1,
      color: AppColors.colorPrimaryNeutral,
    );
  }

  static TextStyle normalAccented(Color? color) {
    return TextStyle(
      fontFamily: AppFontFamilies.squada,
      fontWeight: AppFontWeight.normalWeightedOutFitThick,
      fontSize: AppFontSizes.normal,
      color: color ?? AppColors.colorPrimaryAccent,
    );
  }

  static TextStyle textFormFieldErrorStyle() {
    return AppTextStyles.normalPrimary(color: AppColors.colorPrimaryAccent);
  }

  static TextStyle textFormFieldELabelStyle() {
    return AppTextStyles.regularPrimary();
  }

  static TextStyle textFormFieldEHintStyle({bool isDisabled = false}) {
    return AppTextStyles.regularPrimary(
        isBold: false, color: AppColors.colorDisabled);
  }

  static TextStyle toastTextStyle({Color? color}) {
    return TextStyle(
      fontFamily: AppFontFamilies.squada,
      fontWeight: AppFontWeight.regularWeightedSquadaThick,
      fontSize: AppFontSizes.subtitle,
      color: color ?? AppColors.colorPrimaryInverseText,
    );
  }

  static TextStyle verySmallTitle({Color? color}) {
    return TextStyle(
      fontFamily: AppFontFamilies.squada,
      fontWeight: AppFontWeight.regularWeightedSquadaThick,
      fontSize: AppFontSizes.superSmall,
      color: color ?? AppColors.colorPrimaryNeutralText,
    );
  }
}

class AppFontFamilies {
  static const String squada = "squada-one";
  static const String outfit = "Outfit";
}

class AppFontSizes {
  static double titleLanding = 30.sp;
  static double titleExtraLarge = 26.sp;
  static double titleLarge = 22.sp;
  static double titleSmall = 18.sp;
  static double titleBottomSheet = 20.sp;
  static double titleSmallLinedThrough = 16.sp;

  static double subtitle = 15.sp;
  static double regular = 14.sp;
  static double normal = 12.sp;
  static double component = 10.sp;
  static double superSmall = 8.sp;
}

class AppFontWeight {
  static const FontWeight titleLargeWeightedSquada = FontWeight.w400;
  static const FontWeight titleMediumWeightedSquada = FontWeight.w400;
  static const FontWeight titleSmallWeightedOutFit = FontWeight.w500;
  static const FontWeight subtitleWeightedOutFit = FontWeight.w400;
  static const FontWeight normalWeightedOutFitLight = FontWeight.w400;
  static const FontWeight normalWeightedOutFitThick = FontWeight.w500;
  static const FontWeight regularWeightedSquadaThick = FontWeight.w500;
}

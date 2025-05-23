import 'package:flutter/material.dart';

class AppColors {
  static Color colorPrimary = HexColor.fromHex("#050505");
  static Color colorSecondary = HexColor.fromHex("#141414");
  static Color colorTertiary = HexColor.fromHex("#202020");
  static Color colorPrimaryNeutral = HexColor.fromHex("#D0D0D0");
  static Color colorPrimaryInverse = HexColor.fromHex("#FFFFFF");
  static Color colorPrimaryDisabled = HexColor.fromHex("#bfbfbf");
  static Color colorPrimaryDivider= HexColor.fromHex("##3F3C3C");

  static Color colorPrimaryText = HexColor.fromHex("#050505");
  static Color colorSecondaryText = HexColor.fromHex("#636d7d");
  static Color colorTertiaryText = HexColor.fromHex("#7A7E89");
  static Color colorAccentText = HexColor.fromHex("#CC0000");
  static Color colorPrimaryInverseText = HexColor.fromHex("#FFFFFF");
  static Color colorPrimaryNeutralText = HexColor.fromHex("#D0D0D0");

  static Color colorPrimaryAccent = HexColor.fromHex("#CC0000");
  static Color colorSecondaryAccent = HexColor.fromHex("#0A52BE");
  static Color colorSecondaryAccentAlternative = HexColor.fromHex("#05439F");
  static Color colorGreenAccent = HexColor.fromHex("#00AC9E");
  static Color colorTertiaryAccent = HexColor.fromHex("#00AC9E");
  static Color colorDisabledPrimaryAccent = HexColor.fromHex("#720000");
  static Color colorComponent = HexColor.fromHex("#00AC9E");
  static Color colorError = HexColor.fromHex("#CC0000");
  static Color colorSuccess = HexColor.fromHex("#1EC04A");
  static Color colorWarning = HexColor.fromHex("#FECD29");
  static Color colorDisabled = HexColor.fromHex("#808080");
  static Color colorInActive = HexColor.fromHex("#AAAAAA");
  static Color colorSoldOut = HexColor.fromHex("#1C0404");
  static Color colorPrimaryGredient = HexColor.fromHex("#CC0000BA");

  static Color colorSecondaryBlackOpaque = HexColor.fromHex(AppColors
      .colorSecondary
      .withOpacity(0.9)
      .value
      .toRadixString(16)
      .padLeft(8, '0'));
  static Color colorBlackOpaque = HexColor.fromHex(AppColors.colorPrimary
      .withOpacity(0.7)
      .value
      .toRadixString(16)
      .padLeft(8, '0'));
  static Color colorRedOpaque = HexColor.fromHex(AppColors.colorPrimaryAccent
      .withOpacity(0.5)
      .value
      .toRadixString(16)
      .padLeft(8, '0'));
  static Color colorWhiteOpaque =
      AppColors.colorPrimaryInverse.withOpacity(0.05);
  static Color colorBlueOpaque =
      AppColors.colorSecondaryAccent.withOpacity(0.3);
  static Color colorGreenOpaque = HexColor.fromHex(AppColors.colorGreenAccent
      .withOpacity(0.7)
      .value
      .toRadixString(16)
      .padLeft(8, '0'));
  static Color colorSuccessOpaque = HexColor.fromHex(AppColors.colorSuccess
      .withOpacity(0.7)
      .value
      .toRadixString(16)
      .padLeft(8, '0'));
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF$hexColorString"; // 8 char with opacity 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import '../../../imports/common.dart';

Container buildCenteredItemDropDown({
  required void Function(bool)? onMenuStateChange,
  required void Function(String?)? onChanged,
  required BuildContext context,
  required GlobalKey<dynamic> globalKey,
  required List<String> list,
  required bool isExpanded,
  required String? selectedValue,
}) {
  return Container(
    margin: EdgeInsets.only(top: Dimensions.generalGap),
    child: DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        key: globalKey,
        isExpanded: true,
        hint: Row(
          children: [
            SizedBox(
                width: Dimensions.getScreenWidth() * 0.08),
            Expanded(
              child: Center(
                child: Text(
                  AppStrings.athleteDetails_seasonName_dropDown_hint,
                  style: AppTextStyles.smallTitle(
                      color: AppColors.colorPrimaryNeutralText),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        items: list
            .map((item) => DropdownMenuItem<String>(
          value: item,
          child: Center(
            child: Text(
              item.toString(),
              maxLines: 2,
              textAlign: TextAlign.center,
              style: AppTextStyles.smallTitle(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ))
            .toList(),
        value: selectedValue,
        onChanged: onChanged,
        buttonStyleData: ButtonStyleData(
          height: 40.h,
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.generalGap,
          ),
          decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(Dimensions.textFormFieldBorderRadius),
              border: Border.all(
                color: AppColors.colorPrimaryInverse,
              ),
              color: AppColors.colorPrimary),
        ),
        onMenuStateChange: onMenuStateChange,
        iconStyleData: IconStyleData(
          icon: Transform.rotate(
              angle: isExpanded ? 180 * math.pi / 180 : 180 * math.pi / 90,
              child: Icon(
                Icons.arrow_drop_down,
                color: isExpanded
                    ? AppColors.colorPrimaryAccent
                    : AppColors.colorPrimaryInverseText,
              )),
          iconSize: 30,
          iconEnabledColor: Colors.white,
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            color: AppWidgetStyles.textFormFieldFillColor(),
          ),
          offset: Offset(0, -10.h),
          scrollbarTheme: ScrollbarThemeData(
            radius: Radius.circular(40.r),
            thickness: WidgetStateProperty.all<double>(6),
            thumbVisibility: WidgetStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 40.h,
          padding: EdgeInsets.only(left: 14.w, right: 14.w),
        ),
      ),
    ),
  );
}
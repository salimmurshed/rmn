import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import '../../../imports/common.dart';

Widget bottomSheetWithDropDownBody({required GlobalKey<State<StatefulWidget>> globalKey,
  required bool isExpanded,
  bool isCancelBtnRequired = false,
  required bool isButtonActive,
  required String title,
  required String highlightedTitle,
  required String hint,
  required List<DropdownMenuItem<String>> items,
  required String? selectedValue,
  required void Function(String?)? onChanged,
  void Function(bool)? onMenuStateChange,
  required String footerBtnLabel,
  String? bodyText,
  RichText? richText,
  bool showButtons = true,
  required String prompt,
  required bool isInvoice,
  required BuildContext context,
  TextEditingController? textEditingController,
  required void Function() onLeftTap,
  required void Function() onRightTap,
  String leftBtnLabel = AppStrings.global_empty_string,
  String rightBtnLabel = AppStrings.global_empty_string,
  required void Function() onTap}) {

  return customBottomSheetBasicBody(title: title,
      highLightedAthleteName: highlightedTitle,
      isSingeButtonPresent: !isCancelBtnRequired,
      onLeftButtonPressed: onLeftTap,
      leftButtonText: leftBtnLabel,richText: richText,
      onRightButtonPressed: onRightTap,isButtonPresent: showButtons,
      singleButtonFunction: onTap,
      widget: Column(children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            margin: EdgeInsets.only(top: 3.h, left: 0.w, bottom: 10.h),
            child: RichText(
              text: TextSpan(
                text: prompt,
                style: AppTextStyles.subtitle(isOutFit: false),
                children: [
                  TextSpan(
                      text: ' *',
                      style: AppTextStyles.normalPrimary(
                          color: AppColors.colorPrimaryAccent)),
                ],
              ),
            ),
          ),
        ),
        if(isInvoice)
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            key: globalKey,
            isExpanded: true,
            hint: Row(
              children: [
                Expanded(
                  child: Text(
                    hint,
                    style: AppTextStyles.subtitle(
                        color: AppColors.colorPrimaryNeutralText),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            items: items,
            value: selectedValue,
            onChanged: onChanged,
            buttonStyleData: ButtonStyleData(
              height: 50.h,
              padding: EdgeInsets.symmetric(
                horizontal: 2.w,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      Dimensions.textFormFieldBorderRadius),
                  border: Border.all(
                    color: AppColors.colorTertiary,
                  ),
                  color: AppColors.colorPrimary),
            ),
            dropdownSearchData: textEditingController != null
                ? DropdownSearchData(
              searchController: textEditingController,
              searchInnerWidgetHeight: 50.h,
              searchInnerWidget: Container(
                height: 50.h,
                padding: EdgeInsets.all(6.r),
                child: TextFormField(
                  expands: true,
                  maxLines: null,
                  controller: textEditingController,
                  style: AppTextStyles.subtitle(
                      color: AppColors.colorPrimaryNeutralText),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintText: AppStrings.global_search_hint,
                    hintStyle: AppTextStyles.subtitle(
                        color: AppColors.colorPrimaryNeutralText),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColors.colorPrimaryNeutral),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColors.colorPrimaryInverse),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: AppColors.colorTertiary),
                    ),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                return item.value.toString().contains(searchValue);
              },
            )
                : null,
            onMenuStateChange: onMenuStateChange,
            iconStyleData: IconStyleData(
              icon: Transform.rotate(
                  angle: isExpanded
                      ? 180 * math.pi / 180
                      : 180 * math.pi / 90,
                  child: Padding(
                    padding:  EdgeInsets.only(right: 8.w),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: isExpanded
                          ? AppColors.colorPrimaryAccent
                          : AppColors.colorPrimaryInverseText,
                    ),
                  )),
              iconSize: 30.sp,
              iconEnabledColor: Colors.white,
              iconDisabledColor: Colors.grey,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.colorPrimary,
                    AppColors.colorSecondary
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
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
              overlayColor: WidgetStateProperty.all<Color>(
                  AppColors.colorPrimaryNeutral),
              selectedMenuItemBuilder: (ctx, child) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.colorTertiary,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: child,
                );
              },
              padding: EdgeInsets.only(left: 14.w, right: 14.w),
            ),
          ),
        ),
          if(!isInvoice)

        dropDownForTeamSelection(
          dropDownType: DropDownTypeForCreateAthlete.teamSelection,
            dropDownKey: globalKey,
            selectedValue: selectedValue,
            searchController: textEditingController!,
            otherTeamController: textEditingController,
            onChanged: onChanged,
            otherTeamFocusNode: FocusNode(),
            isSmallSpace: false,
            context: context,
            onRightTap: onRightTap
        )

      ],),
      rightButtonText: rightBtnLabel,
      context: context,
      footerNote: bodyText ?? AppStrings.global_empty_string,
      singleButtonText: footerBtnLabel,
      isActive: isButtonActive,
      isSingleButtonColorFilled: true);
}

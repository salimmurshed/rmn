import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';

Widget buildCustomEventSearchField(
    {required TextEditingController searchController,
      required FocusNode focusNode,
      required GlobalKey<FormState> formKey,
      required void Function() searchFunction,
      required bool showEraser,
      required void Function() eraserFunction,
      required void Function(String) onChangeSearchFunction}) {
  return Form(
    key: formKey,
    child: CustomTextFormFields(
      textEditingController: searchController,
      focusNode: focusNode,
      label: AppStrings.global_empty_string,
      hint: AppStrings.global_search_hint,
      textInputType: TextInputType.text,
      isAsteriskPresent: false,
      isReadOnly: false,
      isEnabled: true,
      isDisabled: false,
      isObscure: false,
      maxLength: null,
      prefixIcon: GestureDetector(
        onTap: searchFunction,
        child: Padding(
          padding: EdgeInsets.all(10.r),
          child: SvgPicture.asset(AppAssets.icSearch),
        ),
      ),
      suffixIcon: showEraser
          ? GestureDetector(
        onTap: eraserFunction,
        child: Container(
          height: 10.h,
          width: 10.w,
          padding: EdgeInsets.only(
              top: 10.h, bottom: 10.h, right: 20.w, left: 10.w),
          child: SvgPicture.asset(
            AppAssets.icRemove,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(
                AppColors.colorDisabled, BlendMode.srcIn),
          ),
        ),
      )
          : null,
      onTap: () {},
      onChanged: onChangeSearchFunction,
      onFieldSubmitted: (value) {
        searchFunction();
      },
      textInputAction: TextInputAction.search,
      validator: (value) => null,
    ),
  );
}
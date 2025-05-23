import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';

Container buildSearchSection({
  required void Function(String)? onChanged,
  required void Function(String)? onFieldSubmitted,
  required TextEditingController searchController,
  required FocusNode searchFocusNode,
  required bool showSearchIcon,
  required String searchText,
  required void Function()? onTapToEraseSearchText,
  required void Function()? onTapToSearch,

}) {
  return Container(
    margin: EdgeInsets.only(
      bottom: Dimensions.generalGap,
    ),
    child: Row(
      children: [
        Expanded(
          child: CustomTextFormFields(
              isAsteriskPresent: false,
              suffixIcon: GestureDetector(
                onTap: showSearchIcon? onTapToSearch: onTapToEraseSearchText,
                child: buildSuffixIconForAthletesSearch(
                    showSearchIcon: showSearchIcon),
              ),

              textInputType: TextInputType.text,
              textInputAction: TextInputAction.search,
              textEditingController: searchController,
              focusNode: searchFocusNode,
              label: AppStrings.global_empty_string,
              hint: AppStrings.global_search_hint,
              onFieldSubmitted: onFieldSubmitted,
              onChanged: onChanged),
        ),
      ],
    ),
  );
}
Container buildSuffixIconForAthletesSearch({required bool showSearchIcon}) {
  return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.textFormFieldIconWidth,
        vertical: Dimensions.textFormFieldIconHeight,
      ),
      child: showSearchIcon
          ? SvgPicture.asset(AppAssets.icSearch)
          : SvgPicture.asset(AppAssets.icRemove));
}

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/presentation/base/bloc/base_bloc.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';
import '../bottomsheets/bottom_sheet_no_team_found.dart';

Widget dropDownForTeamSelection(
    {required GlobalKey<State<StatefulWidget>> dropDownKey,
    required String? selectedValue,
    required DropDownTypeForCreateAthlete dropDownType,
    required TextEditingController searchController,
    required TextEditingController otherTeamController,
    required void Function(String?)? onChanged,
    required FocusNode otherTeamFocusNode,
    bool isSmallSpace = false,
      String? gradeError,
    required BuildContext context,
    required void Function() onRightTap}) {
  bool isOpen = false;
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        key: dropDownKey,
        isExpanded: true,
        hint: buildHint(
          hint: DropDownTypeForCreateAthlete.gradeSelection == dropDownType
              ? AppStrings.profile_createEditAthlete_dropDownGrade_hint
              : null,
        ),
        style: AppTextStyles.textFormFieldELabelStyle(),
        items: DropDownTypeForCreateAthlete.gradeSelection == dropDownType
            ? buildListOfGradeNames(globalGrades)
            : buildListOfTeamNames(globalTeams),
        value: selectedValue,
        onChanged: onChanged,
        buttonStyleData: isSmallSpace
            ? buildButtonStyleData()
            : ButtonStyleData(
                height: Dimensions.getScreenHeight() * 0.065,
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.generalGapSmall,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      Dimensions.textFormFieldBorderRadius),
                  border: Border.all(
                    color: gradeError == null? AppColors.colorPrimary
                    : AppColors.colorPrimaryAccent,
                  ),
                  color: AppWidgetStyles.textFormFieldFillColor(),
                ),
              ),
        selectedItemBuilder: (BuildContext context) {
          return dropDownType == DropDownTypeForCreateAthlete.gradeSelection
              ? globalGrades
                  .map((item) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name!,
                            style: AppTextStyles.textFormFieldELabelStyle(),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ))
                  .toList()
              : globalTeams
                  .map((item) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name!,
                            style: AppTextStyles.textFormFieldELabelStyle(),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ))
                  .toList();
        },
        dropdownSearchData:
            dropDownType == DropDownTypeForCreateAthlete.teamSelection
                ? buildDropdownSearchData(searchController, () {
                    buildBottomSheetForNoTeamFound(
                        onChanged: onChanged,
                        context: context,
                        otherTeamController: otherTeamController,
                        otherTeamFocusNode: otherTeamFocusNode,
                        onRightTap: onRightTap);
                  })
                : null,
        //This to clear the search value when you close the menu
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            searchController.clear();
          }
          setState(() {
            isOpen = isOpen;
          });
        },
        iconStyleData: IconStyleData(
          icon: Icon(
            isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          ),
          iconSize: 20,
          iconEnabledColor: Colors.white,
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: buildDropdownStyleData(context),
        menuItemStyleData: buildMenuItemStyleData(),
      ),
    );
  });
}

MenuItemStyleData buildMenuItemStyleData({double? height}) {
  return MenuItemStyleData(
    selectedMenuItemBuilder: (context, value) {
      return Container(
        color: AppColors.colorRedOpaque,
        child: value,
      );
    },
    height:height?? 40.h,
    overlayColor: WidgetStateProperty.all<Color>(AppColors.colorPrimaryAccent),
    padding: EdgeInsets.only(left: 14.w, right: 14.w),
  );
}

DropdownStyleData buildDropdownStyleData(BuildContext context) {
  return DropdownStyleData(
    maxHeight: MediaQuery.of(context).size.height * 0.5,
    width: MediaQuery.of(context).size.width * 0.85,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      color: AppColors.colorSecondary,
    ),
    offset: Offset(-200.w, -2.h),
    scrollbarTheme: ScrollbarThemeData(
      radius: const Radius.circular(40),
      thickness: WidgetStateProperty.all<double>(6),
      thumbVisibility: WidgetStateProperty.all<bool>(true),
    ),
  );
}

DropdownSearchData<String> buildDropdownSearchData(
    TextEditingController searchController,
    void Function() openModalBottomSheetForOtherTeam) {
  return DropdownSearchData(
    searchController: searchController,
    searchInnerWidgetHeight: 40.h,
    searchInnerWidget: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSearchFormFieldForTeam(searchController),
          SizedBox(height: 10.h),
          buildNoTeamFoundTitle(openModalBottomSheetForOtherTeam),
          SizedBox(height: 5.h),
        ],
      ),
    ),
    searchMatchFn: (item, searchValue) {
      return item.value.toString().contains(searchValue);
    },
  );
}

Widget buildDivider() {
  return SizedBox(
    width: double.infinity,
    child: Divider(
      color: AppColors.colorPrimaryNeutral,
    ),
  );
}

Widget buildNoTeamFoundTitle(void Function() openModalBottomSheetForOtherTeam) {
  return GestureDetector(
    onTap: openModalBottomSheetForOtherTeam,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Text(AppStrings.bottomSheet_didNotFindTeam_title,
          style: AppTextStyles.subtitle(color: AppColors.colorPrimaryAccent)),
    ),
  );
}

Container buildSearchFormFieldForTeam(TextEditingController searchController) {
  return Container(
    height: 40.h,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.r),
      color: AppColors.colorTertiary,
    ),
    padding: EdgeInsets.all(5.r),
    child: TextFormField(
      expands: true,
      maxLines: null,
      controller: searchController,
      cursorColor: AppWidgetStyles.textFormCursorColor(),
      style: AppTextStyles.textFormFieldELabelStyle(),
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(
          left: 10.w,
          right: 10.w,
          top: 8.h,
        ),

        hintText: AppStrings.profile_createEditAthlete_dropDown_search_hint,
        enabled: true,
        hintStyle: AppTextStyles.textFormFieldEHintStyle(),
        // focusedBorder: AppWidgetStyles.textFormFieldFocusedBorder(),
        // enabledBorder: AppWidgetStyles.textFormFieldEnabledBorder(),
      ),
    ),
  );
}

ButtonStyleData buildButtonStyleData({double? width, Color? color}) {
  return ButtonStyleData(

    width: width ?? Dimensions.getScreenWidth() * 0.3,
    padding: EdgeInsets.symmetric(horizontal: 10.w, ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5.r),
      border: Border.all(
        color:  AppColors.colorPrimaryNeutral,
      ),
      color:color?? AppWidgetStyles.textFormFieldFillColor(),
    ),
  );
}

List<DropdownMenuItem<String>> buildListOfTeamNames(List<Team> teams) {
  final uniqueItems = <String>{};
  var uniqueItemsList = <Team>[];
  uniqueItemsList = teams.where((item) => uniqueItems.add(item.name!)).toList();
  return uniqueItemsList
      .map((item) => DropdownMenuItem<String>(
            value: item.name,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.name!.toLowerCase() == 'other team') ...[
                  Text(
                    item.name!,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5.h),
                  buildDivider()
                ] else ...[
                  Text(
                    item.name!,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ]
              ],
            ),
          ))
      .toList();
}

List<DropdownMenuItem<String>> buildListOfGradeNames(List<GradeData> grades) {
  final uniqueItems = <String>{};
  var uniqueItemsList = <GradeData>[];
  uniqueItemsList =
      grades.where((item) => uniqueItems.add(item.name!)).toList();
  return uniqueItemsList
      .map((item) => DropdownMenuItem<String>(
            value: item.name,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name!,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ))
      .toList();
}
// List<DropdownMenuItem<String>> buildListOfTeamNames(List<Team> teams) {
//
//   final uniqueItems = <String>{};
//   var uniqueItemsList = <Team>[];
//   uniqueItemsList = teams.where((item) => uniqueItems.add(item.name!)).toList();
//   return uniqueItemsList
//       .map((item) => DropdownMenuItem<String>(
//             value: item.name,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (item.id == teams.first.id) ...[
//                   Text(
//                     item.name!,
//                     style: TextStyle(
//                       fontSize: 13.sp,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   buildDivider()
//                 ] else ...[
//                   Text(
//                     item.name!,
//                     style: TextStyle(
//                       fontSize: 13.sp,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   )
//                 ]
//               ],
//             ),
//           ))
//       .toList();
// }

Row buildHint({String? hint}) {
  return Row(
    children: [
      Expanded(
        child: Text(
          hint ?? AppStrings.profile_createEditAthlete_dropDown_label,
          style: AppTextStyles.textFormFieldEHintStyle(),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    ],
  );
}

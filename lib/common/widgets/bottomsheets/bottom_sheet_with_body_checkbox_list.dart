import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/presentation/purchase/widgets/build_registration_limit_view.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';
import '../../../presentation/event_details/widgets/disclaimer.dart';

buildBottomSheetWithBodyCheckboxList(
    {required BuildContext context,
    required String athleteImageUrl,
    required String athleteAge,
    required String athleteWeight,
    List<Styles> styles = const [],
    required String athleteNameAsTheTitle,
    required List<String> listOfStyleTitles,
    required List<String> listOfAllOptions,
    required List<String> listOfAllSelectedOption,
    required List<String> listOfAllRegisteredOptions,
    required int selectedStyleIndex,
    required void Function(int) selectStyle,
    required bool isCheckListForWeightClass,
    required bool isUpdateWCInactive,
    required bool isFromPurchaseHistory,
    required String disclaimer,
    required void Function(int index) onTapToSelectTile,
    required void Function(bool) checkBoxForWeightClassSelection,
    required void Function() onTapForUpdate,
    required bool isLoading,
    List<WeightClass>? weightClass,
    bool? isRegistrationLimitViewVisible,
    bool? isSelectionLogicApplied}) {
  print('-------disclaimer $disclaimer');
  return SingleChildScrollView(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: AppWidgetStyles.buildBoxDecorationForBottomSheet(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: Dimensions.bottomSheetVerticalGap,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.bottomSheetHorizontalGap),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customAthleteImageForBottomSheet(
                  imageUrl: athleteImageUrl,
                  athleteAge: athleteAge,
                  athleteWeight: athleteWeight,
                  athleteNameAsTheTitle: athleteNameAsTheTitle,
                ),
              ],
            ),
          ),
          if (listOfStyleTitles.isNotEmpty)
            customListForStyles(
                isFromPurchaseHistory: isFromPurchaseHistory,
                styles: styles,
                listOfStyleTitles: listOfStyleTitles,
                selectStyle: selectStyle,
                selectedStyleIndex: selectedStyleIndex),
          if (weightClass != null)
            if (isRegistrationLimitViewVisible ?? true)
              if (checkISRegistrationApplied(weightClass))
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildRegistrationLimitView(
                      totalRegistration:
                          checkISBracketSoldOut(weightClass) ? 1 : 0,
                      registrationLimit: 1,
                      isProgressBarVisible: false),
                ),
          if (disclaimer.isNotEmpty)
            ...[Padding(
              padding:  EdgeInsets.symmetric( horizontal: 5.w, vertical: 14.h),
              child: Disclaimer(
                text: disclaimer,
              ),
            ),

            ],
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.bottomSheetHorizontalGap),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (listOfStyleTitles.isEmpty) SizedBox(height: 10.h),
                if (isCheckListForWeightClass)
                  Text(
                    AppStrings.bottomSheet_selectWeightClasses_title,
                    style: AppTextStyles.subtitle(isOutFit: false),
                  ),
                if (!isCheckListForWeightClass)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Text(
                      AppStrings.bottomSheet_selectTiers_title,
                      style: AppTextStyles.bottomSheetSubtitle(isOutfit: true),
                    ),
                  ),
                if (isLoading)
                  SizedBox(
                      height: 100.h,
                      child: CustomLoader(
                        child: Container(),
                      ))
                else
                  listOfWCTilesForBottomSheet(
                      isPurchaseHistory: isFromPurchaseHistory,
                      onTap: onTapToSelectTile,
                      listOfSelectedOptions: listOfAllSelectedOption,
                      context: context,
                      listOfAllOptions: listOfAllOptions,
                      listOfAllRegisteredOptions: listOfAllRegisteredOptions,
                      weightClass: weightClass != null
                          ? sortWeightClassByOrder(
                              weightClass: weightClass ?? [],
                              orderList: listOfAllOptions)
                          : null,
                      isSelectionLogicApplied: isSelectionLogicApplied),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.bottomSheetHorizontalGap),
            child: buildCustomLargeFooterBtn(
                hasKeyBoardOpened: false,
                onTap: isUpdateWCInactive ? () {} : onTapForUpdate,
                isActive: !isUpdateWCInactive,
                btnLabel: AppStrings.btn_update,
                isColorFilledButton: true),
          ),
          SizedBox(
            height: (Platform.isIOS ? 2.5 : 1) * Dimensions.generalGapSmall,
          ),
        ],
      ),
    ),
  );
}

Widget buildStyleTitle() {
  return Text(
    AppStrings.bottomSheet_selectStyle_title,
    style: AppTextStyles.subtitle(isOutFit: false),
  );
}

bool checkISRegistrationApplied(List<WeightClass> weightClasses) {
  return weightClasses.any((e) => e.maxRegistration != null);
}

bool checkISBracketSoldOut(List<WeightClass> weightClasses) {
  return weightClasses.every((element) =>
      element.maxRegistration != null &&
      element.totalRegistration != null &&
      element.totalRegistration! >= element.maxRegistration!);
}

List<WeightClass> sortWeightClassByOrder(
    {required List<String> orderList, required List<WeightClass> weightClass}) {
  // Create a map to find the index of each weight in the orderList
  Map<String, int> weightIndexMap = {
    for (int i = 0; i < orderList.length; i++) orderList[i]: i
  };

  // Sort the weightClass based on the order in orderList
  weightClass.sort((a, b) {
    int indexA = weightIndexMap[a.weight ?? ""] ??
        -1; // Default to -1 if weight is not found
    int indexB = weightIndexMap[b.weight ?? ""] ?? -1;
    return indexA.compareTo(indexB);
  });

  return weightClass;
}

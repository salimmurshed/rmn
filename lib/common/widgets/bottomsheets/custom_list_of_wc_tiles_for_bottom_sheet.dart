import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/response_models/available_weight_class_response_model.dart';
import '../../../imports/common.dart';

Widget listOfWCTilesForBottomSheet(
    {required BuildContext context,
    required void Function(int index) onTap,
    required List<String> listOfAllRegisteredOptions,
    required List<String> listOfSelectedOptions,
    required List<String> listOfAllOptions,
    List<WeightClass>? weightClass,
    required bool isPurchaseHistory, bool? isSelectionLogicApplied}) {
  return Container(
    margin: EdgeInsets.symmetric(
      vertical: Dimensions.bottomSheetBodyWidgetVerticalGap,
    ),
    constraints: BoxConstraints(
      maxHeight: Dimensions.getScreenHeight() * 0.35,
    ),

    child: ListView.separated(
      separatorBuilder: (context, index) => SizedBox(
        height: Dimensions.bottomSheetBodyWidgetVerticalGap,
      ),
      shrinkWrap: true,
      itemCount: listOfAllOptions.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: isDisabled(
                  listOfAllRegisteredWeights: listOfAllRegisteredOptions,
                  weight: listOfAllOptions[index])
              ? () {}
              : () {
            debugPrint('isSelectionLogicApplied: ${weightClass?[index].maxRegistration}');
            debugPrint('isSelectionLogicApplied: ${weightClass?[index].totalRegistration}');

                  if (weightClass?[index].maxRegistration != null) {
                    if (weightClass![index].totalRegistration! <
                        weightClass[index].maxRegistration! &&  weightClass[index].maxRegistration! != 0) {
                      onTap(index);
                    }
                  } else {
                    onTap(index);
                  }
                },
          child: Opacity(
            opacity: AppWidgetStyles.bottomSheetOpacityValue(
                isDisabled: listOfAllRegisteredOptions
                    .contains(listOfAllOptions[index])),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
              ),
              decoration: AppWidgetStyles.buildBoxDecorationForWCTiles(isSoldOut: (weightClass?[index].totalRegistration ?? 0) >= (weightClass?[index].maxRegistration ?? double.infinity)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (isPurchaseHistory)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        listOfAllRegisteredOptions
                                .contains(listOfAllOptions[index])
                            ? '${listOfAllOptions[index]}  lbs (Scanned)'
                            : listOfAllOptions[index],
                        style: AppTextStyles.buttonTitle(),
                      ),
                    ),
                  if (!isPurchaseHistory)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        listOfAllOptions[index],
                        style: AppTextStyles.buttonTitle(),
                      ),
                    ),
                  const Spacer(),
                  if (weightClass != null)...[
                    if (weightClass[index].maxRegistration != null)
                      if (weightClass[index].totalRegistration! >= weightClass[index].maxRegistration! && !isChecked(
                          listOfSelectedWeights: listOfSelectedOptions,
                          listOfAllRegisteredWeights: listOfAllRegisteredOptions,
                          weight: listOfAllOptions[index]))...[
                        Text(
                          AppStrings.event_registration_limitation_sold_out_title,
                          style: AppTextStyles.smallTitle(
                            color: AppColors.colorPrimaryInverseText,
                            fontSize: 16.sp,
                            isBold: true,
                          ),
                        ),
                        SizedBox(width: 8.w,)
                      ],
                    if (weightClass[index].maxRegistration != null)
                      Text(
                        '${weightClass[index].totalRegistration ?? ''}/',
                        style: AppTextStyles.smallTitle(
                          color: AppColors.colorPrimaryInverseText,
                          fontSize: 14.sp,
                          isBold: false,
                        ),
                      ),
                    Text(
                      weightClass[index].maxRegistration?.toString() ?? '',
                      style: AppTextStyles.smallTitle(
                        color: AppColors.colorPrimaryInverseText,
                        fontSize: 16.sp,
                        isBold: true,
                      ),
                    ),
                  ],
                  const SizedBox(width: 8),
                  if (weightClass?[index].maxRegistration == null)
                    buildCustomCheckbox(
                      onChanged: (value) {
                        isDisabled(
                                listOfAllRegisteredWeights:
                                    listOfAllRegisteredOptions,
                                weight: listOfAllOptions[index])
                            ? () {}
                            : onTap(index);
                      },
                      isDisabled: isDisabled(
                          listOfAllRegisteredWeights: listOfAllRegisteredOptions,
                          weight: listOfAllOptions[index]),
                      isChecked: isChecked(
                          listOfSelectedWeights: listOfSelectedOptions,
                          listOfAllRegisteredWeights: listOfAllRegisteredOptions,
                          weight: listOfAllOptions[index]),
                    )
                  else
                    if (weightClass?[index].maxRegistration != null)
                      if (weightClass![index].totalRegistration! < weightClass[index].maxRegistration! ||  isChecked(
                          listOfSelectedWeights: listOfSelectedOptions,
                          listOfAllRegisteredWeights: listOfAllRegisteredOptions,
                          weight: listOfAllOptions[index]))
                        buildCustomCheckbox(
                          onChanged: (value) {
                            isDisabled(
                                listOfAllRegisteredWeights:
                                listOfAllRegisteredOptions,
                                weight: listOfAllOptions[index])
                                ? () {}
                                : onTap(index);
                          },
                          isDisabled: isDisabled(
                              listOfAllRegisteredWeights: listOfAllRegisteredOptions,
                              weight: listOfAllOptions[index]),
                          isChecked: isChecked(
                              listOfSelectedWeights: listOfSelectedOptions,
                              listOfAllRegisteredWeights: listOfAllRegisteredOptions,
                              weight: listOfAllOptions[index]),
                        ),

                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

bool isChecked(
    {required List<String> listOfSelectedWeights,
    required List<String> listOfAllRegisteredWeights,
    required String weight}) {
  return listOfSelectedWeights.contains(weight) ||
      listOfAllRegisteredWeights.contains(weight);
}

bool isDisabled(
    {required List<String> listOfAllRegisteredWeights,
    required String weight}) {
  return listOfAllRegisteredWeights.contains(weight);
}

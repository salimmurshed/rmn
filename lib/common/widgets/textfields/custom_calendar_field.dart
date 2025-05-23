import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';

Widget buildCustomCalendarWithOrWithoutWeightField({
  required TextEditingController calendarField,
  required FocusNode calendarFocusNode,
  TextEditingController? weightField,
  FocusNode? weightFocusNode,
  required String calendarLabel,
  required String calendarHint,
  String? dateErrorText,
  bool isStaff = false,
  required bool calendarIsAsteriskPresent,
  required Widget calendarSuffixIcon,
  required bool isWithWeightInARow,
  required void Function() onTapToOpenCalendar,
  String? Function(String?)? calendarValidator,
  String? Function(String?)? onFieldSubmitted,
  void Function(String?)? onChangedCalendar,
  void Function(String?)? onChangedWeight,
  String? Function(String?)? weightValidator,
}) {

  return isWithWeightInARow && weightField != null && weightFocusNode != null
      ? buildForAthleteCalendarAndWeight(
      dateErrorText: dateErrorText,
      calendarSuffixIcon: calendarSuffixIcon,
      onTapToOpenCalendar: onTapToOpenCalendar,
      onChanged: onChangedCalendar,
      isStaff: isStaff,
      calendarValidator: calendarValidator,
      calendarField: calendarField,
      calendarFocusNode: calendarFocusNode,
      weightValidator: weightValidator,
      weightField: weightField,onChangedWeight: onChangedWeight,
      weightFocusNode: weightFocusNode)
      : CustomTextFormFields(
    onTap: onTapToOpenCalendar,
    validator: calendarValidator,
    errorText: dateErrorText,
    onChanged: onChangedCalendar,
    onFieldSubmitted: onFieldSubmitted,
    isReadOnly: true,
    textInputType: TextInputType.text,
    textEditingController: calendarField,
    focusNode: calendarFocusNode,
    label: AppStrings.textfield_selectDateOfBirth_label,
    hint: AppStrings.textfield_selectDateOfBirth_hint,
    isAsteriskPresent: true,
    suffixIcon: calendarSuffixIcon,
  );
}

Row buildForAthleteCalendarAndWeight(
    {String? dateErrorText,
      required Widget calendarSuffixIcon,
      void Function(String?)? onChanged,
      bool isStaff=false,
      required void Function() onTapToOpenCalendar,
      String? Function(String?)? calendarValidator,
      required TextEditingController calendarField,
      required FocusNode calendarFocusNode,
      String? Function(String?)? weightValidator,
      void Function(String?)? onChangedWeight,
      required TextEditingController weightField,
      required FocusNode weightFocusNode}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: CustomTextFormFields(
          errorText: dateErrorText,
          onChanged: onChanged,
          onTap: onTapToOpenCalendar,
          isReadOnly: true,
          validator: calendarValidator,
          textInputType: TextInputType.text,
          textEditingController: calendarField,
          focusNode: calendarFocusNode,
          label: AppStrings.textfield_selectDateOfBirth_label,
          hint: AppStrings.textfield_selectDateOfBirth_hint,
          isAsteriskPresent: true,
          suffixIcon: calendarSuffixIcon,
        ),
      ),
      SizedBox(width: Dimensions.generalGap),
      Expanded(
        child: CustomTextFormFields(
          validator: weightValidator,
          textInputType: TextInputType.number,
          maxLength: 3,
          textEditingController: weightField,
          focusNode: weightFocusNode,
          label: isStaff? 'Exact Weight': AppStrings.textfield_addBodyWeight_label,
          hint: isStaff ? 'Exact weight': AppStrings.textfield_addBodyWeight_hint,
          isAsteriskPresent: true,
          onChanged: onChangedWeight,
          suffixIcon: Padding(
            padding: EdgeInsets.all(Dimensions.textFormFieldBorderRadius),
            child: SvgPicture.asset(
              AppAssets.icWeightUnit,
            ),
          ),
        ),
      ),
    ],
  );
}

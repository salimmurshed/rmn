import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:google_places_autocomplete_text_field/model/prediction.dart';

import '../../../imports/app_configurations.dart';
import '../../../imports/common.dart';

Column buildCustomGooglePlacesTextFormField(
    {required String? Function(String?)? validator,
    required TextEditingController textEditingController,
    required void Function(String) onChanged,
    required void Function(Prediction) itmClick}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      buildCustomLabel(
          label: AppStrings.textfield_addAddress_label,
          isAsteriskPresent: true),
      GooglePlacesAutoCompleteTextFormField(
          maxLines: 1,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textEditingController: textEditingController,
          googleAPIKey: AppEnvironments.googlePlacesAPIKey,
          onChanged: onChanged,
          debounceTime: 400,
          // defaults to 600 ms
          countries: const ["us"],enableSuggestions: true,
          // optional, by default the list is empty (no restrictions)
          isLatLngRequired: true,
          overlayContainer: (child) => Material(
                elevation: 1.0,
                color: AppColors.colorTertiary,
                borderRadius:
                    BorderRadius.circular(Dimensions.textFormFieldBorderRadius),
                child: child,
              ),
          style: AppTextStyles.textFormFieldELabelStyle(),
          validator: validator,
          getPlaceDetailWithLatLng: (Prediction prediction) async {},
          decoration: InputDecoration(
            contentPadding:
            EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 8.w),
            counterText: AppStrings.global_empty_string,
            hintText: AppStrings.textfield_addAddress_hint,
            hintMaxLines: 1,
            errorMaxLines: 2,
            hintStyle: AppTextStyles.textFormFieldEHintStyle(isDisabled: false),
            fillColor: AppWidgetStyles.textFormFieldFillColor(),
            focusColor: AppWidgetStyles.textFormFieldFocusColor(),
            filled: true,
            errorStyle: AppTextStyles.textFormFieldErrorStyle(),
            enabledBorder:
                AppWidgetStyles.textFormFieldEnabledBorder(isDisabled: false),
            focusedBorder:
                AppWidgetStyles.textFormFieldFocusedBorder(isReadOnly: false),
            errorBorder: AppWidgetStyles.textFormFieldErrorBorder(),
            focusedErrorBorder:
                AppWidgetStyles.textFormFieldFocusedErrorBorder(),
          ),
          // if you require the coordinates from the place details/ this callback is called when isLatLngRequired is true
          itmClick: itmClick),
    ],
  );
}

import 'package:country_code_picker_plus/country_code_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';

Widget buildCustomPhoneField(
    {required bool isContactNumberValid,
    required TextEditingController phoneNumberController,
    required FocusNode phoneNumberFocusNode,
    required BuildContext context,
    String? contactNumberError,
    required void Function(String?) onChanged,
    String? Function(String?)? validator}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      buildCustomLabel(
          label: AppStrings.textfield_addContactNumber_label,
          isAsteriskPresent: true),
      SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            Container(
              height: 39.3.h,
              margin: EdgeInsets.only(
                right: 10.w,
                bottom: isContactNumberValid ? 0 : 16.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.colorSecondary,
                border: Border.all(color: AppColors.colorTertiary, width: 1),
                borderRadius:
                    BorderRadius.circular(Dimensions.textFormFieldBorderRadius),
              ),
              child: CountryCodePicker(
                countryFilter: const ['US'],
                onChanged: (country) {
                  // setState(() {
                  //   _selectedCountryCode1 = country.dialCode ?? '';
                  // });
                },
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                ),
                initialSelection: 'US',
                textStyle: AppTextStyles.textFormFieldEHintStyle(),
                favorite: const ['+1'],
                enabled: false,
                showFlag: true,
                showDropDownButton: false,
              ),
            ),
            Expanded(
              flex: 2,
              child: CustomTextFormFields(
                onChanged: onChanged,
                errorText: contactNumberError,
                textEditingController: phoneNumberController,
                focusNode: phoneNumberFocusNode,
                label: AppStrings.global_empty_string,
                hint: AppStrings.textfield_addContactNumber_hint,
                textInputType: TextInputType.phone,
                validator: validator,
              ),
            )
          ],
        ),
      ),
    ],
  );
}
// Widget buildCustomPhoneField(
//     {required BuildContext context,
//     required TextEditingController phoneController,
//     String? Function(String?)? validator,
//     void Function(String)? onChanged,
//     required String label,
//     required bool isInvalid,
//     required bool isAsteriskPresent,
//     required String hint,
//     required FocusNode focusNode}) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       buildCustomLabel(label: label, isAsteriskPresent: isAsteriskPresent),
//       Row(
//         children: [
//           Container(
//             height: 45.h,
//             margin: isInvalid ?EdgeInsets.only(bottom: 20.h): null ,
//             width: Dimensions.getScreenWidth() * 0.15,
//             decoration: BoxDecoration(
//                 borderRadius:
//                     BorderRadius.circular(Dimensions.textFormFieldBorderRadius),
//                 color: AppColors.colorSecondary),
//             alignment: Alignment.center,
//             child: Text(
//               '+1',
//               style: AppTextStyles.normalPrimary(
//                 color: AppColors.colorPrimaryInverse,
//               ),
//             ),
//           ),
//           SizedBox(
//             width: 10.w,
//           ),
//           SizedBox(
//             width: Dimensions.getScreenWidth() * 0.7,
//             child: TextFormField(
//               enableSuggestions: true,
//               autofocus: false,
//               cursorColor: AppWidgetStyles.textFormCursorColor(),
//               enabled: true,
//               autovalidateMode: AutovalidateMode.onUserInteraction,
//               controller: phoneController,
//               focusNode: focusNode,
//               validator: validator,
//               onChanged: onChanged,
//               keyboardType: TextInputType.phone,
//               textInputAction: TextInputAction.next,
//               style: AppTextStyles.textFormFieldELabelStyle(),
//               decoration: InputDecoration(
//                 hintText: hint,
//                 hintStyle: AppTextStyles.textFormFieldEHintStyle(),
//                 fillColor: AppWidgetStyles.textFormFieldFillColor(),
//                 focusColor: AppWidgetStyles.textFormFieldFocusColor(),
//                 filled: true,
//                 errorStyle: AppTextStyles.textFormFieldErrorStyle(),
//                 enabledBorder: AppWidgetStyles.textFormFieldEnabledBorder(),
//                 focusedBorder: AppWidgetStyles.textFormFieldFocusedBorder(),
//                 errorBorder: AppWidgetStyles.textFormFieldErrorBorder(),
//                 focusedErrorBorder:
//                     AppWidgetStyles.textFormFieldFocusedErrorBorder(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ],
//   );
// }

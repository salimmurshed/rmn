// // import 'dart:async';
// //
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// //
// // import '../../../imports/common.dart';
// // import '../../../presentation/authentication/otp/bloc/otp_bloc.dart';
// //
// // SizedBox buildCustomPinField(
// //     {required BuildContext context,
// //     required List<TextEditingController> pinControllers,
// //     required int index,
// //     required bool isFailure,
// //     required bool isFromChangeEmail,
// //     required String encryptedUserId,
// //     required List<FocusNode> focusNodes}) {
// //
// //   return SizedBox(
// //     width: Dimensions.textFormFieldForPinWidth,
// //     height: Dimensions.textFormFieldForPinHeight,
// //     child: Center(
// //       child:  TextFormField(
// //         autofocus: true,
// //         textAlign: TextAlign.center,
// //         keyboardType: const TextInputType.
// //         numberWithOptions(
// //             signed: false, decimal: false),
// //         inputFormatters: <TextInputFormatter>[
// //           FilteringTextInputFormatter.digitsOnly, // Allow only digits
// //         ],
// //         cursorColor: AppWidgetStyles.textFormCursorColor(),
// //         style: AppTextStyles.regularPrimary(),
// //         onChanged: (value) {
// //           if (value.length == 1) {
// //             FocusScope.of(context).nextFocus();
// //           }
// //           else if (value.length == 2) {
// //             // Apply substring based on cursor position
// //             pinControllers[index].text = value.substring(1);
// //             if (index == 5) {
// //               FocusScope.of(context).unfocus();
// //             } else {
// //               FocusScope.of(context).nextFocus();
// //             }
// //           }
// //           else {
// //             FocusScope.of(context).previousFocus();
// //           }
// //           if(index == 5) {
// //             BlocProvider.of<OtpBloc>(context).add(TriggerOtpLengthVerification(
// //               isFromChangeEmail: isFromChangeEmail,
// //               encryptedUserId: encryptedUserId,
// //             ));
// //           }
// //         },
// //         onTap: () {
// //           if (focusNodes[index].hasFocus && index > 0) {
// //             FocusScope.of(context).requestFocus(focusNodes[index - 1]);
// //           }
// //           pinControllers[index].selection = TextSelection.collapsed(
// //               offset: pinControllers[index].text.length);
// //         },
// //         controller: pinControllers[index],
// //         focusNode: focusNodes[index],
// //         maxLength: 2,
// //         decoration: InputDecoration(
// //           errorStyle: const TextStyle(height: 0),
// //           contentPadding: EdgeInsets.only(
// //               bottom: Dimensions.textFormFieldForPinContentPaddingVertical,
// //               left: Dimensions.textFormFieldForPinContentPaddingHorizontal),
// //           counterText: AppStrings.global_empty_string,
// //           enabledBorder: AppWidgetStyles.textFormFieldEnabledBorder(
// //             color: isFailure ? AppColors.colorError : null,
// //           ),
// //           focusedBorder: AppWidgetStyles.textFormFieldFocusedBorder(),
// //           errorBorder: AppWidgetStyles.textFormFieldErrorBorder(),
// //           focusedErrorBorder: AppWidgetStyles.textFormFieldFocusedErrorBorder(),
// //           focusColor: AppWidgetStyles.textFormFieldFocusColor(),
// //           fillColor: AppWidgetStyles.textFormFieldFillColor(),
// //           filled: true,
// //         ),
// //       ),
// //     ),
// //   );
// // }
//
//
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../imports/common.dart';
import '../../../presentation/authentication/otp/bloc/otp_bloc.dart';

class CustomPinField extends StatefulWidget {
  final List<TextEditingController> pinControllers;
  final int index;
  final bool isFailure;
  final bool isFromChangeEmail;
  final String encryptedUserId;
  final List<FocusNode> focusNodes;

  const CustomPinField({
    super.key,
    required this.pinControllers,
    required this.index,
    required this.isFailure,
    required this.isFromChangeEmail,
    required this.encryptedUserId,
    required this.focusNodes,
  });

  @override
  _CustomPinFieldState createState() => _CustomPinFieldState();
}

class _CustomPinFieldState extends State<CustomPinField> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (widget.index == 0) {
        FocusScope.of(context).requestFocus(widget.focusNodes[widget.index]);
       }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimensions.textFormFieldForPinWidth,
      height: Dimensions.textFormFieldForPinHeight,
      child: Center(
        child: TextFormField(
          autofocus: false,textInputAction: TextInputAction.next,
          textAlign: TextAlign.center,
          keyboardType: const TextInputType.numberWithOptions(
              signed: false, decimal: false),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly, // Allow only digits
          ],
          cursorColor: AppWidgetStyles.textFormCursorColor(),
          style: AppTextStyles.regularPrimary(),
          onChanged: (value) {
           if (value.length == 1) {
             FocusScope.of(context).nextFocus();
            }
            else if (value.length == 2) {
              // Apply substring based on cursor position
              widget.pinControllers[widget.index].text = value.substring(1);
              if (widget.index == 5) {
                FocusScope.of(context).unfocus();
              } else {
                FocusScope.of(context).nextFocus();
              }
            } else {
              FocusScope.of(context).previousFocus();
            }
            if (widget.index == 5) {
              BlocProvider.of<OtpBloc>(context).add(TriggerOtpLengthVerification(
                isFromChangeEmail: widget.isFromChangeEmail,
                encryptedUserId: widget.encryptedUserId,
              ));
            }
          },
          onTap: () {
            if (widget.focusNodes[widget.index].hasFocus && widget.index > 0) {
              FocusScope.of(context).requestFocus(widget.focusNodes[widget.index - 1]);
            }
            widget.pinControllers[widget.index].selection = TextSelection.collapsed(
                offset: widget.pinControllers[widget.index].text.length);
          },
          controller: widget.pinControllers[widget.index],
          focusNode: widget.focusNodes[widget.index],
          maxLength: 2,
          decoration: InputDecoration(
            errorStyle: const TextStyle(height: 0),
            contentPadding: EdgeInsets.only(
                bottom: Dimensions.textFormFieldForPinContentPaddingVertical,
                left: Dimensions.textFormFieldForPinContentPaddingHorizontal),
            counterText: AppStrings.global_empty_string,
            enabledBorder: AppWidgetStyles.textFormFieldEnabledBorder(
              color: widget.isFailure ? AppColors.colorError : AppColors.colorTertiary,
            ),
            focusedBorder: AppWidgetStyles.textFormFieldFocusedBorder(),
            errorBorder: AppWidgetStyles.textFormFieldErrorBorder(),
            focusedErrorBorder: AppWidgetStyles.textFormFieldFocusedErrorBorder(),
            focusColor: AppWidgetStyles.textFormFieldFocusColor(),
            fillColor: AppWidgetStyles.textFormFieldFillColor(),
            filled: true,
          ),
        ),
      ),
    );
  }
}



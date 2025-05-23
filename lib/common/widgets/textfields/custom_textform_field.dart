import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';

class CustomTextFormFields extends StatefulWidget {
  CustomTextFormFields({
    super.key,
    required this.textEditingController,
    this.focusNode,
    this.inputFormatters,
    required this.label,
    required this.hint,
    this.maxLength,
    this.formKey,
    this.prefixIcon,
    this.isReadOnly = false,
    this.errorText,
    this.isEnabled = true,
    this.autoFillHints,
    this.isAsteriskPresent = true,
    this.onTap,
    this.validator,
    this.suffixIcon,
    this.isObscure = false,
    this.onChanged,
    this.contentPadding,
    this.isDisabled = false,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.hintMaxLines = 2,
    required this.textInputType,
    this.maxLines,
    this.minLines,
  });

  final TextEditingController textEditingController;
  final FocusNode? focusNode;
  final String label;
  final String hint;
  final bool isReadOnly;
  final bool isDisabled;
  final bool isEnabled;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;
  final bool isObscure;
  List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? contentPadding;
  void Function()? onEditingComplete;
  final int? hintMaxLines;
  TextInputAction textInputAction;
  final TextInputType textInputType;
  final bool isAsteriskPresent;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  String? errorText;
  final Iterable<String>? autoFillHints;
  final Widget? prefixIcon;
  final void Function(String)? onFieldSubmitted;
  GlobalKey<FormState>? formKey;

  @override
  State<CustomTextFormFields> createState() => _CustomTextFormFieldsState();
}

class _CustomTextFormFieldsState extends State<CustomTextFormFields> {
  @override
  Widget build(BuildContext context) {
    // print('CustomTextFormFields ${widget.errorText}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label.isNotEmpty)
          buildCustomLabel(
              label: widget.label, isAsteriskPresent: widget.isAsteriskPresent),
        TextFormField(
          key: widget.formKey,
          obscureText: widget.isObscure,
          autofillHints: widget.autoFillHints,
          enableSuggestions: true,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          autofocus: false,
          maxLines: widget.maxLines ?? (widget.maxLength == 500 ? 10 :
          widget.maxLength == 250? 5:
          1),
minLines: widget.minLines,
          maxLength: widget.maxLength,
          cursorColor: AppWidgetStyles.textFormCursorColor(),
          readOnly: widget.isReadOnly,
          enabled: widget.isEnabled,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: widget.textEditingController,
          focusNode: widget.focusNode,
          onTap: widget.onTap,
          validator: widget.validator,
          keyboardType: widget.textInputType,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onFieldSubmitted,
          onEditingComplete: widget.onEditingComplete,
          style: widget.isDisabled
              ? AppTextStyles.textFormFieldEHintStyle(
                  isDisabled: widget.isDisabled)
              : AppTextStyles.textFormFieldELabelStyle(),
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            counterText: AppStrings.global_empty_string,
            hintText: widget.hint,
            errorText: widget.errorText,
            hintMaxLines: widget.hintMaxLines ?? 2,
            errorMaxLines: 3,
            hintStyle: AppTextStyles.textFormFieldEHintStyle(
                isDisabled: widget.isDisabled),
            fillColor: AppWidgetStyles.textFormFieldFillColor(),
            focusColor: AppWidgetStyles.textFormFieldFocusColor(),
            filled: true,
            contentPadding: widget.contentPadding ??
                EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 8.w),
            errorStyle: AppTextStyles.textFormFieldErrorStyle(),
            enabledBorder: AppWidgetStyles.textFormFieldEnabledBorder(
                isDisabled: widget.isDisabled),
            focusedBorder: AppWidgetStyles.textFormFieldFocusedBorder(
                isReadOnly: widget.isDisabled),
            errorBorder: AppWidgetStyles.textFormFieldErrorBorder(),
            focusedErrorBorder:
                AppWidgetStyles.textFormFieldFocusedErrorBorder(),
            suffixIcon: widget.suffixIcon,
          ),
        ),
      ],
    );
  }
}

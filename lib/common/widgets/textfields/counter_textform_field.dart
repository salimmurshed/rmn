import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';

class CounterTextFormField extends StatefulWidget {
  CounterTextFormField({
    super.key,
    required this.textEditingController,
    required this.focusNode,
    this.label,
    this.isAsteriskPresent = false,
    required this.onChanged,
    required this.maxLength, required this.hint,
  });

  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final String hint;
  String? label;
  bool isAsteriskPresent;
  final int maxLength;
  void Function(String) onChanged;

  @override
  State<CounterTextFormField> createState() => _CounterTextFormFieldState();
}

class _CounterTextFormFieldState extends State<CounterTextFormField> {
  int typedCharacters = 0;
  double bottomGap = 6.h;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomTextFormFields(
          textEditingController: widget.textEditingController,
          focusNode: widget.focusNode,
          label: widget.label ?? AppStrings.global_empty_string,
          onChanged: (value) {
            widget.onChanged(value);
            setState(() {
              typedCharacters = value.length;
            });
            if(value.isEmpty){
              setState(() {
                bottomGap = 22.h;
              });
            }else{
              setState(() {
                bottomGap = 6.h;
              });
            }
          },
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          isAsteriskPresent: false,
          hint: widget.hint,
          maxLength: widget.maxLength,
          validator: (value) {
            return value!.isEmpty
                ? AppStrings.textfield_addMessage_emptyField_error
                : null;
          },
          textInputType: TextInputType.multiline,
        ),
        Positioned(
          right: 10.w,
          bottom: bottomGap,
          child: Text(
            '$typedCharacters/${widget.maxLength}',
            style: AppTextStyles.textFormFieldEHintStyle(),
          ),
        ),
      ],
    );
  }
}

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../../imports/common.dart';

DropdownButtonHideUnderline buildVariantDropDownForSmallSpace({
  required GlobalKey<State<StatefulWidget>> dropDownKey,
  required List<String> variants,
  required String? selectedValue,
  required void Function(String?)? onChanged,
  void Function(bool)? onMenuStateChange,
  required bool isOpen,
  required BuildContext context,
  double? width,
  double? height,
  Color? color
}) {
  return DropdownButtonHideUnderline(
    child: DropdownButton2<String>(
      key: dropDownKey,
      isExpanded: true,
      hint: buildHint(hint: AppStrings.global_select_a_variant),
      items: customDropDownMenuItems(
        items: variants,
      ),
      selectedItemBuilder: (BuildContext context) {
        return variants
            .map((item) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item,
                      style: AppTextStyles.textFormFieldELabelStyle(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ))
            .toList();
      },
      style: AppTextStyles.textFormFieldELabelStyle(),
      value: selectedValue,
      onChanged: onChanged,
      buttonStyleData: buildButtonStyleData(width: width, color: color),
      onMenuStateChange: onMenuStateChange,
      iconStyleData: IconStyleData(
        icon: Icon(
          isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        ),
        iconSize: 20,
        iconEnabledColor: Colors.white,
        iconDisabledColor: Colors.grey,
      ),
      dropdownStyleData: buildDropdownStyleData(context),
      menuItemStyleData: buildMenuItemStyleData(height: height),
    ),
  );
}

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/data/models/response_models/event_details_response_model.dart';
import 'package:rmnevents/presentation/home/staff_home_bloc/staff_home_bloc.dart';

import '../../../imports/common.dart';

class EventsDropDown extends StatefulWidget {
  const EventsDropDown({super.key, required this.eventNames, required this.onSelected});
  final void Function(String) onSelected;

  final List<String> eventNames;
  @override
  State<EventsDropDown> createState() => _EventsDropDownState();
}

class _EventsDropDownState extends State<EventsDropDown> {
  bool isOpen = false;
  String? selectedValue;

  GlobalKey<State<StatefulWidget>> dropDownKey = GlobalKey<State<StatefulWidget>>();

  @override
  initState() {
    super.initState();
    EventData? eventData = context.read<StaffHomeBloc>().state.eventData;
    selectedValue = eventData?.title;
  }
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        key: dropDownKey,
        isExpanded: true,
        hint: buildHint(
          hint: 'Select Event',
        ),
        style: AppTextStyles.textFormFieldELabelStyle(),
        items: widget.eventNames.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        value: selectedValue,
        onChanged: (v){
          widget.onSelected(v!);
          setState(() {
            selectedValue = v;
          });
        },
        buttonStyleData:  ButtonStyleData(
          padding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: Dimensions.generalGapSmall,
          ),
          decoration: BoxDecoration(
            color: AppColors.colorPrimary,
            borderRadius: BorderRadius.circular(
                Dimensions.textFormFieldBorderRadius),
            border: Border.all(
              color: AppColors.colorPrimary,
            ),
          ),
        ),
        selectedItemBuilder: (BuildContext context) {
          return  widget.eventNames
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
        //This to clear the search value when you close the menu
        onMenuStateChange: (isOpen) {

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
        dropdownStyleData:  DropdownStyleData(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: AppColors.colorSecondary,
          ),
          offset: Offset(0, 5.h),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: WidgetStateProperty.all<double>(6),
            thumbVisibility: WidgetStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: buildMenuItemStyleData(),
      ),
    );
  }
}

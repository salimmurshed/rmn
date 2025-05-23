import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';

SizedBox customBuildSearchAndFilterButton({
  required void Function() searchFunction,
  required void Function() eraserFunction,
  required void Function(String) onChangeSearchFunction,
  required void Function() filterOnFunction,
  required bool isFilterOn,
  required TextEditingController searchController,
  required FocusNode focusNode,
  required bool showEraser,
  required GlobalKey<FormState> formKey,
  required bool isFilterAvailable,
}) {
  return SizedBox(
    width: Dimensions.getScreenWidth(),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: buildCustomEventSearchField(
              formKey: formKey,
              searchController: searchController,
              showEraser: showEraser,
              focusNode: focusNode,
              eraserFunction: eraserFunction,
              onChangeSearchFunction: onChangeSearchFunction,
              searchFunction: searchFunction),
        ),
        if (isFilterAvailable) ...[
          SizedBox(
            width: 10.w,
          ),
          customEventFilterButton(
              isFilterOn: isFilterOn, filterOnFunction: filterOnFunction),
        ]
      ],
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';

Widget customListForStyles(
    {required List<Styles> styles,
    required List<String> listOfStyleTitles,
required bool isFromPurchaseHistory,
    required void Function(int) selectStyle,
    required int selectedStyleIndex}) {
  return Padding(
    padding: EdgeInsets.only(
      left: Dimensions.bottomSheetHorizontalGap,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h,),
        if (!isFromPurchaseHistory) buildStyleTitle(),
        SizedBox(
          height: 40.h,
          child: ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) => SizedBox(
              width: Dimensions.bottomSheetHorizontalGap,
            ),
            itemCount: listOfStyleTitles.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding:  EdgeInsets.symmetric(vertical: 5.h),
                child: buildCustomTabButton(
                  isWithCounter: true,
                  counter: styles[index].temporarilySelectedWeights!.length.toString(),
                  onTap: (){
                    selectStyle(index);
                  },
                  btnLabel: listOfStyleTitles[index],
                  tabButtonType: selectedStyleIndex == index
                      ? TabButtonType.selected
                      : TabButtonType.unselected,
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

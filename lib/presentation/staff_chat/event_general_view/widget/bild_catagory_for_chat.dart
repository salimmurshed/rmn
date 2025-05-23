

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/imports/common.dart';

class ChatTypeView extends StatefulWidget {
  final List<ChatType> categories;
  final int selectedCatagory;
  final num unreadCount;
  final num archivedCount;
  final Function(ChatType selectedCategory) onTabSelected;
  const ChatTypeView({super.key, required this.categories, required this.onTabSelected, required this.selectedCatagory, required this.unreadCount, required this.archivedCount});

  @override
  _ChatTypeViewState createState() => _ChatTypeViewState();
}

class _ChatTypeViewState extends State<ChatTypeView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          // Convert enum to string for display
          String categoryName = widget.categories[index].toString().split('.').last;

          return GestureDetector(
            onTap: () {
              widget.onTabSelected(widget.categories[index]);
            },
            child: Container(
              width: 80.w,
              decoration: BoxDecoration(
                color: index == widget.selectedCatagory ? AppColors.colorSecondaryAccent : Colors.transparent, // Highlight selected tab
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(
                  color: AppColors.colorPrimaryInverse,
                  width: 1.w,
                ),
              ),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      categoryName,
                      style:  AppTextStyles.landingTitle(fontSize: AppFontSizes.regular, fontWeight: AppFontWeight.titleLargeWeightedSquada)
                    ),
                    if(index != 0)...[
                      if ((index == 1 && widget.unreadCount > 0) || (index != 1 && widget.archivedCount > 0))...[
                        SizedBox(width: 4.w,),
                        Container(
                          height: 15.h,
                          width: 15.h,
                          decoration: BoxDecoration(
                              color: index == widget.selectedCatagory ? AppColors.colorPrimaryInverse : AppColors.colorSecondaryAccent,
                              shape: BoxShape.circle
                          ),
                          child: Center(child: Text(index == 1 ? widget.unreadCount.toString() : widget.archivedCount.toString(),style: AppTextStyles.componentLabels(isNormal: false,isOutFit: false, color: index == widget.selectedCatagory ? AppColors.colorSecondaryAccent : AppColors.colorPrimaryInverse),)),
                        )
                      ]
                    ]
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(width: 12.w); // Space between items
        },
        itemCount: widget.categories.length,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


List<DropdownMenuItem<String>> customDropDownMenuItems(
    {required List<String> items}) {

  return items.map((item) => DropdownMenuItem<String>(
    value: item,
    child: Text(
      item,
      maxLines: 1,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      overflow: TextOverflow.ellipsis,
    ),
  ))
      .toList();
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';

Column buildLoaderForTabSelection(BuildContext context) {
  return Column(
    children: [
      SizedBox(
        height: Dimensions.getScreenHeight() * 0.18,
      ),
      Center(
        child: SizedBox(
            height: 50.h,
            width: 50.w,
            child: CustomLoader(child: Container())),
      ),
    ],
  );
}
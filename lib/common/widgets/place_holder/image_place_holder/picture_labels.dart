import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../imports/common.dart';

Container pictureLabels({required SizeType sizeType, required Widget child}) {
  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: sizeType == SizeType.large
          ? 5.w
          : 3.w
    ),
    child: child,
  );
}

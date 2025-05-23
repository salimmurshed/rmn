import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../imports/common.dart';

Padding buildBracketChatButton({
  required bool isLoading,
  required void Function()? onTap,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(5.r), // Applies rounded corners
      child: Padding(
        padding: const EdgeInsets.only(right: 18.0),
        child: Container(
          height: 35.h,
          decoration: BoxDecoration(
            color: AppColors.colorSecondaryAccent,
            borderRadius: BorderRadius.circular(5.r), // Ensure rounding applies
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: IntrinsicWidth(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.colorPrimaryInverse,
                  borderRadius: BorderRadius.circular(5.r), // Apply here too!
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.r), // Also apply to button
                    ),
                  ),
                  onPressed: onTap,
                  child: Text(
                    ' Bracket chat ',
                    style: AppTextStyles.buttonTitle(
                      color: AppColors.colorSecondaryAccent,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}


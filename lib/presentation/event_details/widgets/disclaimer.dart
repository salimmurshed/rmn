import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';

class Disclaimer extends StatelessWidget {
  const Disclaimer({super.key, required this.text});

  final String text;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding:  EdgeInsets.all(2.r),

            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD700), Colors.transparent],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              padding:  EdgeInsets.only(top: 16.h,bottom:10.h, left: 5.w, right: 5.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.colorPrimary,
                    AppColors.colorPrimary,
                    AppColors.colorSecondary,
                    AppColors.colorTertiary
                  ],
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: RichText(
                text:  TextSpan(
                  style: AppTextStyles.regularPrimary(),
                  children: [
                    TextSpan(
                        text: text
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -12,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700),
                borderRadius: BorderRadius.circular(200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: Colors.black,
                    size: 20,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Eligibility Confirmation',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

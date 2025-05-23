import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({
    super.key,
    required this.confirm,
  });

  final void Function() confirm;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        borderRadius: BorderRadius.circular(5.r),
        color: AppColors.colorSecondaryAccent,
        child: InkWell(
          onTap: confirm,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
            ),
            width: Dimensions.getScreenWidth() * 0.43,
            child: Center(
              child: Text(
                AppStrings.btn_confirm,
                style: AppTextStyles.buttonTitle(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
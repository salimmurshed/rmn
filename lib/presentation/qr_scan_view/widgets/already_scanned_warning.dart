
import 'package:flutter/material.dart';


import '../../../imports/common.dart';
class AlreadyScannedWarning extends StatelessWidget {
  const AlreadyScannedWarning({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.getScreenHeight() * 0.06),
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Text(
            AppStrings.qrCode_popUp_alreadyScanned_status,
            style:
            AppTextStyles.smallTitle(color: AppColors.colorPrimaryAccent),
          ),
        ),
      ),
    );
  }
}
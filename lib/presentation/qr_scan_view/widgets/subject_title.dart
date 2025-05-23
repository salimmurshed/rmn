import 'package:flutter/material.dart';


import '../../../imports/common.dart';
class SubjectTitle extends StatelessWidget {
  const SubjectTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          AppStrings.qrCode_popUp_subjectDetails_title,
          style: AppTextStyles.regularPrimary(isOutFit: false),
        ),
      ),
    );
  }
}

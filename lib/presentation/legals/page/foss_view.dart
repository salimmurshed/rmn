import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';
import '../widgets/foss_item_widget.dart';
import '../../../oss_licenses.dart';

class FossView extends StatelessWidget {
  const FossView({super.key});

  @override
  Widget build(BuildContext context) {
    return customScaffold(
      hasForm: false,
      customAppBar: CustomAppBar(
        title: AppStrings.accountSettings_menu_legals_foss_title,
        isLeadingPresent: true,
      ),
      formOrColumnInsideSingleChildScrollView: null,
      anyWidgetWithoutSingleChildScrollView: ListView.separated(
          itemBuilder: (context, index) {
            return FossItemWidget(
                title: '${dependencies[index].name} ${dependencies[index].version}',
                licence: dependencies[index].license ??
                    AppStrings.global_empty_string,
                description: dependencies[index].description ,
            );
          },
          separatorBuilder: (context, index) =>
              SizedBox(height: 5.h,),
          itemCount: dependencies.length),
    );
  }
}

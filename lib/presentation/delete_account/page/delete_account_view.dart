import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rmnevents/presentation/delete_account/bloc/delete_bloc.dart';

import '../../../imports/common.dart';

class DeleteAccountView extends StatelessWidget {
  const DeleteAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteBloc, DeleteAccountWithInitialState>(
      listener: (context, state) {
        if (state.message.isNotEmpty) {
          buildCustomToast(msg: state.message, isFailure: state.isFailure);
        }
      },
      child: BlocBuilder<DeleteBloc, DeleteAccountWithInitialState>(
        builder: (context, state) {
          return customScaffold(
            hasForm: false,
            formOrColumnInsideSingleChildScrollView: null,
            persistentFooterButtons: [
              buildTwinButtons(
                  onLeftTap: () {
                    BlocProvider.of<DeleteBloc>(context)
                        .add(TriggerDeleteAccountEvent());

                  },
                  onRightTap: () {
                    Navigator.pop(context);
                  },
                  leftBtnLabel: AppStrings.btn_delete,
                  rightBtnLabel: AppStrings.btn_goBack,
                  isActive: true)
            ],
            customAppBar: CustomAppBar(
              title: AppStrings.deleteAccount_title,
              isLeadingPresent: true,
            ),
            anyWidgetWithoutSingleChildScrollView: state.isLoading ? CustomLoader(child: buildDeleteAccountLayout()):buildDeleteAccountLayout(),
          );
        },
      ),
    );
  }

  Padding buildDeleteAccountLayout() {
    return Padding(
      padding: EdgeInsets.all(12.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppAssets.icDeleteAccount,
            height: 100.h,
            width: 100.w,
            fit: BoxFit.cover,
          ),
          Text(
           AppStrings.deleteAccount_warningText_title,
            textAlign: TextAlign.center,
            style: AppTextStyles.largeTitle(),
          ),
          customDivider(),
          SizedBox(height: Dimensions.generalGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppAssets.icDanger,
                height: 20.h,
                width: 20.w,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 5.w),
              Text(AppStrings.deleteAccount_warningText_subtitle,
                  style: AppTextStyles.smallTitle(isOutFit: false)),
            ],
          ),
          SizedBox(height: Dimensions.generalGapSmall),
          Text(
             AppStrings.deleteAccount_warningText_body,
            style: AppTextStyles.normalPrimary(),
          )
        ],
      ),
    );
  }
}

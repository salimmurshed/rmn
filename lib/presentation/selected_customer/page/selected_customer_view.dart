import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../imports/common.dart';
import '../../home/staff_home_bloc/staff_home_bloc.dart';
import '../bloc/selected_customer_bloc.dart';

class SelectedCustomerView extends StatefulWidget {
  const SelectedCustomerView({super.key});

  @override
  State<SelectedCustomerView> createState() => _SelectedCustomerViewState();
}

class _SelectedCustomerViewState extends State<SelectedCustomerView> {
  @override
  void initState() {
    BlocProvider.of<SelectedCustomerBloc>(context)
        .add(TriggerFetchSelectedCustomer());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedCustomerBloc, SelectedCustomerState>(
      builder: (context, state) {

        return customScaffold(
            customAppBar: CustomAppBar(
              title: AppStrings.global_empty_string,
              isLeadingPresent: true,
              widgetTitle: buildAppBarTitle(state),
              goBack: (){

                BlocProvider.of<SelectedCustomerBloc>(context).add(TriggerReset());
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            hasForm: false,
            formOrColumnInsideSingleChildScrollView: null,
            anyWidgetWithoutSingleChildScrollView: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15.h,
                ),
                Text("Actions",
                    style: AppTextStyles.smallTitle(isOutFit: false)),
                SizedBox(
                  height: 10.h,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRouteNames.routeCustomerPurchases,
                        );
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          color: AppColors.colorSecondary),
                      margin: EdgeInsets.symmetric(vertical: 5.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      child: Row(
                        children: [
                          SvgPicture.asset(AppAssets.icProfile,
                              height: 20.h, width: 20.w, fit: BoxFit.cover),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text("Customer's Purchases",
                              style: AppTextStyles.smallTitle()),
                          const Spacer(),
                        ],
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    if(state.eventData != null  ){
                      if(context.read<StaffHomeBloc>().state.readerData != null) {
                        Navigator.pushNamed(
                            context, AppRouteNames.routeRegisterNSell,
                            arguments: state.eventData);
                      }else{
                        buildCustomToast(msg: AppStrings.selectedCustomer_readerAbsent_text, isFailure: true);
                      }
                    }
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          color: AppColors.colorSecondary),
                      margin: EdgeInsets.symmetric(vertical: 5.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      child: Row(
                        children: [
                          SvgPicture.asset(AppAssets.icCart,
                              height: 20.h, width: 20.w, fit: BoxFit.cover),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text("Purchase Products/Registrations",
                              style: AppTextStyles.smallTitle()),
                          const Spacer(),
                        ],
                      )),
                )
              ],
            ));
      },
    );
  }

  Container buildAppBarTitle(SelectedCustomerState state) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.appBarToolVerticalGap),
      width: Dimensions.getScreenWidth(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                color: AppColors.colorPrimary,
                height: 40.h,
                width: 42.w,
                child: state.customer != null
                    ? CachedNetworkImage(
                        imageUrl: state.customer!.profile!,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                      )
                    : SvgPicture.asset(
                        AppAssets.icProfileAvatar,
                        height: 40.h,
                        width: 40.w,
                        fit: BoxFit.cover,
                      ),
              )),
          SizedBox(
            width: 10.w,
          ),
          Container(
            width: Dimensions.getScreenWidth() * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        StringManipulation.combineFirstNameWithLastName(
                          firstName: state.customer?.firstName ??
                              AppStrings.global_empty_string,
                          lastName: state.customer?.lastName ??
                              AppStrings.global_empty_string,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.regularPrimary(isOutFit: false),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        state.customer?.email ?? AppStrings.global_empty_user,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            AppTextStyles.regularNeutralOrAccented(isOutfit: true),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          if (state.customer != null) ...[
            if (state.customer!.accountType == AccountType.facebook.name)
              Image.asset(
                AppAssets.imgFacebook,
                height: 30.h,
                width: 30.w,
              ),
            if (state.customer!.accountType == AccountType.google.name)
              Image.asset(
                AppAssets.imgGoogle,
                height: 30.h,
                width: 30.w,
              ),
            if (state.customer!.accountType == AccountType.apple.name)
              Image.asset(
                AppAssets.imgApple,
                height: 30.h,
                width: 30.w,
              )
          ],
        ],
      ),
    );
  }
}

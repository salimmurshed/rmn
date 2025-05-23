import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/widgets/cards/custom_info_card.dart';
import '../../../imports/common.dart';
import '../bloc/my_purchases_bloc.dart';

List<Widget> buildSeasonPasses(MyPurchasesWithInitialState state) {
  return [
    if (state.seasons.isNotEmpty) ...[
      SizedBox(
        height: 30.h,
        width: double.infinity,
        child: ListView.separated(
            padding: EdgeInsets.only(left: 3.w),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i) {
              return IntrinsicWidth(
                child: GestureDetector(
                  onTap: () {
                    BlocProvider.of<MyPurchasesBloc>(context)
                        .add(TriggerSelectSeason(indexOfSelectedSeason: i));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                        color: state.indexOfSelectedSeason == i
                            ? AppColors.colorSecondaryAccent
                            : AppColors.colorTertiary,
                        borderRadius: BorderRadius.circular(5.r)),
                    child: Center(
                      child: Text(
                        state.seasons[i].season!.title!,
                        style: AppTextStyles.regularPrimary(isOutFit: false),
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, i) {
              return SizedBox(
                width: 10.h,
              );
            },
            itemCount: state.seasons.length),
      ),
      Flexible(
          child: ListView.separated(
              padding: EdgeInsets.only(top: 20.h),
              itemBuilder: (context, i) {
                return CustomInfoCard(
                  price: state.seasons[state.indexOfSelectedSeason]
                      .memberships![i].price!,
                  firstName: state.seasons[state.indexOfSelectedSeason]
                      .memberships![i].athlete!.firstName!,
                  lastName: state.seasons[state.indexOfSelectedSeason]
                      .memberships![i].athlete!.lastName!,
                  age: state.seasons[state.indexOfSelectedSeason]
                      .memberships![i].athlete!.age
                      .toString(),
                  weight: state.seasons[state.indexOfSelectedSeason]
                      .memberships![i].athlete!.weight
                      .toString(),
                  imageUrl: state.seasons[state.indexOfSelectedSeason]
                      .memberships![i].athlete!.profileImage!,
                  infoCardType: InfoCardType.seasonPasses,
                  isLoading: state.seasons[state.indexOfSelectedSeason]
                      .memberships![i].isDownloading!,
                  metric1: state.seasons[state.indexOfSelectedSeason]
                      .memberships![i].product!.title!,
                  metric2: state.seasons[state.indexOfSelectedSeason]
                      .memberships![i].purchaseDate!,
                  infoCardOnTap: () {
                    BlocProvider.of<MyPurchasesBloc>(context).add(
                        TriggerDownloadSingleInvoice(
                            isIndividualInvoiceDownload: true,
                            individualInvoiceIndex: i,
                            orderNo: state.seasons[state.indexOfSelectedSeason]
                                .memberships![i].orderNo!,
                            invoiceUrl: state
                                .seasons[state.indexOfSelectedSeason]
                                .memberships![i]
                                .invoiceUrl!));
                  },
                );

              },
              separatorBuilder: (context, i) {
                return SizedBox(
                  height: 10.h,
                );
              },
              itemCount: state
                  .seasons[state.indexOfSelectedSeason].memberships!.length))
    ] else ...[
      Container(
        margin:
            EdgeInsets.symmetric(horizontal: Dimensions.getScreenWidth() * 0.2),
        width: Dimensions.getScreenWidth() * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: Dimensions.getScreenHeight() * 0.3,
            ),
            Center(
              child: Text(AppStrings.myPurchases_noSeasonPasses_text,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.smallTitle()),
            ),
          ],
        ),
      ),
    ]
  ];
}

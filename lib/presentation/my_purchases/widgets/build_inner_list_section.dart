import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rmnevents/common/widgets/buttons/invoice_button.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';

SizedBox buildInnerListSection({
  required List<Memberships> memberships,
  required void Function(int minIndex) onTap,
  required int individualInvoiceIndex,
  required int groupInvoiceIndex,
  required int itemIndex,
}) {
  return SizedBox(
    height: memberships.length > 4 ? 200.h : null,
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: memberships.length,
      itemBuilder: (context, miniIndex) {
        return Container(
          height: 80.h,
          margin: EdgeInsets.only(bottom: 10.h),
          decoration: BoxDecoration(
              color: AppColors.colorSecondary,
              borderRadius:
                  BorderRadius.circular(Dimensions.generalSmallRadius)),
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
          child: Row(
            children: [
              buildCustomAthleteProfileHolder(
                  imageUrl: memberships[miniIndex].athlete!.profileImage!,
                  age: memberships[miniIndex].athlete!.age.toString(),
                  weight: memberships[miniIndex].athlete!.weight.toString()),
              Container(
                padding: EdgeInsets.only(left: 10.w),
                width: Dimensions.getScreenWidth() * 0.45,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            StringManipulation.combineFirstNameWithLastName(
                                firstName:
                                    memberships[miniIndex].athlete!.firstName!,
                                lastName:
                                    memberships[miniIndex].athlete!.lastName!),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.smallTitle(),
                          ),
                        ),
                      ],
                    ),
                    buildDateAndMembershipInfo(
                        value: memberships[miniIndex].purchaseDate!,
                        isDate: true),
                    buildDateAndMembershipInfo(
                        value: memberships[miniIndex].product!.title!,
                        isDate: false),
                  ],
                ),
              ),
              const Spacer(),
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      StringManipulation.addADollarSign(
                          price: memberships[miniIndex].price!),
                      style: AppTextStyles.smallTitle(),
                    ),
                    SizedBox(height: 8.h),
                    buildInvoiceButton(context: context,
                          onTap: () {
                            onTap(miniIndex);
                          },
                        isLoading:   groupInvoiceIndex == itemIndex &&
                            miniIndex == individualInvoiceIndex)
                    // GestureDetector(

                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(
                    //           Dimensions.generalSmallRadius,
                    //         ),
                    //         color: AppColors.colorPrimaryAccent),
                    //     padding: EdgeInsets.all(10.r),
                    //     child: Center(
                    //       child: groupInvoiceIndex == itemIndex &&
                    //               miniIndex == individualInvoiceIndex
                    //           ? SizedBox(
                    //               height: 15.h,
                    //               width: 16.w,
                    //               child: CircularProgressIndicator(
                    //                 valueColor: AlwaysStoppedAnimation<Color>(
                    //                     AppColors.colorPrimaryNeutralText),
                    //               ),
                    //             )
                    //           : SvgPicture.asset(
                    //               fit: BoxFit.cover,
                    //               AppAssets.icDownloadInvoice),
                    //     ),
                    //   ),
                    // )
                  ])
            ],
          ),
        );
      },
    ),
  );
}

Row buildDateAndMembershipInfo({required String value, required bool isDate}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SvgPicture.asset(
          colorFilter:
              ColorFilter.mode(AppColors.colorPrimaryAccent, BlendMode.srcIn),
          height: 12.h,
          isDate ? AppAssets.icCart : AppAssets.icMembership),
      Container(
        margin: EdgeInsets.only(left: 4.w),
        child: Text(
          value,
          overflow: TextOverflow.ellipsis,
            style: AppTextStyles.normalNeutral(isSquada: true),
        ),
      ),
    ],
  );
}

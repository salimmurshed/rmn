import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rmnevents/common/widgets/dialog/base_show_dialog.dart';

import '../../../imports/common.dart';
import '../../../presentation/base/bloc/base_bloc.dart';

Container buildSummaryCard(
    {required String couponCode,
    required void Function() removeCoupon,
    required void Function() applyCoupon,
    required void Function() checkApplyButtonActivity,
    required TextEditingController couponEditingController,
    required FocusNode couponNode,
    required String couponAmount,
    required String transactionFee,
    required num totalWithTransactionWithoutCouponFee,
    required num totalWithTransactionWithCouponFee,
    required bool isApplyButtonActive,
    required String error}) {
  return Container(
    margin: EdgeInsets.only(bottom: 15.h),
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
    decoration: BoxDecoration(
        color: AppColors.colorSecondary,
        borderRadius: BorderRadius.circular(3.r)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 8.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 2.h),
                child: Text(
                  AppStrings.purchase_tab_summary_title,
                  style: AppTextStyles.largeTitle(),
                ),
              ),
            ],
          ),
        ),
        if (couponCode.isEmpty)
          buildCouponField(
            isApplyButtonActive: isApplyButtonActive,
            couponEditingController: couponEditingController,
            couponNode: couponNode,
            applyCoupon: applyCoupon,
            checkApplyButtonActivity: checkApplyButtonActivity,
          ),
        if (error.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 5.h),
                child: Text(
                  error,
                  style: AppTextStyles.textFormFieldErrorStyle(),
                ),
              ),
            ],
          ),
        if (couponCode.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 5.h),
                child: Text(
                  'Coupon Applied',
                  style: AppTextStyles.smallTitle(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets.icCouponApplied,
                        width: 15.w,
                        height: 15.h,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        couponCode,
                        style: AppTextStyles.subtitle(
                            color: AppColors.colorPrimaryNeutralText,
                            isOutFit: true),
                      ),
                    ],
                  ),
                  buildBtn(
                      onTap: removeCoupon,
                      btnLabel: 'Remove',
                      isColorFilledButton: false,
                      isActive: true),
                  // GestureDetector(
                  //   onTap: removeCoupon,
                  //   child: Text(
                  //     'Remove',
                  //     style: AppTextStyles.smallTitle(
                  //         color: AppColors.colorPrimaryAccent, isOutFit: false),
                  //   ),
                  // ),
                ],
              )
            ],
          ),
        SizedBox(height: 10.h),
        buildSummaryCardDivider(),
        if (couponCode.isNotEmpty)
          buildOtherCharges(
            title: 'Coupon',
            appliedCharge: couponAmount,
            result: couponCode,
          ),
        buildOtherCharges(
          title: 'Transaction Fee',
          appliedCharge: transactionFee,
          result: '$globalTransactionFee%',
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: AppTextStyles.largeTitle(),
                ),
                Text(
                  StringManipulation.addADollarSign(
                      price: totalWithTransactionWithoutCouponFee),
                  style: AppTextStyles.largeTitle(
                      isLinedThrough: couponCode.isNotEmpty,
                      color: couponCode.isNotEmpty
                          ? AppColors.colorPrimaryInverseText
                          : AppColors.colorPrimaryAccent),
                )
              ],
            ),
            if (couponCode.isNotEmpty)
              Text(
                StringManipulation.addADollarSign(
                    price: totalWithTransactionWithCouponFee),
                style: AppTextStyles.largeTitle(
                    color: AppColors.colorPrimaryAccent),
              )
          ],
        ),
      ],
    ),
  );
}

Row buildCouponField({
  required bool isApplyButtonActive,
  required TextEditingController couponEditingController,
  required FocusNode couponNode,
  required void Function() applyCoupon,
  required void Function() checkApplyButtonActivity,
}) {
  return Row(
    children: [
      Flexible(
        child: CustomTextFormFields(
          onChanged: (value) {
            checkApplyButtonActivity();
          },
          textEditingController: couponEditingController,
          focusNode: couponNode,
          hint: AppStrings.textfield_addCouponCode_hint,
          label: AppStrings.global_empty_string,
          textInputType: TextInputType.emailAddress,
        ),
      ),
      GestureDetector(
        onTap: isApplyButtonActive ? applyCoupon : () {},
        child: Container(
          width: 80.w,
          margin: EdgeInsets.only(left: 10.w),
          height: 40.h,
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.r),
              color: isApplyButtonActive
                  ? AppColors.colorSecondaryAccent
                  : AppColors.colorBlueOpaque),
          child: Center(
            child: Text(
              AppStrings.btn_apply,
              style: AppTextStyles.smallTitle(),
            ),
          ),
        ),
      )
    ],
  );
}

Row buildOtherCharges(
    {required String title,
    required String result,
    required String appliedCharge}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      SizedBox(
        width: Dimensions.getScreenWidth() * 0.35,
        child: Text(
          title,
          style: AppTextStyles.smallTitle(),
        ),
      ),
      Text(
        result,
        style: AppTextStyles.subtitle(
            color: AppColors.colorPrimaryNeutralText, isOutFit: true),
      ),
      SizedBox(
        width: Dimensions.getScreenWidth() * 0.35,
        child: Text(
          appliedCharge,
          textAlign: TextAlign.end,
          style: AppTextStyles.smallTitle(),
        ),
      )
    ],
  );
}

Divider buildSummaryCardDivider() {
  return Divider(
    color: AppColors.colorPrimaryNeutral,
    thickness: 0.2,
  );
}

Column buildSummaryItem(
    {required String type,
    String tierName = '',
    String max = '',
    required String itemName,
    required String division,
    required String style,
    required String itemPrice,
    required String itemQuantity,
    required String itemTotalPrice,
    required num? itemReducedTotalPrice,
    required num nominator,
    required num denominator,
    required bool hasDialog}) {
  return Column(
    children: [
      Container(
        margin: EdgeInsets.only(bottom: 5.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (style.isEmpty && division.isEmpty) ...[
                  SizedBox(
                    width: Dimensions.getScreenWidth() * 0.3,
                    child: Text(
                      itemName,
                      style: AppTextStyles.subtitle(
                        isOutFit: false,
                        color: AppColors.colorPrimaryInverseText,
                      ),
                    ),
                  )
                ] else ...[
                  SizedBox(
                    width: Dimensions.getScreenWidth() * 0.3,
                    child: RichText(
                      text: TextSpan(
                        text: '$type\n',
                        style: AppTextStyles.subtitle(
                          isOutFit: false,
                          color: AppColors.colorPrimaryNeutralText,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: itemName,
                            style: AppTextStyles.subtitle(
                              isOutFit: false,
                            ),
                          ),
                          TextSpan(
                            text: ' ($division/$style)',
                            style: AppTextStyles.subtitle(isOutFit: false),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
                if (hasDialog) ...[
                  GestureDetector(
                    onTap: () {
                      showDialogForAthleteSeasonPass(
                          nominator, denominator, tierName, int.parse(max));
                    },
                    child: Container(
                        width: 50.w,
                        margin: EdgeInsets.only(right: 20.w),
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 2.h),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.colorPrimaryNeutralText,
                                width: 1),
                            color: AppColors.colorPrimary,
                            borderRadius: BorderRadius.circular(5.r)),
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                              text: nominator.toString(),
                              style: AppTextStyles.subtitle(
                                  isOutFit: false,
                                  color: nominator > denominator
                                      ? AppColors.colorPrimaryAccent
                                      : AppColors.colorPrimaryInverseText),
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' / $denominator',
                                  style:
                                      AppTextStyles.subtitle(isOutFit: false),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),
                ] else ...[
                  Container(
                      width: 50.w,
                      margin: EdgeInsets.only(right: 20.w),
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(5.r)),
                      child: Container()),
                ]
              ],
            ),
            SizedBox(
              width: Dimensions.getScreenWidth() * 0.2,
              child: Text(
                itemPrice,
                style: AppTextStyles.subtitle(isOutFit: false),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: Dimensions.getScreenWidth() * 0.06,
                  child: Text(
                    itemQuantity,
                    style: AppTextStyles.subtitle(
                        color: AppColors.colorPrimaryAccent, isOutFit: false),
                  ),
                ),
                Column(
                  children: [
                    if (nominator <= denominator)
                      Container(
                        alignment: Alignment.topRight,
                        width: Dimensions.getScreenWidth() * 0.13,
                        child: Text(
                          itemTotalPrice,
                          style: AppTextStyles.subtitle(
                              isOutFit: false,
                              isLinedThrough: itemReducedTotalPrice != null),
                        ),
                      ),
                    if (nominator > denominator && denominator != 0)
                      Container(
                        alignment: Alignment.topRight,
                        width: Dimensions.getScreenWidth() * 0.13,
                        child: Text(
                          itemTotalPrice,
                          style: AppTextStyles.subtitle(
                              isOutFit: false,
                              isLinedThrough: itemReducedTotalPrice != null),
                        ),
                      ),
                    if (itemReducedTotalPrice != null)
                      Container(
                        alignment: Alignment.topRight,
                        width: Dimensions.getScreenWidth() * 0.13,
                        child: Text(
                          StringManipulation.addADollarSign(
                              price: itemReducedTotalPrice),
                          style: AppTextStyles.subtitle(isOutFit: false),
                        ),
                      )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    ],
  );
}

showDialogForAthleteSeasonPass(
    num nominator, num denominator, String tierName, int max) {
  buildBaseShowDialog(

      //     For this specific registration we
      // will deduct <registrationsAmountOfThisRow>
      // of <remainingRegisrationsOfSeasonPassBeforeThisRow>.
      title: Text('Season Pass Info',
          textAlign: TextAlign.center, style: AppTextStyles.smallTitle()),
      body: (nominator == denominator || nominator < denominator)
          ? buildDialogForNonZeroDenominator(
              tierName: tierName,
              max: max,
              usedUpAmount: max - denominator, //(6-3)
              toBeUsedAmount: nominator, //(3-(6-6))
              remainingAmount: max - (max - denominator))//(6-(6-6))
          : (nominator > denominator && denominator != 0)
              ? buildDialogForNonZeroDenominator(
                  tierName: tierName,
                  max: max,
                  usedUpAmount: max - denominator,
                  toBeUsedAmount: max - (max - denominator),
                  remainingAmount: max - (max - denominator))
              : (denominator == 0)
                  ? buildDialogForZeroDenominator(tierName, max)
                  : Container(),
      isDivider: true);
}

Column buildDialogForZeroDenominator(String tierName, int max) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          text: 'The Season Pass',
          style: AppTextStyles.regularNeutralOrAccented(
              color: AppColors.colorPrimaryNeutral),
          children: <TextSpan>[
            TextSpan(
              text: ' $tierName ',
              style: AppTextStyles.regularNeutralOrAccented(
                  color: AppColors.colorPrimaryInverseText),
            ),
          ],
        ),
      ),
      RichText(
        text: TextSpan(
          text: 'grants a total of ',
          style: AppTextStyles.regularNeutralOrAccented(
              color: AppColors.colorPrimaryNeutral),
          children: <TextSpan>[
            TextSpan(
              text: ' $max ',
              style: AppTextStyles.regularNeutralOrAccented(
                  color: AppColors.colorPrimaryInverseText),
            ),
            //The season pass <name>  grants <number> free registration(s) for this event.
            // You have <number> free registration(s) remaining for this event.  <Number> will be used for this purchase.
            TextSpan(
              text: ' free registration(s) in total (this and other events).\n',
              style: AppTextStyles.regularNeutralOrAccented(
                  color: AppColors.colorPrimaryNeutral),
            ),
          ],
        ),
      ),
      RichText(
        text: TextSpan(
          text:
              'You have already used (in this or previous registrations) all your ',
          style: AppTextStyles.regularNeutralOrAccented(
              color: AppColors.colorPrimaryNeutral),
          children: <TextSpan>[
            TextSpan(
              text: ' $max ',
              style: AppTextStyles.regularNeutralOrAccented(
                  color: AppColors.colorPrimaryInverseText),
            ),
            //The season pass <name>  grants <number> free registration(s) for this event.
            // You have <number> free registration(s) remaining for this event.  <Number> will be used for this purchase.
            TextSpan(
              text: 'free registrations.',
              style: AppTextStyles.regularNeutralOrAccented(
                  color: AppColors.colorPrimaryNeutral),
            ),
          ],
        ),
      ),
    ],
  );
}

Column buildDialogForNonZeroDenominator(
    {required String tierName,
    required num max,
    required num usedUpAmount,
    required num toBeUsedAmount,
    required num remainingAmount}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          text: 'The Season Pass',
          style: AppTextStyles.regularNeutralOrAccented(
              color: AppColors.colorPrimaryNeutral),
          children: <TextSpan>[
            TextSpan(
              text: ' $tierName ',
              style: AppTextStyles.regularNeutralOrAccented(
                  color: AppColors.colorPrimaryInverseText),
            ),
          ],
        ),
      ),
      RichText(
        text: TextSpan(
          text: 'grants a total of ',
          style: AppTextStyles.regularNeutralOrAccented(
              color: AppColors.colorPrimaryNeutral),
          children: <TextSpan>[
            TextSpan(
              text: ' $max ',
              style: AppTextStyles.regularNeutralOrAccented(
                  color: AppColors.colorPrimaryInverseText),
            ),
            //The season pass <name>  grants <number> free registration(s) for this event.
            // You have <number> free registration(s) remaining for this event.  <Number> will be used for this purchase.
            TextSpan(
              text: ' free registration(s) in total (this and other events).\n',
              style: AppTextStyles.regularNeutralOrAccented(
                  color: AppColors.colorPrimaryNeutral),
            ),
          ],
        ),
      ),
      RichText(
        text: TextSpan(
          text: 'You have already used ',
          style: AppTextStyles.regularNeutralOrAccented(
              color: AppColors.colorPrimaryNeutralText),
          children: <TextSpan>[
            TextSpan(
              text: '$usedUpAmount ',
              style: AppTextStyles.regularNeutralOrAccented(
                  color: AppColors.colorPrimaryInverseText),
            ),
            TextSpan(
              text: ' (in this or previous registrations).\n',
              style: AppTextStyles.regularNeutralOrAccented(
                  color: AppColors.colorPrimaryNeutralText),
            ),
          ],
        ),
      ),
      RichText(
        text: TextSpan(
          text: 'With this registration(s) we will use ',
          style: AppTextStyles.regularNeutralOrAccented(
              color: AppColors.colorPrimaryNeutral),
          children: <TextSpan>[
            TextSpan(
              text: ' $toBeUsedAmount ',
              style: AppTextStyles.regularNeutralOrAccented(
                  color: AppColors.colorPrimaryInverseText),
            ),
            TextSpan(
              text: 'of your ',
              style: AppTextStyles.regularNeutralOrAccented(
                  color: AppColors.colorPrimaryNeutral),
            ),
            TextSpan(
              text: ' $remainingAmount ',
              style: AppTextStyles.regularNeutralOrAccented(
                  color: AppColors.colorPrimaryInverseText),
            ),
            TextSpan(
              text: 'remaining free registrations.',
              style: AppTextStyles.regularNeutralOrAccented(
                  color: AppColors.colorPrimaryNeutral),
            ),
          ],
        ),
      ),
    ],
  );
}

Column buildSummaryCardSubtotalSection(
    {required String subTotal, required String? newSubTotal}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Sub Total',
            style: AppTextStyles.smallTitle(),
          ),
          Text(
            subTotal,
            style: AppTextStyles.smallTitle(
                isLinedThrough: newSubTotal != null,
                color: newSubTotal == null
                    ? AppColors.colorPrimaryAccent
                    : AppColors.colorPrimaryInverse),
          )
        ],
      ),
      if (newSubTotal != null)
        Text(
          newSubTotal,
          style: AppTextStyles.smallTitle(color: AppColors.colorPrimaryAccent),
        ),
    ],
  );
}

Container buildSummaryCardHeader(
    {required String title, required bool isEditActive, required void Function() edit}) {
  return Container(
    margin: EdgeInsets.only(bottom: 10.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 3.h),
          child: Text(
            title,
            style: AppTextStyles.largeTitle(),
          ),
        ),
        GestureDetector(
          onTap: edit,
          child: Text(
            AppStrings.btn_edit,
            style:
                AppTextStyles.smallTitle(color: isEditActive ?AppColors.colorPrimaryAccent: AppColors.colorRedOpaque),
          ),
        )
      ],
    ),
  );
}

ListView buildSummaryListViewBuilder(
    {required Widget? Function(BuildContext, int) itemBuilder,
    required int itemCount}) {
  return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: itemBuilder,
      itemCount: itemCount);
}

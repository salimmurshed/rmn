import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rmnevents/presentation/register_and_sell/bloc/register_and_sell_bloc.dart';

import '../../../imports/common.dart';

void showPaymentSuccessDialog({
  required BuildContext context,
  required String paymentDate,
  required String paymentMethod,
  required String brand,
  required String soldBy,
  required num amount,
  required isLoading,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        child: BackdropFilter(
          blendMode: BlendMode.srcOver,
          filter: ImageFilter.blur(sigmaX: 200.w, sigmaY: 200.h),
          child: GestureDetector(
            onTap: () {
              // Navigator.of(context).pop();
            },
            child: BlocBuilder<RegisterAndSellBloc, RegisterAndSellState>(
              builder: (context, state) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: state.isLoadingPdf
                      ? CustomLoader(
                          isForSingleWidget: true,
                          topMarginHeight: Dimensions.getScreenHeight() * 0.3,
                          isTopMarginNeeded: true,
                          child: buildLayout(paymentDate, paymentMethod, brand,
                              soldBy, amount, context))
                      : buildLayout(paymentDate, paymentMethod, brand, soldBy,
                          amount, context),
                );
              },
            ),
          ),
        ),
      );
    },
  );
}

Column buildLayout(String paymentDate, String paymentMethod, String brand,
    String soldBy, num amount, BuildContext context) {
  return Column(
    children: [
      const Spacer(),
      Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              // color: Colors.black,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: SvgPicture.asset(
              AppAssets.icPaymentDialog,
              height: 320.h,
            ),
          ),
          Positioned(
            top: 150.h,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              width: Dimensions.getScreenWidth() * 0.8,
              height: 20.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Purchased Date',
                      style: AppTextStyles.normalNeutral(isSquada: true, fonstSize: AppFontSizes.regular)),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Text(paymentDate,
                        style: AppTextStyles.normalPrimary(isOutfit: false, fontSize: AppFontSizes.regular)),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 190.h,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              width: Dimensions.getScreenWidth() * 0.8,
              height: 20.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Payment Method',
                      style: AppTextStyles.normalNeutral(isSquada: true, fonstSize: AppFontSizes.regular)),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Row(
                      children: [
                        Image.asset(paymentMethod == 'amazon_pay'
                            ? AppAssets.imgAmazon
                            : paymentMethod == 'paypal'
                            ? AppAssets.imgPaypal
                            : paymentMethod == 'apple_pay'
                            ? AppAssets.imgApay
                            : paymentMethod == 'google_pay'
                            ? AppAssets.imgGpay
                            : paymentMethod == 'visa'
                            ? AppAssets.imgVisa
                            : AppAssets.imgMastercard),
                        SizedBox(width: 4.w),
                        Text(brand.isNotEmpty ? brand : paymentMethod,
                            style: AppTextStyles.normalPrimary(isOutfit: false, fontSize: AppFontSizes.regular)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 230.h,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              width: Dimensions.getScreenWidth() * 0.8,
              height: 20.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sold by',
                      style: AppTextStyles.normalNeutral(isSquada: true, fonstSize:  AppFontSizes.regular)),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Text(soldBy,
                        style: AppTextStyles.normalPrimary(isOutfit: false, fontSize:  AppFontSizes.regular)),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 272.h,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              width: Dimensions.getScreenWidth() * 0.8,
              height: 20.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Amount',
                      style: AppTextStyles.subtitle(
                          isOutFit: false,
                          color: AppColors.colorPrimaryNeutralText)),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Text(StringManipulation.addADollarSign(price: amount),
                        style: AppTextStyles.smallTitle(
                            color: AppColors.colorPrimaryAccent)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      const Spacer(),
         ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: Container(
            height: 35.h,
            width: Dimensions.getScreenWidth() / 1,
            decoration: BoxDecoration(
              color: AppColors.colorSecondaryAccent,
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.colorPrimaryInverse,
                  ),
                  child: TextButton(
                      onPressed: () {
                        if (context
                            .read<RegisterAndSellBloc>()
                            .state
                            .invoiceUrl
                            .isNotEmpty) {
                          // BlocProvider.of<RegisterAndSellBloc>(context)
                          //     .add(TriggerRefreshRegistrationAndSellForm());
                          BlocProvider.of<RegisterAndSellBloc>(context).add(
                              TriggerDownloadPdf(
                                  invoiceUrl: context
                                      .read<RegisterAndSellBloc>()
                                      .state
                                      .invoiceUrl));
                          // if(context.read<RegisterAndSellBloc>().state.isFromOnBehalf != null){
                          //   Navigator.of(context).pop();
                          //   Navigator.of(context).pop();
                          // }
                        }
                      },
                      child: Text(
                        'View Invoice',
                        style: AppTextStyles.buttonTitle(
                            color: AppColors.colorSecondaryAccent),
                      ))),
            ),
          ),
        ),
      SizedBox(
        height: 10.h,
      ),
         ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: Container(
              height: 35.h,
              width: Dimensions.getScreenWidth() / 1,
              decoration: BoxDecoration(
                color: AppColors.colorSecondaryAccent,
              ),
              child: TextButton(
                  onPressed: () {
                    BlocProvider.of<RegisterAndSellBloc>(context)
                        .add(TriggerRefreshRegistrationAndSellForm());
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    // if(context.read<RegisterAndSellBloc>().state.isFromOnBehalf != null){
                    //   Navigator.of(context).pop();
                    //   Navigator.of(context).pop();
                    // }
                  },
                  child: Text(
                    'Next Sale',
                    style: AppTextStyles.buttonTitle(
                        color: AppColors.colorPrimaryInverse),
                  ))),
        ),
    ],
  );
}

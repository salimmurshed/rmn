import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';
import '../../../presentation/my_purchases/widgets/build_product_image.dart';
import '../buttons/invoice_button.dart';

class CustomInfoCard extends StatefulWidget {
  CustomInfoCard({
    super.key,
    required this.imageUrl,
    this.age = AppStrings.global_empty_string,
    this.weight = AppStrings.global_empty_string,
    this.firstName = AppStrings.global_empty_string,
    this.lastName = AppStrings.global_empty_string,
    this.title = AppStrings.global_empty_string,
    required this.price,
    this.metric1 = AppStrings.global_empty_string,
    this.metric2 = AppStrings.global_empty_string,
    required this.infoCardType,
    required this.infoCardOnTap,
    this.qrCodeStatus,
    this.widget,
    this.isLoading = false,
  });

  final String imageUrl,
      age,
      weight,
      firstName,
      lastName,
      metric1,
      metric2,
      title;
  final InfoCardType infoCardType;
  final void Function() infoCardOnTap;
  final num price;
  Widget? widget;
  bool isLoading;
  String? qrCodeStatus;

  @override
  State<CustomInfoCard> createState() => _CustomInfoCardState();
}

class _CustomInfoCardState extends State<CustomInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      margin: EdgeInsets.only(
        bottom: 10.h,
      ),
      width: Dimensions.getScreenWidth(),
      decoration: BoxDecoration(
          color: AppColors.colorSecondary,
          borderRadius: BorderRadius.circular(Dimensions.generalSmallRadius)),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Row(
        children: [
          if (widget.infoCardType != InfoCardType.products &&
              widget.infoCardType != InfoCardType.eventProducts) ...[
            buildCustomAthleteProfileHolder(
                imageUrl: widget.imageUrl,
                age: widget.age,
                weight: widget.weight),
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
                              firstName: widget.firstName,
                              lastName: widget.lastName),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.subtitle(isBold: true),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  if (widget.infoCardType == InfoCardType.seasonPasses)
                    metricsPlaceHolder(),
                ],
              ),
            )
          ]
          else ...[
            buildProductImage(
                isMyProductDetail: false,
                qrCodeStatus:
                    widget.qrCodeStatus ?? AppStrings.global_empty_string,
                coverImage: widget.imageUrl),
            Container(
              padding: EdgeInsets.only(left: 10.w),
              width: Dimensions.getScreenWidth() * 0.65,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.subtitle(isBold: true),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  if (widget.infoCardType == InfoCardType.products)
                    metricsPlaceHolder(),
                  const Spacer(),
                  Row(
                    children: [
                      const Spacer(),
                      SizedBox(

                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                StringManipulation.addADollarSign(price: widget.price),
                                style: AppTextStyles.subtitle(isOutFit: false),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],

          const Spacer(),
          if (widget.infoCardType == InfoCardType.seasonPasses)
          SizedBox(

            height: 100.h,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                    buildInvoiceButton(
                      context: context,
                      isActionBar: false,
                      onTap: widget.infoCardOnTap,
                      isLoading: widget.isLoading,
                    ),
                  const Spacer(),
                  Text(
                    StringManipulation.addADollarSign(price: widget.price),
                    style: AppTextStyles.subtitle(isOutFit: false),
                  ),
                ]),
          ),

        ],
      ),
    );
  }

  Widget metricsPlaceHolder() {
    return widget.infoCardType == InfoCardType.products?Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customMetricHolder(
            value: widget.metric1,
            infoCardType: widget.infoCardType,
            metricNumber: 0),
        SizedBox(
          width: 5.w,
        ),
        customMetricHolder(
            value: widget.metric2,
            infoCardType: widget.infoCardType,
            metricNumber: 1),
      ],
    ):
      Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customMetricHolder(
            value: widget.metric1,
            infoCardType: widget.infoCardType,
            metricNumber: 0),
        SizedBox(
          width: 5.w,
        ),
        customMetricHolder(
            value: widget.metric2,
            infoCardType: widget.infoCardType,
            metricNumber: 1),
      ],
    );
  }
}

customMetricHolder(
    {required String value,
    required InfoCardType infoCardType,
    required int metricNumber}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SvgPicture.asset(
          colorFilter:
              ColorFilter.mode(AppColors.colorPrimaryAccent, BlendMode.srcIn),
          height: 12.h,
          infoCardType == InfoCardType.seasonPasses && metricNumber == 0
              ? AppAssets.icMembership
              : infoCardType == InfoCardType.products && metricNumber == 0
                  ? AppAssets.icProductPurchased
                  : AppAssets.icCart),
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

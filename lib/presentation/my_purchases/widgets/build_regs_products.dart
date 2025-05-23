import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/widgets/cards/custom_info_card.dart';
import '../../../imports/common.dart';
import '../bloc/my_purchases_bloc.dart';

List<Widget> buildRegsProducts(MyPurchasesWithInitialState state) {
  return [
    if (state.products.isNotEmpty) ...[
      Flexible(
          child: ListView.separated(
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, AppRouteNames.routePurchasedProducts,
                          arguments: state.products[index].id!);
                    },
                    child: CustomInfoCard(
                      title: state.products[index].title!,
                      imageUrl: state.products[index].coverImage!,
                      price: state.products[index].totalAmount!,
                      infoCardType: InfoCardType.products,
                      infoCardOnTap: () {
                        Navigator.pushNamed(
                            context, AppRouteNames.routePurchasedProducts,
                            arguments: state.products[index].id!);
                      },
                      metric1: state.products[index].totalCount.toString(),
                      metric2:
                          state.products[index].purchaseDatetime.toString(),
                    ));
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 10.h,
                );
              },
              itemCount: state.products.length))
    ] else ...[
      Container(
        margin:
            EdgeInsets.symmetric(horizontal: Dimensions.getScreenWidth() * 0.2),
        width: Dimensions.getScreenWidth() * 0.6,
        child: Column(
          children: [
            SizedBox(
              height: Dimensions.getScreenHeight() * 0.3,
            ),
            Center(
              child: Text(AppStrings.myPurchases_noProducts_text,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.smallTitle()),
            ),
          ],
        ),
      ),
    ]
  ];
}

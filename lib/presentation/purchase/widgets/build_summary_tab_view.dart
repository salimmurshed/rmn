import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/root_app.dart';

import '../../../common/widgets/tab_views/custom_summary_tab_view.dart';
import '../../../imports/common.dart';
import '../bloc/purchase_bloc.dart';

List<Widget> buildSummaryTabView({
  required PurchaseWithInitialState state,
  required String module,
}) {
  return [
    Expanded(
      child: ListView(
        padding: EdgeInsets.only(bottom: 15.h, left: 10.w, right: 10.w),
        children: [
          if (module == 'registrations')
            buildCustomContainerForPurchasedItems(
              children: [
                buildSummaryCardHeader(
                  isEditActive: state.isEditActive,
                    title: AppStrings.purchase_tab_registration_title,
                    edit: state.isEditActive? () {
                      BlocProvider.of<PurchaseBloc>(
                              navigatorKey.currentContext!)
                          .add(const TriggerEditItem(
                              section: SummarySection.regs));
                    }: (){}),
                buildSummaryListViewBuilder(
                    itemBuilder: (context, registrationIndex) {
                      return buildSummaryItem(
                          max: state
                              .registrationForSummary[registrationIndex].max
                              .toString(),
                          tierName: state
                              .registrationForSummary[registrationIndex]
                              .tierName,
                          type: state
                              .registrationForSummary[registrationIndex].type,
                          division: state
                              .registrationForSummary[registrationIndex]
                              .division,
                          style: state
                              .registrationForSummary[registrationIndex].style,
                          itemReducedTotalPrice: state
                              .registrationForSummary[registrationIndex]
                              .reducedPrice,
                          denominator: state
                              .registrationForSummary[registrationIndex]
                              .denominator,
                          nominator: state
                              .registrationForSummary[registrationIndex]
                              .nominator,
                          itemName: state
                              .registrationForSummary[registrationIndex].title,
                          itemPrice: StringManipulation.addADollarSign(
                              price: state
                                  .registrationForSummary[registrationIndex]
                                  .price),
                          itemQuantity:
                              '${state.registrationForSummary[registrationIndex].quantity}x',
                          itemTotalPrice: StringManipulation.addADollarSign(
                              price: state
                                  .registrationForSummary[registrationIndex]
                                  .totalPrice),
                          hasDialog: state
                                  .registrationForSummary[registrationIndex]
                                  .reducedPrice !=
                              null);
                    },
                    itemCount: state.registrationForSummary.length),
                buildSummaryCardDivider(),
                buildSummaryCardSubtotalSection(
                    subTotal: state.registrationSubTotal,
                    newSubTotal: state.isPriceReducedForRegs
                        ? StringManipulation.addADollarSign(
                            price: state.totalReducedPrice)
                        : null),
              ],
            ),
          if (state.isProductsSelected) ...[
            if (module == 'registrations' || module == 'tickets')
              buildCustomContainerForPurchasedItems(
                children: [
                  buildSummaryCardHeader(
                    isEditActive: state.isEditActive,
                      title: AppStrings.purchase_tab_products_title,
                      edit: state.isEditActive?() {
                        BlocProvider.of<PurchaseBloc>(
                                navigatorKey.currentContext!)
                            .add(const TriggerEditItem(
                                section: SummarySection.products));
                      }: (){}),
                  buildSummaryListViewBuilder(
                      itemBuilder: (context, productIndex) {
                        return buildSummaryItem(
                            type: '',
                            division: '',
                            style: '',
                            itemReducedTotalPrice: null,
                            nominator: 0,
                            denominator: 0,
                            itemName: state
                                .selectedProducts[productIndex].productType!,
                            itemPrice: StringManipulation.addADollarSign(
                                price: state
                                    .selectedProducts[productIndex].price!),
                            itemQuantity:
                                '${state.selectedProducts[productIndex].quantity}x',
                            itemTotalPrice: StringManipulation.addADollarSign(
                                price: state.selectedProducts[productIndex]
                                    .totalPrice!),
                            hasDialog: false);
                      },
                      itemCount: state.selectedProducts.length),
                  buildSummaryCardDivider(),
                  buildSummaryCardSubtotalSection(
                      subTotal: state.productSubTotal, newSubTotal: null),
                ],
              )
          ],
          if (module == 'season-pass')
            buildCustomContainerForPurchasedItems(
              children: [
                buildSummaryCardHeader(
                  isEditActive: state.isEditActive,
                    title: 'Season Pass',
                    edit: state.isEditActive? () {
                      BlocProvider.of<PurchaseBloc>(
                              navigatorKey.currentContext!)
                          .add(const TriggerEditItem(
                              section: SummarySection.athletes));
                    }: (){}),
                buildSummaryListViewBuilder(
                    itemBuilder: (context, seasonIndex) {
                      return buildSummaryItem(
                          type: AppStrings.global_empty_string,
                          division: AppStrings.global_empty_string,
                          style: AppStrings.global_empty_string,
                          itemReducedTotalPrice: null,
                          nominator: 0,
                          denominator: 0,
                          itemName: state
                              .seasonPassForSummary[seasonIndex].seasonTitle!,
                          itemPrice: StringManipulation.addADollarSign(
                              price: state
                                  .seasonPassForSummary[seasonIndex].price!),
                          itemQuantity:
                              '${state.seasonPassForSummary[seasonIndex].quantity}x',
                          itemTotalPrice: StringManipulation.addADollarSign(
                              price: state.seasonPassForSummary[seasonIndex]
                                  .totalPrice!),
                          hasDialog: false);
                    },
                    itemCount: state.seasonPassForSummary.length),
                buildSummaryCardDivider(),
                buildSummaryCardSubtotalSection(
                    subTotal: state.seasonPassSubTotal, newSubTotal: null),
              ],
            ),
          state.isCouponLoading
              ? CustomLoader(
                  isTopMarginNeeded: true,
                  isForSingleWidget: true,
                  child: buildSummaryCard(
                    error: state.couponMessage,
                    applyCoupon: () {
                      BlocProvider.of<PurchaseBloc>(
                              navigatorKey.currentContext!)
                          .add(TriggerCouponApplication(module: module));
                    },
                    checkApplyButtonActivity: () {
                      BlocProvider.of<PurchaseBloc>(
                              navigatorKey.currentContext!)
                          .add(TriggerCheckApplyButtonActivity());
                    },
                    removeCoupon: () {
                      BlocProvider.of<PurchaseBloc>(
                              navigatorKey.currentContext!)
                          .add(TriggerCouponRemoval());
                    },
                    couponEditingController: state.couponEditingController,
                    couponNode: state.couponNode,
                    couponCode: state.couponCode,
                    couponAmount: state.couponAmount,
                    isApplyButtonActive: state.isApplyButtonActive,
                    transactionFee: state.transactionFee,
                    totalWithTransactionWithoutCouponFee:
                        state.totalWithTransactionWithoutCouponFee,
                    totalWithTransactionWithCouponFee:
                        state.totalWithTransactionWithCouponFee,
                  ))
              : buildSummaryCard(
                  error: state.couponMessage,
                  applyCoupon: () {
                    BlocProvider.of<PurchaseBloc>(navigatorKey.currentContext!)
                        .add(TriggerCouponApplication(module: module));
                  },
                  checkApplyButtonActivity: () {
                    BlocProvider.of<PurchaseBloc>(navigatorKey.currentContext!)
                        .add(TriggerCheckApplyButtonActivity());
                  },
                  removeCoupon: () {
                    BlocProvider.of<PurchaseBloc>(navigatorKey.currentContext!)
                        .add(TriggerCouponRemoval());
                  },
                  couponEditingController: state.couponEditingController,
                  couponNode: state.couponNode,
                  couponCode: state.couponCode,
                  couponAmount: state.couponAmount,
                  isApplyButtonActive: state.isApplyButtonActive,
                  transactionFee: state.transactionFee,
                  totalWithTransactionWithoutCouponFee:
                      state.totalWithTransactionWithoutCouponFee,
                  totalWithTransactionWithCouponFee:
                      state.totalWithTransactionWithCouponFee,
                ),
          buildCustomContainerForPurchasedItems(
            children: [
              buildSummaryCardHeader(
                isEditActive: state.isEditActive,
                  title: 'Payment',
                  edit: state.isEditActive ?() {
                    BlocProvider.of<PurchaseBloc>(navigatorKey.currentContext!)
                        .add(const TriggerEditItem(
                            section: SummarySection.payment));
                  }: (){}),
              Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: Row(
                  children: [
                    Text(
                      '...... ...... ...... ${state.cardList[state.currentCardIndex].last4}',
                      style: AppTextStyles.subtitle(isOutFit: false),
                    ),
                    const Spacer(),
                    Text(
                      state.cardList[state.currentCardIndex].name!,
                      style: AppTextStyles.subtitle(isOutFit: false),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    )
  ];
}

buildCustomContainerForPurchasedItems({required List<Widget> children}) {
  return Container(
    margin: EdgeInsets.only(bottom: 15.h),
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
    decoration: BoxDecoration(
        color: AppColors.colorSecondary,
        borderRadius: BorderRadius.circular(3.r)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: children,
    ),
  );
}

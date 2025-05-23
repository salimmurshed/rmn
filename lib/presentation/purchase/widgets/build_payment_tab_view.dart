import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rmnevents/root_app.dart';

import '../../../imports/common.dart';
import '../bloc/purchase_bloc.dart';

List<Widget> buildPaymentTabView({
  required PurchaseWithInitialState state,
}) {
  return [
    buildCardDeletionAdditionButtons(
      showTitle: state.couponModule == CouponModules.seasonPasses,
      add: () {
        Navigator.of(navigatorKey.currentContext!)
            .pushNamed(AppRouteNames.routeCardForm);
      },
      //delete: (){}
    ),
    if (state.cardList.isEmpty)
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: state.couponModule == CouponModules.seasonPasses
                  ? Dimensions.getScreenHeight() * 0.3
                  : Dimensions.getScreenHeight() * 0.2),
          Text(
            AppStrings.payment_addCard_noCard_text,
            style: AppTextStyles.smallTitleForEmptyList(),
          ),
        ],
      ),
    if (state.cardList.isNotEmpty)
      buildCustomCardCarousel(
          delete: (cardIndex) {
            buildBottomSheetWithBodyText(
              context: navigatorKey.currentContext!,
              subtitle: state.selectedCardIndex != -1
                  ? AppStrings
                      .payment_addCard_deleteCard_selectedCard_bottomSheet_subtitle
                  : AppStrings
                      .payment_addCard_deleteCard_empty_bottomSheet_subtitle,
              onLeftButtonPressed: () {
                Navigator.pop(navigatorKey.currentContext!);
              },
              onRightButtonPressed: () {
                Navigator.pop(navigatorKey.currentContext!);
                BlocProvider.of<PurchaseBloc>(navigatorKey.currentContext!)
                    .add(TriggerRemoveCard(index: cardIndex));
              },
              isSingeButtonPresent: state.selectedCardIndex == -1,
              singleButtonFunction: () {
                Navigator.pop(navigatorKey.currentContext!);
              },
              title: AppStrings.payment_addCard_deleteCard_bottomSheet_title,
              highLightedAthleteName: AppStrings.global_empty_string,
              rightButtonText: AppStrings.btn_yes,
              leftButtonText: AppStrings.btn_no,
              isSingleButtonColorFilled: true,
              singleButtonText: AppStrings.btn_ok,
            );
          },
          cardList: state.cardList,
          cardPageController: state.cardPageController,
          currentCardIndex: state.currentCardIndex,
          selectedCardIndex: state.selectedCardIndex,
          selectCard: (cardIndex) {
            BlocProvider.of<PurchaseBloc>(navigatorKey.currentContext!)
                .add(TriggerSelectCard(index: cardIndex));
          })
  ];
}

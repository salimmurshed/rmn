// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../../imports/common.dart';
// import '../bloc/purchase_bloc.dart';
// import 'build_products_widget.dart';
//
// List<Widget> buildProductsTabView(
//     {required PurchaseWithInitialState state,
//    }) {
//   return [
//     if(state.products.isNotEmpty)
//     Expanded(
//     //  height: Dimensions.getScreenHeight()*0.55,
//       child: ListView.separated(
//           padding: EdgeInsets.only(left: 10.w, right: 10.w),
//           itemBuilder: (context, productIndex) {
//             bool isGiveAway = state.products[productIndex].productDetails?.isGiveaway ?? false;
//             if(state.couponModule == CouponModules.tickets && isGiveAway){
//               return const SizedBox.shrink();
//             }
//             else{
//               debugPrint('R--${state.products[productIndex].productDetails?.title} ${state.products[productIndex].productDetails?.isGiveaway} ${state.products[productIndex].productDetails?.isGiveawayMandatory} ${state.products[productIndex].productDetails?.giveAwayType} ${state.products[productIndex].availableGiveaways}');
//               return
//                 ProductWidget(
//                   context: context,
//                   onChanged: (val) {
//                     BlocProvider.of<PurchaseBloc>(context).add(TriggerSelectVariant(
//                         selectedValue: val,
//                         index: productIndex,
//                         isFromMBS: false,
//                         product: state.products));
//                   },
//                   products: state.products[productIndex],
//                   onMenuStateChange: (isOpen) {
//                     BlocProvider.of<PurchaseBloc>(context).add(TriggerOpenDropDown(
//                       // products: state.products,
//                       // index: productIndex,
//                         isAthlete: false, isOpened: isOpen ?? false));
//                   },
//                   selectedValueProduct: state.products[productIndex].selectedVariant,
//                   dropDownKeyForProducts:state.products[productIndex].dropDownKeyForProduct!,
//                   isProductDropDownOpened: state.isProductDropDownOpened,
//                   reduce:  () {
//                     BlocProvider.of<PurchaseBloc>(context).add(TriggerChangeProductQuantity(
//                       isFromMBS: false,
//                         isMinus: true,
//                         index: productIndex,
//                         quantity: state.products[productIndex].quantity!,
//                         product: state.products));
//                   },
//                   increase: () {
//                     BlocProvider.of<PurchaseBloc>(context).add(TriggerChangeProductQuantity(
//                         isMinus: false,
//                         isFromMBS: false,
//                         index: productIndex,
//                         quantity: state.products[productIndex].quantity!,
//                         product: state.products));
//                   },
//                 );
//             }
//           },
//           separatorBuilder: (context, productsIndex) {
//             return SizedBox(height: 10.h);
//           },
//           itemCount: state.products.length),
//     ),
//     if(state.products.isEmpty)
//       Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(height: Dimensions.getScreenHeight() * 0.29),
//           Text(AppStrings.purchase_productsTab_emptyList, style: AppTextStyles.smallTitleForEmptyList(),),
//         ],
//       ),
//   ];
// }

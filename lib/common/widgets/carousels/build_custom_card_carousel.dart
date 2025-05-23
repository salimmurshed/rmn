import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../data/models/response_models/uploaded_card_list_response_model.dart';
import '../../../imports/common.dart';
import '../../../root_app.dart';

Widget buildCustomCardCarousel(
    {required PageController cardPageController,
    required void Function(int) selectCard,
    required int selectedCardIndex,
    required int currentCardIndex,
    bool isSquare = true,
    required void Function(int) delete,
    required List<CardData> cardList}) {
  return Container(
    margin: EdgeInsets.only(left: 10.w, right: 10.w),
    child: buildCustomCarousel(
      isSquare: isSquare,
      height: !isSquare ? 60.h : (isTablet ? 300.h : 190.h),
      currentIndex: currentCardIndex,
      itemCount: cardList.length,
      pageController: cardPageController,
      itemBuilder: (context, index) {
        return InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              selectCard(index);
            },
            child: Container(
              width: Dimensions.getScreenWidth(),
              decoration: BoxDecoration(
                color: AppColors.colorPrimary,
                border: Border.all(
                  color: selectedCardIndex == index
                      ? AppColors.colorPrimaryAccent
                      : AppColors.colorPrimaryNeutral,
                  width: 1.w,
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 3.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        cardList[index].brand!.toLowerCase() == "visa"
                            ? AppAssets.imgVisa
                            : cardList[index].brand!.toLowerCase() == "mastercard"
                                ? AppAssets.imgMastercard
                                : AppAssets.imgAmex,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        "* * * *  * * * *  * * * *  ${cardList[index].last4!}",
                        textAlign: TextAlign.start,
                        textHeightBehavior: const TextHeightBehavior(
                            applyHeightToFirstAscent: false),
                        style: AppTextStyles.smallTitle(isOutFit: false),
                      ),
                      //  SizedBox(width: 10.w),
                      // Text(
                      //   "* * * *",
                      //   style: AppTextStyles.smallTitle(isOutFit: false),                      ),
                      // SizedBox(width: 10.w),
                      // Text(
                      //   "* * * *",
                      //   style: AppTextStyles.smallTitle(isOutFit: false),                      ),
                      // SizedBox(width: 10.w),
                      // Text(
                      //   cardList[index].last4!,
                      //   textAlign: TextAlign.start,
                      //   style: AppTextStyles.smallTitle(isOutFit: false),                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      delete(index);
                    },
                    child: SvgPicture.asset(
                      AppAssets.icBin,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            )
            // Stack(
            //   fit: StackFit.expand,
            //   children: [
            //     SvgPicture.asset(
            //       selectedCardIndex == index
            //           ? AppAssets.icCardSelected
            //           : AppAssets.icCardUnSelected,
            //       fit: BoxFit.contain,
            //     ),
            //     Positioned(
            //         top: isTablet? 50.h:20.h,
            //         right: 10.w,
            //         child: IconButton(
            //           onPressed: () {
            //             delete(index);
            //           },
            //           icon: Icon(
            //             color: AppColors.colorPrimaryAccent,
            //             Icons.highlight_remove,
            //             size: 40,
            //           ),
            //         )),
            //     Positioned(
            //         top: isTablet ? 80.h: 50.h,
            //         left: 0,
            //         right: 0,
            //         child: Container(
            //           height: isTablet? 160.h: 120.h,
            //           padding: EdgeInsets.symmetric(horizontal: 20.w),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             children: [
            //               Container(
            //                 margin: EdgeInsets.only(top: 10.h),
            //                 alignment: Alignment.topLeft,
            //                 child: Text(
            //                   cardList[index].brand!,
            //                   style: AppTextStyles.smallTitle(isOutFit: true),
            //                 ),
            //               ),
            //               Align(
            //                 alignment: Alignment.topLeft,
            //                 child: SizedBox(
            //                   width: Dimensions.getScreenWidth() * 0.7,
            //                   child: Row(
            //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                     children: [
            //                       Text(
            //                         "• • • •",
            //                         style: AppTextStyles.smallTitle(),
            //                       ),
            //                       const SizedBox(width: 28.0),
            //                       Text(
            //                         "• • • •",
            //                         style:
            //                             AppTextStyles.smallTitle(isOutFit: true),
            //                       ),
            //                       const SizedBox(width: 28.0),
            //                       Text(
            //                         "• • • •",
            //                         style:
            //                             AppTextStyles.smallTitle(isOutFit: true),
            //                       ),
            //                       const SizedBox(width: 28.0),
            //                       Text(
            //                         cardList[index].last4!,
            //                         style:
            //                             AppTextStyles.smallTitle(isOutFit: true),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //               const Spacer(),
            //               SizedBox(
            //                 width: Dimensions.getScreenWidth() * 0.9,
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Text(
            //                           'Card Holder Name',
            //                           style: AppTextStyles.normalNeutral(),
            //                         ),
            //                         Text(
            //                           cardList[index].name!,
            //                           style:
            //                               AppTextStyles.subtitle(isOutFit: true),
            //                         )
            //                       ],
            //                     ),
            //                     Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Text(
            //                           'Expire',
            //                           style: AppTextStyles.normalNeutral(),
            //                         ),
            //                         Text(
            //                           cardList[index].expMonthYear!,
            //                           style:
            //                               AppTextStyles.subtitle(isOutFit: true),
            //                         )
            //                       ],
            //                     ),
            //                   ],
            //                 ),
            //               )
            //             ],
            //           ),
            //         ))
            //   ],
            // ),
            );
      },
    ),
  );
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:rmnevents/presentation/athlete_details/bloc/athlete_details_handlers.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';
import 'empty_tab_list_text.dart';

Widget buildAwardsList({required List<Awards> awards}) {
  return awards.isEmpty
      ? emptyTabListText(text: AppStrings.athleteDetails_awardsList_text)
      : Expanded(
          child:  ListView.builder(
            itemCount: awards.length,
            itemBuilder: (context, index) {
              return Container(
                //height: 120.h,
                width: Dimensions.getScreenWidth(),
                margin: EdgeInsets.symmetric(vertical: 5.h),
                padding: EdgeInsets.all(3.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.generalRadius),
                  color: AppColors.colorTertiary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 10.w,
                    ),
                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(Dimensions.generalRadius),
                      child: CachedNetworkImage(
                        imageUrl: awards[index].award!.image!,
                        height: 70.h,
                        width: Dimensions.getScreenWidth() * 0.2,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin:
                        EdgeInsets.only(left: 10.w, bottom: 10.h, top: 10.h, right: 10.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: Dimensions.getScreenWidth(),
                              margin: EdgeInsets.only(bottom: 5.h),
                              child: Row(
                                children: [
                                  Text(
                                    awards[index].award!.title!,
                                    maxLines: 1,
                                    style: AppTextStyles.smallTitle(),
                                  ),
                                  const Spacer(),
                                  Text(
                                    awards[index].status!.toUpperCase(),
                                    style: AppTextStyles.regularNeutralOrAccented(

                                        color: awards[index].status == 'failed'
                                            ? AppColors.colorPrimaryAccent
                                            : AppColors.colorSecondaryAccent,
                                        isOutfit: false),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 3.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      awards[index].division!.title!,
                                      maxLines: 1,
                                      style:
                                      AppTextStyles.subtitle(isOutFit: false),
                                    ),
                                  ),
                                  Text(
                                    AthleteDetailsHandlers.modifyWC(
                                        award: awards[index]),
                                    style:
                                    AppTextStyles.subtitle(isOutFit: false),
                                  ),
                                ],
                              ),
                            ),
                            if (awards[index].criteria != null) ...[
                              for (var i = 0;
                              i < awards[index].criteria!.length;
                              i++) ...[
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        awards[index].criteria![i].text!,
                                        style: AppTextStyles.componentLabels(),
                                      ),
                                    ),

                                    RichText(
                                      text: TextSpan(
                                        text: '${awards[index].criteria![i].achieved}',
                                        style: AppTextStyles.componentLabels( isOutFit: true),
                                        children: [
                                          TextSpan(
                                            text:
                                            '/${awards[index].criteria![i].target}',
                                            style: AppTextStyles.componentLabels( isOutFit: true, isBold: true),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Text(
                                    //   '${awards[index].criteria![i].achieved}/${awards[index].criteria![i].target}',
                                    //   style: AppTextStyles.componentLabels(
                                    //       color: AppColors.colorPrimaryAccent),
                                    // ),
                                  ],
                                ),
                                ClipRRect(
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(50)),
                                  child: LinearPercentIndicator(
                                    padding: EdgeInsets.zero,
                                    lineHeight: 3.0,
                                    percent:
                                    (awards[index].criteria![i].progress! /
                                        100)
                                        .toDouble(),
                                    progressColor:
                                    AthleteDetailsHandlers.showColor(
                                        status: awards[index].status!,
                                        achieved: awards[index]
                                            .criteria![i]
                                            .achieved!,
                                        target: awards[index]
                                            .criteria![i]
                                            .target!),
                                    barRadius: const Radius.circular(50.0),
                                    backgroundColor: AppColors.colorDisabled,
                                  ),
                                ),
                              ]
                            ]

                            // if(awards[index].criteria!.minEvents != 0)...[
                            //   Row(
                            //   mainAxisAlignment:
                            //   MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text(
                            //       AthleteDetailsHandlers.modifyMinEvents(
                            //           award: awards[index]),
                            //       style: AppTextStyles.componentLabels(),
                            //     ),
                            //     Text(
                            //       AthleteDetailsHandlers.showWinByMin(
                            //           award: awards[index]),
                            //       style: AppTextStyles.componentLabels(
                            //           color: AppColors.colorPrimaryAccent),
                            //     ),
                            //   ],
                            // ),
                            // ClipRRect(
                            //   borderRadius:
                            //   const BorderRadius.all(Radius.circular(50)),
                            //   child: LinearPercentIndicator(
                            //     padding: EdgeInsets.zero,
                            //     lineHeight: 3.0,
                            //     percent: AthleteDetailsHandlers
                            //         .getPercentageForMinEvents(
                            //         award: awards[index]),
                            //     progressColor: AthleteDetailsHandlers
                            //         .showColorForWinByMin(
                            //         award: awards[index]),
                            //     barRadius: const Radius.circular(50.0),
                            //     backgroundColor: AppColors.colorDisabled,
                            //   ),
                            // ),
                            // ],
                            // if(awards[index].criteria!.totalMatches != 0)...[
                            //   Row(
                            //     mainAxisAlignment:
                            //     MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Text(
                            //         AthleteDetailsHandlers.modifyTotalMatches(
                            //             award: awards[index]),
                            //         style: AppTextStyles.componentLabels(),
                            //       ),
                            //       Text(
                            //         AthleteDetailsHandlers
                            //             .showAthleteMatchesByTotalMatches(
                            //             award: awards[index]),
                            //         style: AppTextStyles.componentLabels(
                            //             color: AppColors.colorPrimaryAccent),
                            //       ),
                            //     ],
                            //   ),
                            //   ClipRRect(
                            //     borderRadius:
                            //     const BorderRadius.all(Radius.circular(50)),
                            //     child: LinearPercentIndicator(
                            //       padding: EdgeInsets.zero,
                            //       lineHeight: 3.0,
                            //       percent: AthleteDetailsHandlers
                            //           .getPercentageForTotalMatches(
                            //           award: awards[index]),
                            //       progressColor: AthleteDetailsHandlers
                            //           .showColorForAthleteMatchesByTotalMatches(
                            //           award: awards[index]),
                            //       barRadius: const Radius.circular(50.0),
                            //       backgroundColor: AppColors.colorDisabled,
                            //     ),
                            //   ),
                            // ],
                            // if(awards[index].criteria!.minEvents == 0 && awards[index].criteria!.winSpecificEvents!.isNotEmpty)...[
                            //   Row(
                            //     mainAxisAlignment:
                            //     MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Text(
                            //         'Win ${awards[index].criteria!.athleteWinSpecificEvents} event(s)',
                            //         style: AppTextStyles.componentLabels(),
                            //       ),
                            //       Text(
                            //         '${awards[index].criteria!.athleteWinSpecificEvents}/${awards[index].criteria!.winSpecificEvents!.length}',
                            //         style: AppTextStyles.componentLabels(
                            //             color: AppColors.colorPrimaryAccent),
                            //       ),
                            //     ],
                            //   ),
                            //   ClipRRect(
                            //     borderRadius:
                            //     const BorderRadius.all(Radius.circular(50)),
                            //     child: LinearPercentIndicator(
                            //       padding: EdgeInsets.zero,
                            //       lineHeight: 3.0,
                            //       percent: AthleteDetailsHandlers
                            //           .getPercentageForTotalMatches(
                            //           award: awards[index]),
                            //       progressColor: AppColors.colorPrimaryAccent,
                            //       barRadius: const Radius.circular(50.0),
                            //       backgroundColor: AppColors.colorDisabled,
                            //     ),
                            //   ),
                            // ]
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
  // Container(
  //   color: Colors.yellow,
  //         height: Dimensions.getScreenHeight()*0.55,
  //         width: Dimensions.getScreenWidth(),
  //         child: Column(
  //           children: [
  //             SizedBox(
  //               height: 30.h,
  //               child: ListView.separated(
  //                   scrollDirection: Axis.horizontal,
  //                   itemBuilder: (context, i) {
  //                     return Container(
  //                         //height: 30.h,
  //                         padding: EdgeInsets.symmetric(
  //                             horizontal: 10.w, vertical: 2.h),
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(5.r),
  //                           color: AppColors.colorSecondaryAccent,
  //                         ),
  //                         child: Center(
  //                           child: Text(
  //                             awards[i].division!.title!,
  //                             style: AppTextStyles.componentLabels(
  //                                 color: AppColors.colorPrimaryNeutralText),
  //                           ),
  //                         ));
  //                   },
  //                   separatorBuilder: (context, i) => SizedBox(
  //                         width: 10.h,
  //                       ),
  //                   itemCount: awards.length),
  //             ),
  //             Expanded(
  //               child: ListView.builder(
  //                 itemCount: awards.length,
  //                 itemBuilder: (context, index) {
  //                   return Container(
  //                     //height: 120.h,
  //                     width: Dimensions.getScreenWidth(),
  //                     margin: EdgeInsets.symmetric(vertical: 5.h),
  //                     padding: EdgeInsets.all(3.r),
  //                     decoration: BoxDecoration(
  //                       borderRadius:
  //                           BorderRadius.circular(Dimensions.generalRadius),
  //                       color: AppColors.colorTertiary,
  //                     ),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         ClipRRect(
  //                           borderRadius:
  //                               BorderRadius.circular(Dimensions.generalRadius),
  //                           child: CachedNetworkImage(
  //                             imageUrl: awards[index].award!.image!,
  //                             height: 120.h,
  //                             width: Dimensions.getScreenWidth() * 0.3,
  //                             fit: BoxFit.cover,
  //                           ),
  //                         ),
  //                         Container(
  //                           width: Dimensions.getScreenWidth() * 0.6,
  //                           margin: EdgeInsets.only(left: 5.w, bottom: 10.h, top: 10.h),
  //                           child: Column(
  //                             mainAxisAlignment: MainAxisAlignment.start,
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Container(
  //                                 margin: EdgeInsets.only(bottom: 5.h),
  //                                 child: Text(
  //                                   awards[index].award!.title!,
  //                                   style: AppTextStyles.largeTitle(),
  //                                 ),
  //                               ),
  //                               Container(
  //                                 margin: EdgeInsets.only(bottom: 3.h),
  //                                 child: Row(
  //                                   crossAxisAlignment: CrossAxisAlignment.start,
  //                                   mainAxisAlignment:
  //                                       MainAxisAlignment.spaceBetween,
  //                                   children: [
  //                                     Text(
  //                                       awards[index].division!.title!,
  //                                       style: AppTextStyles.smallTitle(),
  //                                     ),
  //                                     Text(
  //                                       AthleteDetailsHandlers.modifyWC(
  //                                           award: awards[index]),
  //                                       style: AppTextStyles.smallTitle(),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                               Row(
  //                                 mainAxisAlignment:
  //                                     MainAxisAlignment.spaceBetween,
  //                                 children: [
  //                                   Text(
  //                                     AthleteDetailsHandlers.modifyMinEvents(
  //                                         award: awards[index]),
  //                                     style: AppTextStyles.componentLabels(),
  //                                   ),
  //                                   Text(
  //                                     AthleteDetailsHandlers.showWinByMin(
  //                                         award: awards[index]),
  //                                     style: AppTextStyles.componentLabels(
  //                                         color: AppColors.colorPrimaryAccent),
  //                                   ),
  //                                 ],
  //                               ),
  //                               ClipRRect(
  //                                 borderRadius:
  //                                     const BorderRadius.all(Radius.circular(50)),
  //                                 child: LinearPercentIndicator(
  //                                   padding: EdgeInsets.zero,
  //                                   lineHeight: 3.0,
  //                                   percent: AthleteDetailsHandlers
  //                                       .getPercentageForMinEvents(
  //                                           award: awards[index]),
  //                                   progressColor: AthleteDetailsHandlers
  //                                       .showColorForWinByMin(
  //                                           award: awards[index]),
  //                                   barRadius: const Radius.circular(50.0),
  //                                   backgroundColor: AppColors.colorDisabled,
  //                                 ),
  //                               ),
  //                               Row(
  //                                 mainAxisAlignment:
  //                                     MainAxisAlignment.spaceBetween,
  //                                 children: [
  //                                   Text(
  //                                     AthleteDetailsHandlers.modifyTotalMatches(
  //                                         award: awards[index]),
  //                                     style: AppTextStyles.componentLabels(),
  //                                   ),
  //                                   Text(
  //                                     AthleteDetailsHandlers
  //                                         .showAthleteMatchesByTotalMatches(
  //                                             award: awards[index]),
  //                                     style: AppTextStyles.componentLabels(
  //                                         color: AppColors.colorPrimaryAccent),
  //                                   ),
  //                                 ],
  //                               ),
  //                               ClipRRect(
  //                                 borderRadius:
  //                                     const BorderRadius.all(Radius.circular(50)),
  //                                 child: LinearPercentIndicator(
  //                                   padding: EdgeInsets.zero,
  //                                   lineHeight: 3.0,
  //                                   percent: AthleteDetailsHandlers
  //                                       .getPercentageForTotalMatches(
  //                                           award: awards[index]),
  //                                   progressColor: AthleteDetailsHandlers
  //                                       .showColorForAthleteMatchesByTotalMatches(
  //                                           award: awards[index]),
  //                                   barRadius: const Radius.circular(50.0),
  //                                   backgroundColor: AppColors.colorDisabled,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   );
  //                 },
  //               ),
  //             )
  //           ],
  //         ),
  //       );
}

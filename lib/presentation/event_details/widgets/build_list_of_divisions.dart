// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:rmnevents/presentation/event_details/bloc/event_details_bloc.dart';
//
// import '../../../imports/common.dart';
// import '../../../imports/data.dart';
// import '../../../root_app.dart';
// import 'build_expansion_panel_athlete_list.dart';
// import 'build_wrap_of_athletes.dart';
// import 'build_wrap_of_weights.dart';
//
// Expanded buildListOfDivisions(
//     {required void Function(Athlete, int, int, int) openAthlete,
//     required List<DivisionTypes> divisionsTypes,
//     required void Function(bool, int) openParent,
//     required void Function(bool, int, int) openChild,
//     required int parentIndex,
//     bool isFromRegs = false}) {
//   return Expanded(
//       child: ListView.separated(
//           physics: isFromRegs
//               ? const BouncingScrollPhysics()
//               : const NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           padding: EdgeInsets.symmetric(horizontal: 10.w),
//           itemBuilder: (context, childIndex) {
//             return Container(
//               width: Dimensions.getScreenWidth(),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(3.r),
//                 color: AppColors.colorSecondary,
//               ),
//               // margin: EdgeInsets.symmetric(horizontal: 8.w),
//               padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       // buildLeadingForDivisionTile(
//                       //     isParent: false,
//                       //     number: divisionsTypes[parentIndex]
//                       //         .ageGroups![childIndex]
//                       //         .selectedAthletesForCount!
//                       //         .length,
//                       //     isExpanded: divisionsTypes[parentIndex]
//                       //         .ageGroups![childIndex]
//                       //         .isExpanded!),
//                       Text(
//                           divisionsTypes[parentIndex]
//                               .ageGroups![childIndex]
//                               .title!,
//                           style: AppTextStyles.subtitle(isOutFit: false)),
//                       const Spacer(),
//                       if (divisionsTypes[parentIndex]
//                           .ageGroups![childIndex]
//                           .isExpanded!) ...[
//                         TextButton(
//                             onPressed: () {
//                               openChild(false, parentIndex, childIndex);
//                             },
//                             child: Text('Close',
//                                 style: TextStyle(
//                                     decoration: TextDecoration.underline,
//                                     decorationThickness: 2,
//                                     decorationColor:
//                                         AppColors.colorPrimaryAccent,
//                                     fontSize: 12.sp,
//                                     color: AppColors.colorPrimaryAccent,
//                                     fontWeight: FontWeight.w500,
//                                     fontFamily: AppFontFamilies.squada)))
//                       ] else ...[
//                         TextButton(
//                             onPressed: () {
//                               openChild(true, parentIndex, childIndex);
//                             },
//                             child: Text('Available WC',
//                                 style: TextStyle(
//                                     decoration: TextDecoration.underline,
//                                     decorationThickness: 2,
//                                     decorationColor:
//                                         AppColors.colorPrimaryNeutralText,
//                                     color: AppColors.colorPrimaryNeutralText,
//                                     fontSize: 12.sp,
//                                     fontWeight: FontWeight.w500,
//                                     fontFamily: AppFontFamilies.squada)))
//                       ],
//                       GestureDetector(
//                         onTap: () {
//                           // BlocProvider.of<EventDetailsBloc>(
//                           //         navigatorKey.currentContext!)
//                           //     .add(TriggerSetIndex(
//                           //   childIndex: childIndex,
//                           //   parentIndex: parentIndex,
//                           // ));
//                           BlocProvider.of<EventDetailsBloc>(context).add(TriggerOpenAgeGroup(
//                             divIndex: parentIndex,
//                             ageGroupIndex: childIndex
//                           ));
//                           Navigator.pushNamed(navigatorKey.currentContext!,
//                               AppRouteNames.routeEventAthleteSelection);
//                         },
//                         child: Container(
//                           width: 65.w,
//                           padding: EdgeInsets.symmetric(vertical: 2.h),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(3.r),
//                             color: AppColors.colorSecondaryAccent,
//                           ),
//                           child: Center(
//                             child: Text(
//                               AppStrings.btn_add,
//                               style: AppTextStyles.regularPrimary(
//                                 isOutFit: false,
//                               ),
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                   if(divisionsTypes[parentIndex]
//                       .ageGroups![childIndex]
//                       .expansionPanelAthlete!.isNotEmpty) ...[
//                   buildWrapOfAthletes(
//                       openAthlete: (i) {
//                         // openChild(true, parentIndex, childIndex);
//                         openAthlete(
//                             divisionsTypes[parentIndex]
//                                 .ageGroups![childIndex]
//                                 .expansionPanelAthlete![i],
//                             parentIndex,
//                             childIndex,
//                             i);
//                       },
//                       ageGroup:
//                       divisionsTypes[parentIndex].ageGroups![childIndex],
//                       expansionPanelAthletes: divisionsTypes[parentIndex]
//                           .ageGroups![childIndex]
//                           .expansionPanelAthlete ??
//                           [],
//                       addAthlete: (age) {}),
//                     SizedBox(height: 10.h),
//                   ],
//
//                  if(divisionsTypes[parentIndex]
//                           .ageGroups![childIndex]
//                           .isExpanded!)...[
//
//                    Divider(
//                      color: AppColors.colorDisabled,
//                      thickness: 0.5.h,
//                    ),
//                    buildWrapOfWeights(
//                      ageGroupWithExpansionPanelWeights:
//                      divisionsTypes[parentIndex]
//                          .ageGroups![childIndex]
//                          .ageGroupWithExpansionPanelWeights ??
//                          [],
//                      weightAvailable: divisionsTypes[parentIndex]
//                          .ageGroups![childIndex]
//                          .weightAvailable ??
//                          [],
//                    )
//                  ],
//                 ],
//               ),
//             );
//             // return
//             //   customRegularExpansionTile
//             //     (
//             //     isBackDropDarker: false,
//             //     isAppSettingsView: false,
//             //     leading: buildLeadingForDivisionTile(
//             //         isParent: false,
//             //         number: divisionsTypes[parentIndex]
//             //             .ageGroups![childIndex]
//             //             .selectedAthletesForCount!
//             //             .length,
//             //         isExpanded: divisionsTypes[parentIndex]
//             //             .ageGroups![childIndex]
//             //             .isExpanded!),
//             //     children: [
//             //       buildExpansionPanelAthleteList(
//             //         openAthlete: (i) {
//             //           openAthlete(
//             //               divisionsTypes[parentIndex]
//             //                   .ageGroups![childIndex]
//             //                   .expansionPanelAthlete![i],
//             //               parentIndex,
//             //               childIndex,
//             //               i);
//             //         },
//             //         addAthlete: (ageGroup) {
//             //           BlocProvider.of<EventDetailsBloc>(
//             //               navigatorKey.currentContext!)
//             //               .add(TriggerSetIndex(
//             //             childIndex: childIndex,
//             //             parentIndex: parentIndex,
//             //           ));
//             //           Navigator.pushNamed(
//             //               navigatorKey.currentContext!,
//             //               AppRouteNames.routeEventAthleteSelection);
//             //         },
//             //         ageGroup: divisionsTypes[parentIndex]
//             //             .ageGroups![childIndex],
//             //         ageGroupWithExpansionPanelWeights:
//             //         divisionsTypes[parentIndex]
//             //             .ageGroups![childIndex]
//             //             .ageGroupWithExpansionPanelWeights ??
//             //             [],
//             //         weightAvailable: divisionsTypes[parentIndex]
//             //             .ageGroups![childIndex]
//             //             .weightAvailable ??
//             //             [],
//             //         expansionPanelAthletes:
//             //         divisionsTypes[parentIndex]
//             //             .ageGroups![childIndex]
//             //             .expansionPanelAthlete ??
//             //             [],
//             //       ),
//             //     ],
//             //     onExpansionChanged: (value) {
//             //       openChild(value, parentIndex, childIndex);
//             //     },
//             //     isExpansionTileOpened: divisionsTypes[parentIndex]
//             //         .ageGroups![childIndex]
//             //         .isExpanded!,
//             //     title: divisionsTypes[parentIndex]
//             //         .ageGroups![childIndex]
//             //         .title!);
//           },
//           separatorBuilder: (context, childIndex) {
//             return Container(height: 10.h);
//           },
//           itemCount: divisionsTypes[parentIndex].ageGroups!.length)
//       // ListView.separated(
//       //     padding: EdgeInsets.only( left: 10.w, right: 10.w),
//       //     shrinkWrap: true,
//       //     itemBuilder: (context, parentIndex) {
//       //       return customRegularExpansionTile(
//       //           isAppSettingsView: false,
//       //           isBackDropDarker: true,
//       //           leading: buildLeadingForDivisionTile(
//       //               isParent: true,
//       //               number: divisionsTypes[parentIndex]
//       //                       .ageGroups!.fold<int>(
//       //                           0,
//       //                           (previousValue, element) =>
//       //                               previousValue +
//       //                               element.selectedAthletesForCount!.length)
//       //                   // +
//       //                   // divisionsTypes[parentIndex].ageGroups!.fold<int>(
//       //                   //     0,
//       //                   //     (previousValue, element) =>
//       //                   //         previousValue +
//       //                   //         element.expansionPanelAthlete!
//       //                   //             .where((element) =>
//       //                   //                 (element.isAthleteTaken ?? false) &&
//       //                   //                 element.athleteStyles!.any((e) =>
//       //                   //                     (e.temporarilySelectedWeights == null
//       //                   //                         ? false
//       //                   //                         : e.temporarilySelectedWeights!
//       //                   //                             .isNotEmpty)))
//       //                   //             .length)
//       //               ,
//       //               isExpanded: divisionsTypes[parentIndex].isExpanded!),
//       //           children: [
//       //             ListView.separated(
//       //               physics:const NeverScrollableScrollPhysics(),
//       //                 shrinkWrap: true,
//       //                 padding: EdgeInsets.zero,
//       //                 itemBuilder: (context, childIndex) {
//       //                   return customRegularExpansionTile(
//       //                       isBackDropDarker: false,
//       //                       isAppSettingsView: false,
//       //                       leading: buildLeadingForDivisionTile(
//       //                           isParent: false,
//       //                           number: divisionsTypes[parentIndex]
//       //                               .ageGroups![childIndex]
//       //                               .selectedAthletesForCount!
//       //                               .length,
//       //                           isExpanded: divisionsTypes[parentIndex]
//       //                               .ageGroups![childIndex]
//       //                               .isExpanded!),
//       //                       children: [
//       //                         buildExpansionPanelAthleteList(
//       //                           openAthlete: (i) {
//       //                             openAthlete(
//       //                                 divisionsTypes[parentIndex]
//       //                                     .ageGroups![childIndex]
//       //                                     .expansionPanelAthlete![i],
//       //                                 parentIndex,
//       //                                 childIndex,
//       //                                 i);
//       //                           },
//       //                           addAthlete: (ageGroup) {
//       //                             BlocProvider.of<EventDetailsBloc>(
//       //                                     navigatorKey.currentContext!)
//       //                                 .add(TriggerSetIndex(
//       //                               childIndex: childIndex,
//       //                               parentIndex: parentIndex,
//       //                             ));
//       //                             Navigator.pushNamed(
//       //                                 navigatorKey.currentContext!,
//       //                                 AppRouteNames.routeEventAthleteSelection);
//       //                           },
//       //                           ageGroup: divisionsTypes[parentIndex]
//       //                               .ageGroups![childIndex],
//       //                           ageGroupWithExpansionPanelWeights:
//       //                               divisionsTypes[parentIndex]
//       //                                       .ageGroups![childIndex]
//       //                                       .ageGroupWithExpansionPanelWeights ??
//       //                                   [],
//       //                           weightAvailable: divisionsTypes[parentIndex]
//       //                                   .ageGroups![childIndex]
//       //                                   .weightAvailable ??
//       //                               [],
//       //                           expansionPanelAthletes:
//       //                               divisionsTypes[parentIndex]
//       //                                       .ageGroups![childIndex]
//       //                                       .expansionPanelAthlete ??
//       //                                   [],
//       //                         ),
//       //                       ],
//       //                       onExpansionChanged: (value) {
//       //                         openChild(value, parentIndex, childIndex);
//       //                       },
//       //                       isExpansionTileOpened: divisionsTypes[parentIndex]
//       //                           .ageGroups![childIndex]
//       //                           .isExpanded!,
//       //                       title: divisionsTypes[parentIndex]
//       //                           .ageGroups![childIndex]
//       //                           .title!);
//       //                 },
//       //                 separatorBuilder: (context, childIndex) {
//       //                   return Container(height: 10.h);
//       //                 },
//       //                 itemCount: divisionsTypes[parentIndex].ageGroups!.length)
//       //           ],
//       //           onExpansionChanged: (value) {
//       //             openParent(
//       //               value,
//       //               parentIndex,
//       //             );
//       //           },
//       //           isExpansionTileOpened: divisionsTypes[parentIndex].isExpanded!,
//       //           title: divisionsTypes[parentIndex].divisionType!);
//       //     },
//       //     separatorBuilder: (context, parentIndex) {
//       //       return SizedBox(
//       //         height: 10.h,
//       //       );
//       //     },
//       //     itemCount: divisionsTypes.length),
//       );
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/presentation/event_details/bloc/event_details_bloc.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';
import 'build_wrap_of_athletes.dart';
import 'build_wrap_of_weights.dart';

Expanded buildListOfDivisions(
    {required void Function(Athlete, int, int, int) openAthlete,
      required List<DivisionTypes> divisionsTypes,
      required void Function(bool, int) openParent,
      required void Function(bool, int, int) openChild,
      required int parentIndex,
      bool isFromRegs = false}) {


  return Expanded(
      child: divisionsTypes.isNotEmpty &&  divisionsTypes[parentIndex].ageGroups != null?
      ListView.separated(
          // physics: isFromRegs
          //     ? const BouncingScrollPhysics()
          //     : const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          itemBuilder: (context, childIndex) {
            return Container(

              width: Dimensions.getScreenWidth(),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.r),
                color: AppColors.colorSecondary,
              ),
              // margin: EdgeInsets.symmetric(horizontal: 8.w),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [

                      Expanded(
                        flex: 4,
                        child: GestureDetector(
                          onTap: (){
                            BlocProvider.of<EventDetailsBloc>(context).add(TriggerOpenAgeGroup(
                                divIndex: parentIndex,
                                ageGroupIndex: childIndex
                            ));
                          },
                          child: Text(
                              divisionsTypes[parentIndex]
                                  .ageGroups![childIndex]
                                  .title!,
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.subtitle(isOutFit: false)),
                        ),
                      ),
                       Expanded(
                        child: GestureDetector(
                          onTap: (){
                            BlocProvider.of<EventDetailsBloc>(context).add(TriggerOpenAgeGroup(
                                divIndex: parentIndex,
                                ageGroupIndex: childIndex
                            ));
                          },
                            child: const SizedBox()),
                      ),
                      if (divisionsTypes[parentIndex]
                          .ageGroups![childIndex]
                          .isExpanded ?? false) ...[
                        TextButton(
                            onPressed: () {
                              openChild(false, parentIndex,childIndex);
                            },
                            child: Text('Close',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 2,
                                    decorationColor:
                                    AppColors.colorPrimaryAccent,
                                    fontSize: 12.sp,
                                    color: AppColors.colorPrimaryAccent,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: AppFontFamilies.squada)))
                      ]
                      else ...[
                        TextButton(
                            onPressed: () {
                              openChild(true, parentIndex, childIndex);
                            },
                            child: Text('Available WC',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 2,
                                    decorationColor:
                                    AppColors.colorPrimaryNeutralText,
                                    color: AppColors.colorPrimaryNeutralText,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: AppFontFamilies.squada)))
                      ],
                      GestureDetector(
                        onTap: () {
                          // BlocProvider.of<EventDetailsBloc>(
                          //         navigatorKey.currentContext!)
                          //     .add(TriggerSetIndex(
                          //   childIndex: childIndex,
                          //   parentIndex: parentIndex,
                          // ));
                          BlocProvider.of<EventDetailsBloc>(context).add(TriggerOpenAgeGroup(
                              divIndex: parentIndex,
                              ageGroupIndex: childIndex
                          ));
                          // Navigator.pushNamed(navigatorKey.currentContext!,
                          //     AppRouteNames.routeEventAthleteSelection);

                        },
                        child: Container(
                          width: 65.w,
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.r),
                            color: AppColors.colorSecondaryAccent,
                          ),
                          child: Center(
                            child: Text(
                              AppStrings.btn_add,
                              style: AppTextStyles.regularPrimary(
                                isOutFit: false,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  if(divisionsTypes[parentIndex]
                      .ageGroups![childIndex]
                      .expansionPanelAthlete!.isNotEmpty) ...[
                    buildWrapOfAthletes(
                        openAthlete: (i) {
                          // openChild(true, parentIndex, childIndex);
                          openAthlete(
                              divisionsTypes[parentIndex]
                                  .ageGroups![childIndex]
                                  .expansionPanelAthlete![i],
                              parentIndex,
                              childIndex,
                              i);
                        },
                        ageGroup:
                        divisionsTypes[parentIndex].ageGroups![childIndex],
                        expansionPanelAthletes: divisionsTypes[parentIndex]
                            .ageGroups![childIndex]
                            .expansionPanelAthlete ??
                            [],
                        addAthlete: (age) {}),
                    SizedBox(height: 10.h),
                  ],

                  if(divisionsTypes[parentIndex]
                      .ageGroups![childIndex]
                      .isExpanded!)...[

                    Divider(
                      color: AppColors.colorDisabled,
                      thickness: 0.5.h,
                    ),
                    buildWrapOfWeights(
                      ageGroupWithExpansionPanelWeights:
                      divisionsTypes[parentIndex]
                          .ageGroups![childIndex]
                          .ageGroupWithExpansionPanelWeights ??
                          [],
                      weightAvailable: divisionsTypes[parentIndex]
                          .ageGroups![childIndex]
                          .weightAvailable ??
                          [],
                    )
                  ],
                ],
              ),
            );

          },
          separatorBuilder: (context, childIndex) {
            return Container(height: 10.h);
          },
          itemCount: divisionsTypes[parentIndex].ageGroups!.length):
          Container()

  );
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';
import '../bloc/placement_bloc.dart';

class PlacementView extends StatefulWidget {
  const PlacementView({super.key, required this.id});

  final String id;

  @override
  State<PlacementView> createState() => _PlacementViewState();
}

class _PlacementViewState extends State<PlacementView> {
  @override
  void initState() {
    BlocProvider.of<PlacementBloc>(context)
        .add(TriggerPlacementList(widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return customScaffold(
        customAppBar: CustomAppBar(
          title: 'Ranking',
          isLeadingPresent: true,
        ),
        hasForm: false,
        formOrColumnInsideSingleChildScrollView: null,
        anyWidgetWithoutSingleChildScrollView:
            BlocBuilder<PlacementBloc, PlacementState>(
          builder: (context, state) {
            return state.isLoading
                ? CustomLoader(
                    child: buildRankUI(state),
                  )
                : buildRankUI(state);
          },
        ));
  }

  Column buildRankUI(PlacementState state) {

    return state.placements.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: AppColors.colorTertiary,
                    borderRadius: BorderRadius.circular(5.r)),
                width: double.infinity,
                height: 35.h,
                padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 2.w),
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () {
                          BlocProvider.of<PlacementBloc>(context)
                              .add(TriggerSelectDivision(i));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          decoration: BoxDecoration(
                              color: state.selectedDivType == i
                                  ? AppColors.colorPrimaryAccent
                                  : AppColors.colorTertiary,
                              borderRadius: BorderRadius.circular(5.r)),
                          child: Center(
                            child: Text(
                              StringManipulation.capitalizeFirstLetterOfEachWord(
                                  value: state.placements[i].divisionType!),
                              style: AppTextStyles.subtitle(isOutFit: false),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, i) {
                      return Container(
                        width: 0.w,
                      );
                    },
                    itemCount: state.placements.length),
              ),
              SizedBox(
                height: 10.h,
              ),
              Flexible(
                  child: ListView.separated(
                      itemBuilder: (context, i) {
                        return customRegularExpansionTile(
                          isParent: true,
                          isBackDropDarker: true,
                          isNumZero: state.placements[state.selectedDivType]
                              .divisions![i].weightClasses!.isEmpty,
                          leading:
                          state.placements[state.selectedDivType]
                                  .divisions![i].weightClasses!.isEmpty
                              ?
                          SizedBox(width:15.w)
                              : buildLeadingForDivisionTile(
                                  isParent: false,
                                  isExpanded: state.placements[state.selectedDivType]
                                      .divisions![i].isExpanded!,
                                  number: state
                                      .placements[state.selectedDivType]
                                      .divisions![i]
                                      .weightClasses!
                                      .length),
                          children: [
                            ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return customRegularExpansionTile(
                                    isNumZero: true,
                                      isParent: false,
                                      leading: SizedBox(width: 15.w),
                                      children: [
                                        ListView.separated(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, j){
                                             return Container(
                                               width: Dimensions.getScreenWidth(),
                                          decoration: BoxDecoration(
                                            color: AppColors.colorTertiary,
                                            borderRadius: BorderRadius.circular(5.r),
                                          ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.w, vertical: 3.h
                                          ),
                                            child: Row(
                                              children: [
                                                buildCustomAthleteProfileHolder(
                                                  imageUrl: state.placements[state.selectedDivType].divisions![i].
                                                      weightClasses![index]
                                                      .athletes![j]
                                                      .athleteDetails!.profileImage!,
                                                  age: state.placements[state.selectedDivType].divisions![i].
                                                  weightClasses![index]
                                                      .athletes![j]
                                                      .athleteDetails!
                                                      .age
                                                      .toString(),
                                                  weight: state.placements[state.selectedDivType].divisions![i].
                                                  weightClasses![index]
                                                      .athletes![j]
                                                      .athleteDetails!
                                                      .weight
                                                      .toString()),
                                                SizedBox(width: 10.w,),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: Dimensions.getScreenWidth() * 0.4,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              StringManipulation.combineFirstNameWithLastName(
                                                                  firstName: state.placements[state.selectedDivType].divisions![i].
                                                                  weightClasses![index]
                                                                      .athletes![j]
                                                                      .athleteDetails!
                                                                      .firstName!,
                                                                  lastName: state.placements[state.selectedDivType].divisions![i].
                                                                  weightClasses![index]
                                                                      .athletes![j]
                                                                      .athleteDetails!
                                                                      .lastName!),
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: AppTextStyles.smallTitle(isOutFit: false),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),

                                                  ],
                                                ),
                                                const Spacer(),
                                                SvgPicture.asset(
                                                  AppAssets.icRank,
                                                  width: 20.w,
                                                  height: 20.h,
                                                  color: AppColors.colorPrimaryAccent,
                                                ),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                Text(
                                                  state.placements[state.selectedDivType].divisions![i].
                                                  weightClasses![index]
                                                      .athletes![j]
                                                      .rank!
                                                      .toString(),
                                                  style: AppTextStyles.smallTitle(isOutFit: false),
                                                ),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                              ],
                                            ),
                                          );
                                        }, separatorBuilder: (context, j){
                                          return SizedBox(height: 10.h,);
                                        }, itemCount: state
                                            .placements[state.selectedDivType]
                                            .divisions![i]
                                            .weightClasses![index]
                                            .athletes!
                                            .length)
                                      ],
                                      onExpansionChanged: (va) {
                                         setState(() {
                                            state.placements[state.selectedDivType]
                                                .divisions![i]
                                                .weightClasses![index]
                                                .isExpanded = va;
                                         });
                                      },
                                      isExpansionTileOpened: state
                                          .placements[state.selectedDivType]
                                          .divisions![i]
                                          .weightClasses![index]
                                          .isExpanded!,
                                      title: state
                                          .placements[state.selectedDivType]
                                          .divisions![i]
                                          .weightClasses![index]
                                          .weightClass!
                                          .weight!
                                          .toString());

                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: 10.h,
                                  );
                                },
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state
                                    .placements[state.selectedDivType]
                                    .divisions![i]
                                    .weightClasses!
                                    .length)
                          ],
                          onExpansionChanged: (value) {
                            setState(() {
                              state.placements[state.selectedDivType]
                                  .divisions![i]
                                  .isExpanded = value;
                            });
                          },
                          isExpansionTileOpened: state.placements[state.selectedDivType]
                              .divisions![i].isExpanded!,
                          title: StringManipulation
                              .capitalizeFirstLetterOfEachWord(
                                  value: state.placements[state.selectedDivType]
                                      .divisions![i].title!),
                        );
                      },
                      separatorBuilder: (context, i) {
                        return SizedBox(
                          height: 10.h,
                        );
                      },
                      itemCount: state
                          .placements[state.selectedDivType].divisions!.length))
            ],
          )
        : Column(
            children: [
              SizedBox(
                height: Dimensions.getScreenHeight() * 0.35,
              ),
              if(!state.isLoading)
              Center(
                child: Text(
                    'There are no rankings available yet.\nThey will come very soon.\nPlease be patient.',
                    style: AppTextStyles.smallTitleForEmptyList(),
                    textAlign: TextAlign.left),
              ),
            ],
          );
  }
}

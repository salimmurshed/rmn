import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/widgets/cards/build_athlete_visible_athlete_item.dart';
import '../../../imports/common.dart';
import '../../../root_app.dart';
import '../bloc/buy_season_passes_bloc.dart';

Container buildAthletesVisibleForSelection(
    {bool isScrollable = true, required SeasonPassesWithInitialState state}) {
  return state.athletesWithoutSeasonPass.isEmpty
      ? Container(
          margin: EdgeInsets.only(top: Dimensions.getScreenHeight() * 0.1),
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Center(
            child: Text(
              AppStrings
                  .buySeasonPasses_athleteWithoutSeasonPass_emptyList_text,
              style: AppTextStyles.smallTitleForEmptyList(),
            ),
          ),
        )
      : Container(
          margin: EdgeInsets.only(top: 30.h),
          height: isScrollable ? Dimensions.getScreenHeight() * 0.6 : null,
          child: ListView.separated(
              shrinkWrap: true,
              physics: isScrollable
                  ? const AlwaysScrollableScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return buildVisibleAthleteItem(
                  removeAthlete: () {
                    BlocProvider.of<BuySeasonPassesBloc>(context).add(
                        TriggerAthleteRemove(
                            athleteIndex: index,
                            athletes: state.athletesWithoutSeasonPass));
                  },
                  openBottomSheet: () {
                    BlocProvider.of<BuySeasonPassesBloc>(context)
                        .add(TriggerRefreshSeasonPassBottomSheet(index: index));
                    buildCustomShowModalBottomSheetParent(
                        isNavigationRequired: false,
                        ctx: navigatorKey.currentContext!,
                        child: BlocBuilder<BuySeasonPassesBloc,
                            SeasonPassesWithInitialState>(
                          builder: (context, state) {
                            return buildBottomSheetWithBodyCheckboxList(
                              disclaimer: '',
                              isCheckListForWeightClass: false,
                              isLoading: state.isLoadingSeasonPasses,
                              isUpdateWCInactive: false,
                              onTapForUpdate: () {
                                Navigator.pop(context);
                                BlocProvider.of<BuySeasonPassesBloc>(context)
                                    .add(
                                  TriggerUpdateAthleteMembership(
                                      athleteIndex: index,
                                      athletes: state.athletesWithoutSeasonPass,
                                      seasonPassTitle:
                                          state.currentSeasonPassTitle),
                                );
                              },
                              onTapToSelectTile: (value) {
                                BlocProvider.of<BuySeasonPassesBloc>(context)
                                    .add(
                                  TriggerSelectSeasonPass(
                                    athleteIndex: index,
                                    athletes: state.athletesWithoutSeasonPass,
                                    seasonPassTitle:
                                        state.seasonPasses[value].title!,
                                  ),
                                );
                              },
                              context: context,
                              isFromPurchaseHistory: true,
                              listOfAllRegisteredOptions: [],
                              listOfAllOptions: state.seasonPasses
                                  .map((e) => e.title!)
                                  .toList(),
                              listOfAllSelectedOption: [
                                state.athletesWithoutSeasonPass[index]
                                    .temporarySeasonPassTitle!
                              ],
                              listOfStyleTitles: [],
                              athleteAge: state
                                  .athletesWithoutSeasonPass[index].age
                                  .toString(),
                              athleteWeight: state
                                  .athletesWithoutSeasonPass[index].weightClass
                                  .toString(),
                              athleteImageUrl: state
                                  .athletesWithoutSeasonPass[index]
                                  .profileImage!,
                              athleteNameAsTheTitle: StringManipulation
                                  .combineFirstNameWithLastName(
                                      firstName: state
                                          .athletesWithoutSeasonPass[index]
                                          .firstName!,
                                      lastName: state
                                          .athletesWithoutSeasonPass[index]
                                          .lastName!),
                              checkBoxForWeightClassSelection: (value) {},
                              selectedStyleIndex: 0,
                              selectStyle: (styleIndex) {},
                            );
                          },
                        ));
                  },
                  noMembership:
                      state.athletesWithoutSeasonPass[index].membership != null,
                  weightClass: state
                      .athletesWithoutSeasonPass[index].weightClass
                      .toString(),
                  age: state.athletesWithoutSeasonPass[index].age.toString(),
                  imageUrl:
                      state.athletesWithoutSeasonPass[index].profileImage!,
                  firstName: state.athletesWithoutSeasonPass[index].firstName!,
                  lastName: state.athletesWithoutSeasonPass[index].lastName!,
                  index: index,
                  selectedSeasonPassTitle: state
                          .athletesWithoutSeasonPass[index]
                          .selectedSeasonPassTitle!
                          .isEmpty
                      ? AppStrings
                          .buySeasonPasses_athleteWithoutSeasonPass_bottomSheetButton_title
                      : state.athletesWithoutSeasonPass[index]
                          .selectedSeasonPassTitle!,
                );
              },
              separatorBuilder: (context, index) {
                return Container(
                  height: 20,
                );
              },
              itemCount: state.athletesWithoutSeasonPass.length));
}

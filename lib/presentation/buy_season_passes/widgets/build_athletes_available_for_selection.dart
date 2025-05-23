import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';
import '../bloc/buy_season_passes_bloc.dart';
import 'build_available_athletes.dart';

Container buildAthletesAvailableForSelection(BuildContext context, SeasonPassesWithInitialState state) {
  return Container(
    margin: EdgeInsets.only(top: 20.h),
    child: Row(
      children: [
        Text(
            AppStrings
                .buySeasonPasses_athleteWithoutSeasonPass_title,
            style: AppTextStyles.largeTitle()),
        const Spacer(),
        GestureDetector(
          onTap: state
              .athletesAvailableForSelection.isNotEmpty?
              () {
            buildCustomShowModalBottomSheetParent(
                isNavigationRequired: false,
                ctx: context,
                child: BlocBuilder<BuySeasonPassesBloc,
                    SeasonPassesWithInitialState>(
                  bloc: BlocProvider.of<
                      BuySeasonPassesBloc>(context),
                  builder: (context, state) {
                    return customBottomSheetBasicBody(
                        isActive:
                        state.isAnAthleteAddedBack,
                        title: AppStrings
                            .buySeasonPass_selectAthlete_bottomSheet_title,
                        footerNote: AppStrings
                            .buySeasonPass_selectAthlete_bottomSheet_subtitle,
                        widget: buildAvailableAthletes(
                          state,
                        ),
                        isSingeButtonPresent: false,
                        singleButtonText: AppStrings
                            .global_empty_string,
                        isSingleButtonColorFilled:
                        false,
                        context: context,
                        rightButtonText:
                        AppStrings.btn_accept,
                        leftButtonText:
                        AppStrings.btn_cancel,
                        onRightButtonPressed: state
                            .isAnAthleteAddedBack
                            ? () {
                          Navigator.pop(context);
                          BlocProvider.of<
                              BuySeasonPassesBloc>(
                              context)
                              .add(TriggerAddAthleteBackToList(
                              availableAthletes:
                              state
                                  .athletesAvailableForSelection,
                              athletesWithoutSeasonPass:
                              state
                                  .athletesWithoutSeasonPass));
                        }
                            : () {},
                        onLeftButtonPressed: () {
                          Navigator.pop(context);
                        },
                        highLightedAthleteName:
                        AppStrings
                            .global_empty_string,
                        singleButtonFunction: () {});
                  },
                ));
          }:(){},
          child: Container(
            height: 30.h,
            width: 30.w,
            padding: EdgeInsets.all(5.r),
            decoration: BoxDecoration(
                color: state
                    .athletesAvailableForSelection.isNotEmpty?
                AppColors.colorSecondaryAccent:AppColors.colorBlueOpaque,
                borderRadius: BorderRadius.circular(
                    Dimensions.generalSmallRadius)),
            child: SvgPicture.asset(AppAssets.icAdd),
          ),
        )
      ],
    ),
  );
}
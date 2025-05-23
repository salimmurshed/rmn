import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../data/models/response_models/season_passes_response_model.dart';
import '../../../imports/common.dart';
import '../../../root_app.dart';
import '../bloc/buy_season_passes_bloc.dart';

// List<SeasonPass> state.seasonPasses =[
//   SeasonPass(
//     id: "Season Pass 1",
//     description: "This is a description of the season pass",
//     content: [
//       "This is the first content of the season pass",
//       "This is the second content of the season pass",
//       "This is the third content of the season pass",
//       "This is the fourth content of the season pass",
//       "This is the fifth content of the season pass",
//     ],
//     title: "Season Pass 1",
//   ),
//   SeasonPass(
//     id: "Season Pass 2",
//     description: "This is a description of the season pass",
//     content: [
//       "This is the first content of the season pass",
//       "This is the second content of the season pass",
//       "This is the third content of the season pass",
//       "This is the fourth content of the season pass",
//       "This is the fifth content of the season pass",
//     ],
//     title: "Season Pass 1",
//   ),
//   SeasonPass(
//     id: "Season Pass 3",
//     description: "This is a description of the season pass",
//     content: [
//       "This is the first content of the season pass",
//       "This is the second content of the season pass",
//       "This is the third content of the season pass",
//       "This is the fourth content of the season pass",
//       "This is the fifth content of the season pass",
//     ],
//     title: "Season Pass 1",
//   )
// ];
Widget buildCarouselSliderForSeasonPasses(
    SeasonPassesWithInitialState state, BuildContext context) {
  return state.seasonPasses.length == 1
      ? sliderCard(state, 0, state.seasonPasses[0], true)
      : CarouselSlider(
          options: CarouselOptions(
            scrollPhysics: const BouncingScrollPhysics(),
            onPageChanged: (index, reason) {
              if (reason == CarouselPageChangedReason.manual) {
                BlocProvider.of<BuySeasonPassesBloc>(context)
                    .add(TriggerUpdateSeasonPassesSliderIndex(index: index));
              }
            },
            viewportFraction:isTablet ? 0.85:
            0.8,
            aspectRatio: isTablet ? 1.17:
            0.95,
            enlargeCenterPage: true,
          ),
          items: state.seasonPasses.map((seasonPass) {
            final currentIndex = state.seasonPasses
                .indexWhere((element) => element.id == seasonPass.id);
            return Builder(
              builder: (BuildContext context) {
                return sliderCard(state, currentIndex, seasonPass, null);
              },
            );
          }).toList(),
        );
}

Widget sliderCard(SeasonPassesWithInitialState state, int currentIndex,
    SeasonPass seasonPass, bool? isSingleCard) {
  return InkWell(
    splashColor: Colors.transparent,
    onTap: () {
      buildBottomSheetWithBodyText(
        context: navigatorKey.currentContext!,
        title: seasonPass.title!,
        subtitle: seasonPass.description!,
        isSingeButtonPresent: true,
        isSingleButtonColorFilled: true,
        singleButtonText: AppStrings.btn_ok,
        singleButtonFunction: () {
          Navigator.of(navigatorKey.currentContext!).pop();
        },
        onLeftButtonPressed: () {},
        onRightButtonPressed: () {},
      );
    },
    child: Container(
      height: 250.h,
      margin: EdgeInsets.symmetric(
          vertical: 10.h, horizontal: isSingleCard == null ? 2.w : 5.w),
      padding:
          EdgeInsets.only(right: 20.w, left: 20.w, top: 20.h, bottom: 10.h),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.white38,
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(-2, -3),
          ),
          BoxShadow(
            color: Colors.white38,
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(2, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(10.r),
        color: state.currentSeasonPassIndex == currentIndex
            ? AppColors.colorSecondaryAccent
            : AppColors.colorTertiary,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(seasonPass.title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.largeTitle()),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(seasonPass.description!,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.subtitle(
                        color: AppColors.colorPrimaryNeutralText)),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Flexible(
            child: ListView.separated(
                controller: state.scrollController,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 5.h),
                        child: SvgPicture.asset(AppAssets.icPlanCheck),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: Text(seasonPass.content![index],
                            style: AppTextStyles.smallTitle(isOutFit: true)),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8.0);
                },
                itemCount: seasonPass.content!.length),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Divider(
              color: AppColors.colorPrimaryNeutral,
              height: 2.h,
              thickness: 1.5.w,
            ),
          ),
          IntrinsicWidth(
            child: Container(
              padding: EdgeInsets.all(5.r),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  color: AppColors.colorPrimary),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("for just ",
                      style: AppTextStyles.subtitle(
                          color: AppColors.colorPrimaryNeutralText)),
                  Text(
                      StringManipulation.addADollarSign(
                          price: seasonPass.price ?? 0),
                      style: AppTextStyles.largeTitle(
                          color: AppColors.colorPrimaryInverseText)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 30.0),
        ],
      ),
    ),
  );
}

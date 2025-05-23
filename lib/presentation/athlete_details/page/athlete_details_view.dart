import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rmnevents/data/models/arguments/athlete_argument.dart';
import 'package:rmnevents/presentation/athlete_details/widgets/build_athlete_info_section.dart';
import '../../../imports/common.dart';
import '../../../root_app.dart';
import '../../base/bloc/base_bloc.dart';
import '../bloc/athlete_details_bloc.dart';
import '../widgets/build_athlete_profile_section.dart';
import '../widgets/build_awards_list.dart';
import '../widgets/build_event_list_tab_view.dart';
import '../widgets/build_loader_for_tab_selection.dart';
import '../widgets/build_metrics_section.dart';
import '../widgets/build_rank_list.dart';
import '../widgets/build_season_list_drop_down.dart';
import '../widgets/build_tab_bar.dart';

class AthleteDetailsView extends StatefulWidget {
  final String athleteId;

  const AthleteDetailsView({super.key, required this.athleteId});

  @override
  State<AthleteDetailsView> createState() => _AthleteDetailsViewState();
}

class _AthleteDetailsViewState extends State<AthleteDetailsView> {
  @override
  void initState() {
    BlocProvider.of<AthleteDetailsBloc>(context)
        .add(TriggerRefreshAthleteDetails());
    BlocProvider.of<BaseBloc>(context)
        .add(TriggerSeasonsFetch(athleteId: widget.athleteId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AthleteDetailsBloc, AthleteDetailsWithInitialState>(
      listener: (context, state) {
        // if (state.message.isNotEmpty) {
        //   buildCustomToast(msg: state.message, isFailure: state.isFailure);
        // }
      },
      child: BlocBuilder<AthleteDetailsBloc, AthleteDetailsWithInitialState>(
        builder: (context, state) {
          return buildAthleteDetailsLayout(context, state);
        },
      ),
    );
  }

  Widget buildAthleteDetailsLayout(
      BuildContext context, AthleteDetailsWithInitialState state) {
    return customScaffold(
      customAppBar: CustomAppBar(
        title: AppStrings.athleteDetails_title,
        isLeadingPresent: true,
        goBack: () {
          Navigator.pop(context);
          isFirstTimeOpenedC = true;
          isFirstTimeOpenedV = true;
        },
        customActionWidget: state.athlete?.userStatus != 'owner'
            ? null
            : Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(Dimensions.appBarToolRadius),
                  color: AppColors.colorSecondaryAccent,
                ),
                child: Center(
                  child: SvgPicture.asset(AppAssets.icEdit,
                      height: (isTablet ? 20.h : 15.h),
                      width: (isTablet ? 20.w : 15.w),
                      fit: BoxFit.cover),
                ),
              ),
        //appBarActionSvgAddress: AppAssets.icEdit,
        appBarActionFunction: () {
          if (!state.isLoadingAthleteInfo) {
            Navigator.pushNamed(
                context, AppRouteNames.routeCreateOrEditAthleteProfile,
                arguments: AthleteArgument(
                    createProfileType:
                        CreateProfileTypes.editProfileForAthlete));
          }
        },
        color: state.athlete?.userStatus != 'owner'
            ? Colors.transparent
            : AppColors.colorSecondaryAccent,
      ),
      hasForm: false,
      formOrColumnInsideSingleChildScrollView: state.isLoadingAthleteInfo
          ? SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Center(child: CustomLoader(child: Container())),
            )
          : SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildAthleteProfileSection(state, context),
                  buildSeasonListDropDown(context, state),
                  buildMetricsSection(state),
                  buildTabBar(context, state),
                  if (state.tabNo == 2) ...[
                    if (state.lastUpdate != null)
                      Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.colorSecondaryAccent, width: 1),
                          borderRadius: BorderRadius.circular(
                            Dimensions.generalRadius,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.screenHorizontalGap,
                            vertical: 10.h),
                        child: RichText(
                            text: TextSpan(
                          text: 'Last update: ',
                          style: AppTextStyles.normalPrimary(),
                          children: <TextSpan>[
                            TextSpan(
                                text: GlobalHandlers.formatDateToThMonthYear(
                                    dateString: state.lastUpdate!.updatedAt!),
                                style:
                                    AppTextStyles.normalPrimary(isBold: true)),
                            TextSpan(
                                text: ' | Event: ',
                                style: AppTextStyles.normalPrimary()),
                            TextSpan(
                                text: state.lastUpdate!.event!.title!,
                                style:
                                    AppTextStyles.normalPrimary(isBold: true)),
                            TextSpan(
                                text:
                                    ' Read more about the rules & conditions of our awards ',
                                style: AppTextStyles.normalPrimary()),
                            TextSpan(
                                text: 'here',
                                style: TextStyle(
                                    fontFamily: AppFontFamilies.outfit,
                                    fontSize: AppFontSizes.normal,
                                    color: AppColors.colorPrimaryAccent,
                                    decoration: TextDecoration.underline,
                                    height: 1),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {}),
                            TextSpan(
                              text: '.',
                              style: AppTextStyles.normalPrimary(),
                            ),
                          ],
                        )),
                      ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10.h),
                      height: 30.h,
                      width: Dimensions.getScreenWidth(),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: (){
                                BlocProvider.of<AthleteDetailsBloc>(context).add(TriggerFilterThroughDivList(index: index));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: state.selectedDivIndex == index
                                      ? AppColors.colorSecondaryAccent
                                      : AppColors.colorTertiary,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.generalSmallRadius),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 5.h),
                                child: Center(
                                  child: Text(
                                    state.divisions[index].title!,
                                    style: AppTextStyles.regularPrimary(
                                        isOutFit: false),
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Container(
                              width: 10.w,
                            );
                          },
                          itemCount: state.divisions.length),
                    ),
                  ],
                  if (state.isLoadingForTabs) ...[
                    buildLoaderForTabSelection(context)
                  ] else ...[
                    if (state.tabNo == 0 || state.tabNo == 1)
                      buildBuildEventListTabView(state, context),
                    if (state.tabNo == 2) buildAwardsList(awards: state.awards),
                    if (state.tabNo == 3) buildRankList(ranks: state.ranks)
                  ]
                ],
              ),
            ),
      anyWidgetWithoutSingleChildScrollView: null,
    );
  }
}

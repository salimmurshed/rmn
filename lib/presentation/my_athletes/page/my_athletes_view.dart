import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/data/models/arguments/athlete_argument.dart';
import 'package:rmnevents/presentation/base/bloc/base_bloc.dart';
import 'package:rmnevents/presentation/my_athletes/bloc/my_athletes_bloc.dart';
import 'package:rmnevents/presentation/my_athletes/bloc/my_athletes_handler.dart';
import 'package:rmnevents/presentation/my_athletes/widgets/build_empty_list_place_holder.dart';

import '../../../common/widgets/cards/custom_athlete_card.dart';
import '../../../imports/common.dart';
import '../../../root_app.dart';
import '../widgets/build_bottom_sheet_for_accept_reject.dart';
import '../widgets/build_bottom_sheet_for_access_request.dart';
import '../widgets/build_search_section.dart';

class MyAthletesView extends StatefulWidget {
  MyAthletesView({
    super.key,
    this.tabIndex,
  });

  int? tabIndex;

  @override
  State<MyAthletesView> createState() => _MyAthletesViewState();
}

class _MyAthletesViewState extends State<MyAthletesView> {
  @override
  void initState() {
    BlocProvider.of<MyAthletesBloc>(context).add(TriggerCleanScreen());
    BlocProvider.of<MyAthletesBloc>(context).add(TriggerFetchAthletes(
        searchKey: AppStrings.global_empty_string,
        page: 1,
        athletes: const [],
        isSearch: false,
        isInitState: true,
        isRequestClearTime: widget.tabIndex == 2,
        selectedTabIndex: widget.tabIndex ?? 0,
        isNewTab: AthleteApiCallType.newTab));
    super.initState();
  }

  int selectedTab = 0;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyAthletesBloc, MyAthletesWithInitialState>(
        listener: (context, state) {
          if (state.message.isNotEmpty) {
            buildCustomToast(msg: state.message, isFailure: state.isFailure);
            if (state.scrollerPosition > 0) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                state.currentScrollController.animateTo(state.scrollerPosition,
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut);
              });
            }
          }
          selectedTab = state.selectedTabNumber;
          searchController = state.searchController;
          setState(() {});
        },
        child: buildMyAthletesLayout());
  }

  Widget buildMyAthletesLayout() {
    return customScaffold(
        customAppBar: CustomAppBar(
          isNeededForCustomWidget: false,
          isLeadingPresent: true,
          title: AppStrings.myAthletes_title,
          customActionWidget: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(Dimensions.buttonBorderRadius),
                color: AppColors.colorSecondaryAccent),
            child: Center(
                child: Text(
                  AppStrings.profile_createAthlete_btn_text,
                  style: AppTextStyles.buttonTitle(),
                )),
          ),
          appBarActionFunction: () {
            Navigator.pushNamed(
                context, AppRouteNames.routeCreateOrEditAthleteProfile,
                arguments: AthleteArgument(createProfileType: CreateProfileTypes
                    .addAthleteFromMyList));
          },
        ),
        hasForm: true,
        formOrColumnInsideSingleChildScrollView: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BlocBuilder<MyAthletesBloc, MyAthletesWithInitialState>(
              builder: (context, state) {
                return buildSearchSection(
                  showSearchIcon: state.showSearchIcon,
                  searchText: state.searchController.text,
                  searchController: state.searchController,
                  searchFocusNode: state.searchFocusNode,
                  onFieldSubmitted: (value) {
                    BlocProvider.of<MyAthletesBloc>(context).add(
                        TriggerFetchAthletes(
                            searchKey: value,
                            isSearch: true,
                            athletes: const [],
                            selectedTabIndex: state.selectedTabNumber,
                            page: 1,
                            isNewTab: AthleteApiCallType.newTab));
                  },
                  onChanged: (value) {
                    BlocProvider.of<MyAthletesBloc>(context)
                        .add(TriggerCheckForSearchText(searchText: value));
                  },
                  onTapToSearch: state.showSearchIcon
                      ? () {
                    if (state.selectedTabNumber == 1) {
                      BlocProvider.of<MyAthletesBloc>(context).add(
                          TriggerFetchAthletes(
                              searchKey: state.searchController.text,
                              isSearch: true,
                              athletes: const [],
                              selectedTabIndex: state.selectedTabNumber,
                              page: 1,
                              isNewTab: AthleteApiCallType.newTab));
                    }
                    else {
                      BlocProvider.of<MyAthletesBloc>(context).add(
                          TriggerSearchInLocal());
                    }
                  }
                      : () {},
                  onTapToEraseSearchText: !state.showSearchIcon
                      ? () {
                    BlocProvider.of<MyAthletesBloc>(context).add(
                        TriggerFetchAthletes(
                            searchKey: AppStrings.global_empty_string,
                            isSearch: false,
                            isRequestClearTime:
                            state.selectedTabNumber == 2,
                            athletes: const [],
                            selectedTabIndex: state.selectedTabNumber,
                            page: 1,
                            isNewTab: AthleteApiCallType.newTab));
                  }
                      : () {},
                );
              },
            ),
            BlocBuilder<MyAthletesBloc, MyAthletesWithInitialState>(
              builder: (context, state) {
                return buildCustomTabBar(
                    isScrollRequired: false,
                    isRequestTab: true,
                    tabElements: [
                      TabElements(
                          title: AppStrings.myAthletes_myAthletes_tabBar_title,
                          onTap: state.isLoading || state.isBottomLoading
                              ? () {}
                              : () {
                            if (searchController.text.isNotEmpty) {
                              BlocProvider.of<MyAthletesBloc>(context)
                                  .add(TriggerFetchAthletes(
                                  searchKey: searchController.text,
                                  isSearch: true,
                                  athletes: const [],
                                  selectedTabIndex: 0,
                                  page: 1,
                                  isNewTab:
                                  AthleteApiCallType.newTab));
                            } else {
                              BlocProvider.of<MyAthletesBloc>(context)
                                  .add(TriggerFetchAthletes(
                                  searchKey:
                                  AppStrings.global_empty_string,
                                  isSearch: false,
                                  selectedTabIndex: 0,
                                  athletes: const [],
                                  page: 1,
                                  isNewTab:
                                  AthleteApiCallType.newTab));
                            }
                          },
                          isSelected: selectedTab == 0),
                      TabElements(
                          title:
                          AppStrings.myAthletes_findAthletes_tabBar_title,
                          onTap: state.isLoading || state.isBottomLoading
                              ? () {}
                              : () {
                            if (searchController.text.isNotEmpty) {
                              BlocProvider.of<MyAthletesBloc>(context)
                                  .add(TriggerFetchAthletes(
                                  searchKey: searchController.text,
                                  isSearch: true,
                                  athletes: const [],
                                  selectedTabIndex: 1,
                                  page: 1,
                                  isNewTab:
                                  AthleteApiCallType.newTab));
                            } else {
                              BlocProvider.of<MyAthletesBloc>(context)
                                  .add(TriggerFetchAthletes(
                                  searchKey:
                                  AppStrings.global_empty_string,
                                  isSearch: false,
                                  selectedTabIndex: 1,
                                  athletes: const [],
                                  page: 1,
                                  isNewTab:
                                  AthleteApiCallType.newTab));
                            }
                          },
                          isSelected: selectedTab == 1),
                      TabElements(
                          title: AppStrings.myAthletes_requests_tabBar_title,
                          onTap: state.isLoading || state.isBottomLoading
                              ? () {}
                              : () {
                            if (searchController.text.isNotEmpty) {
                              BlocProvider.of<MyAthletesBloc>(context)
                                  .add(TriggerFetchAthletes(
                                  isRequestClearTime: true,
                                  searchKey: searchController.text,
                                  isSearch: true,
                                  athletes: const [],
                                  selectedTabIndex: 2,
                                  page: 1,
                                  isNewTab:
                                  AthleteApiCallType.newTab));
                            } else {
                              BlocProvider.of<MyAthletesBloc>(context)
                                  .add(TriggerFetchAthletes(
                                  isRequestClearTime: true,
                                  searchKey:
                                  AppStrings.global_empty_string,
                                  isSearch: false,
                                  athletes: const [],
                                  selectedTabIndex: 2,
                                  page: 1,
                                  isNewTab:
                                  AthleteApiCallType.newTab));
                            }
                          },
                          isSelected: selectedTab == 2),
                    ]);
              },
            ),
            BlocBuilder<MyAthletesBloc, MyAthletesWithInitialState>(
              builder: (context, state) {
                return SizedBox(
                    height: Dimensions.getScreenHeight() * 0.68,
                    child: state.isLoading
                        ? CustomLoader(child: buildGridView(state, context))
                        : Column(
                      children: [
                        Expanded(child: buildGridView(state, context)),
                        Visibility(
                            visible: state.isBottomLoading,
                            child: CustomBottomLoader(child: Container()))
                      ],
                    )
                  // CustomBottomLoader(child: buildGridView(state, context)):
                  // buildGridView(state, context),
                );
              },
            ),
          ],
        ),
        anyWidgetWithoutSingleChildScrollView: null);
  }

  Column buildGridView(MyAthletesWithInitialState state, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!state.isLoading && state.athletes.isEmpty) ...[
          buildEmptyListPlaceHolder(
              context: context,
              showFooterButton: state.showFooterButton,
              textForEmptyList: state.textForEmptyList,
              selectedTab: state.selectedTabNumber)
        ] else
          ...[
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                controller: state.currentScrollController,
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: state.selectedTabNumber == 2 ? (isTablet
                      ? 0.87
                      : 0.75) : (isTablet ? 0.96 : 0.82),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: state.athletes.length,
                itemBuilder: (context, index) {
                  return customAthleteCard(
                    requestData: state.athletes[index].requestData,
                    teams: globalTeams,
                    seasons: globalSeasons,
                    athleteId: state.athletes[index].underscoreId!,
                    requestAthlete: () {
                      buildBottomSheetForRequestAccess(
                          athleteName:
                          StringManipulation.combineFirstNameWithLastName(
                              firstName: state.athletes[index].firstName!,
                              lastName: state.athletes[index].lastName!),
                          context: context,
                          radioButtonValue: state.radioButtonValue,
                          onTapCoachAccess: () {
                            BlocProvider.of<MyAthletesBloc>(context).add(
                              const TriggerRadioButtonValue(value: '3'),
                            );
                          },
                          onTapOwnerAccess: () {
                            BlocProvider.of<MyAthletesBloc>(context).add(
                              const TriggerRadioButtonValue(value: '2'),
                            );
                          },
                          onTapViewAccess: () {
                            BlocProvider.of<MyAthletesBloc>(context).add(
                              const TriggerRadioButtonValue(value: '1'),
                            );
                          },
                          onTapForRequest: () {
                            Navigator.pop(context);
                            BlocProvider.of<MyAthletesBloc>(context).add(
                              TriggerRequestAccess(
                                scrollController: state.currentScrollController,
                                athletes: state.athletes,
                                index: index,
                                selectedTabIndex: state.selectedTabNumber,
                                accessType: state.radioButtonValue,
                                athleteId:
                                state.athletes[index].underscoreId.toString(),
                              ),
                            );
                          },
                          userStatus: state.athletes[index].userStatus);
                    },
                    cancelRequest: () {
                      buildBottomSheetWithBodyText(
                          highLightedAthleteName:
                          StringManipulation.combineFirstNameWithLastName(
                              firstName: state.athletes[index].firstName!,
                              lastName: state.athletes[index].lastName!),
                          isAccentedHighlight: true,
                          context: context,
                          title: AppStrings
                              .myAthletes_bottomSheet_cancelRequest_title,
                          subtitle: AppStrings
                              .myAthletes_bottomSheet_cancelRequest_subtitle(
                              typeOfAccess: GlobalHandlers.accessTypeHandler(
                                  apiAccessType: state.athletes[index]
                                      .requestData?.accessType ??
                                      0)),
                          isSingeButtonPresent: true,
                          isSingleButtonColorFilled: false,
                          singleButtonFunction: () {
                            BlocProvider.of<MyAthletesBloc>(context).add(
                                TriggerCancel(
                                    athletes: state.athletes,
                                    scrollController:
                                    state.currentScrollController,
                                    index: index,
                                    selectedTabIndex: state.selectedTabNumber,
                                    athleteId: state.athletes[index]
                                        .underscoreId
                                        .toString()));
                            Navigator.pop(context);
                          },
                          singleButtonText: AppStrings.btn_cancel,
                          onLeftButtonPressed: () {},
                          onRightButtonPressed: () {});
                    },
                    askForSupport: () {
                      if (state.athletes[index].requestData != null) {
                        if (MyAthletesHandler.isSupportTeamContactAvailable(
                            athlete: state.athletes[index])) {
                          buildBottomSheetWithBodyImage(
                            isSingleButtonPresent: true,
                            isFooterNoteCentered: false,
                            navigatorFunction: () {},
                            onButtonPressed: () {
                              BlocProvider.of<MyAthletesBloc>(context).add(
                                  TriggerRequestAthleteSupport(athleteId:
                                      state.athletes[index].underscoreId.toString(),
                                  ));
                              Navigator.pop(context);
                            },
                            context: context,
                            isHighlightedStringAccented: true,
                            highlightedString:
                            StringManipulation.combineFirstNameWithLastName(
                                firstName: state.athletes[index].firstName!,
                                lastName: state.athletes[index].lastName!),
                            title: AppStrings
                                .myAthletes_bottomSheet_supportRequest_title,
                            buttonText: AppStrings
                                .myAthletes_bottomSheet_supportRequest_contactSupport_btn_text,
                            footerNote: AppStrings
                                .myAthletes_bottomSheet_supportRequest_footerNote,
                            imageUrl: AppAssets.imgSupport,
                          );
                        } else {
                          buildBottomSheetWithBodyText(
                            isSingeButtonPresent: true,
                            onLeftButtonPressed: () {},
                            onRightButtonPressed: () {},
                            context: context,
                            isAccentedHighlight: true,
                            highLightedAthleteName:
                            StringManipulation.combineFirstNameWithLastName(
                                firstName: state.athletes[index].firstName!,
                                lastName: state.athletes[index].lastName!),
                            title: AppStrings
                                .myAthletes_bottomSheet_supportRequest_title,
                            subtitle: AppStrings
                                .myAthletes_bottomSheet_supportRequest_noContactSupport_btn_text,
                          );
                        }
                      }
                    },
                    answerRequest: () {
                      buildBottomSheetForAcceptOrReject(
                          context: context,
                          athlete: state.athletes[index],
                          accept: () {
                            Navigator.pop(context);
                            BlocProvider.of<MyAthletesBloc>(context)
                                .add(TriggerAcceptOReject(
                              athletes: state.athletes,
                              index: index,
                              scrollController: state.currentScrollController,
                              isAccepted: true,
                              selectedTabIndex: state.selectedTabNumber,
                              requestId: state.athletes[index].requestData!.id
                                  .toString(),
                            ));
                          },
                          reject: () {
                            Navigator.pop(context);
                            BlocProvider.of<MyAthletesBloc>(context)
                                .add(TriggerAcceptOReject(
                              athletes: state.athletes,
                              index: index,
                              scrollController: state.currentScrollController,
                              isAccepted: false,
                              selectedTabIndex: state.selectedTabNumber,
                              requestId: state.athletes[index].requestData!.id
                                  .toString(),
                            ));
                          });
                    },
                    coachProfile: () {
                      Navigator.pushNamed(
                          context, AppRouteNames.routeAthleteDetails,
                          arguments:
                          state.athletes[index].underscoreId.toString());
                    },
                    viewProfile: () {
                      Navigator.pushNamed(
                          context, AppRouteNames.routeAthleteDetails,
                          arguments:
                          state.athletes[index].underscoreId.toString());
                    },
                    athleteTab: state.selectedTabNumber == 0 &&
                        state.athletes[index].requestData == null
                        ? AthleteTab.myAthletesBeforeRequest
                        : state.selectedTabNumber == 0 &&
                        state.athletes[index].requestData != null
                        ? AthleteTab.myAthletesAfterRequest
                        : state.selectedTabNumber == 2
                        ? AthleteTab.requests
                        : state.selectedTabNumber == 1 &&
                        state.athletes[index].requestData == null
                        ? AthleteTab.allAthletesBeforeRequest
                        : state.selectedTabNumber == 1 &&
                        state.athletes[index].requestData !=
                            null
                        ? AthleteTab.allAthletesAfterRequest
                        : AthleteTab.myAthletesBeforeRequest,
                    metricKeyValuePairs: [
                      {
                        TypeOfMetric.noOfEvents:
                        (state.athletes[index].noUpcomningEvents ?? 0)
                            .toString()
                      },
                      {
                        TypeOfMetric.rank: (state.athletes[index].rank ??
                            state.athletes[index].rankReceived ??
                            0)
                            .toString()
                      },
                      {
                        TypeOfMetric.award:
                        (state.athletes[index].awards ?? 0).toString()
                      },
                      {
                        TypeOfMetric.weight: (state.athletes[index]
                            .weightClass ??
                            state.athletes[index].weight ??
                            '')
                            .toString()
                      },
                      {
                        TypeOfMetric.age:
                        (state.athletes[index].age ?? '').toString()
                      }
                    ],
                    sizeType: SizeType.medium,
                    imageUrl: state.athletes[index].profileImage ??
                        AppStrings.global_empty_string,
                    userStatus: state.athletes[index].userStatus ??
                        AppStrings.global_empty_string,
                    context: context,
                    purchase: () {
                      Navigator.pushNamed(
                        context,
                        AppRouteNames.routeBuySeasonPasses,
                      );
                    },
                    firstName: state.athletes[index].firstName!,
                    lastName: state.athletes[index].lastName!,
                    membership: state.athletes[index].membership,
                  );
                },
              ),
            )
          ],
      ],
    );
  }
}

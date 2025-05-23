import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';
import '../../base/bloc/base_bloc.dart';
import '../bloc/all_events_bloc.dart';

class AllEventsListView extends StatefulWidget {
  const AllEventsListView({super.key});

  @override
  State<AllEventsListView> createState() => _AllEventsListViewState();
}

class _AllEventsListViewState extends State<AllEventsListView> {
  @override
  void initState() {
    BlocProvider.of<AllEventsBloc>(context).add(TriggerRefreshPage());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AllEventsBloc, AllEventsWithInitialState>(
      listener: (context, state) {},
      child: BlocBuilder<AllEventsBloc, AllEventsWithInitialState>(
        builder: (context, state) {
          return state.isLoadingList
              ? CustomLoader(
                  child: buildAllEventsListLayout(state),
                )
              : buildAllEventsListLayout(state);
        },
      ),
    );
  }

  Widget buildAllEventsListLayout(AllEventsWithInitialState state) {
    return customScaffold(
      customAppBar: CustomAppBar(
        title: AppStrings.allEvents_title(
          season: globalCurrentSeason.title ?? AppStrings.global_empty_string,
        ),
        isLeadingPresent: true,
      ),
      hasForm: true,
      formOrColumnInsideSingleChildScrollView: null,
      anyWidgetWithoutSingleChildScrollView: CustomScrollView(
        controller: state.scrollController
          ..addListener(() {
            if (state.scrollController.position.pixels >=
                state.scrollController.position.maxScrollExtent) {
              BlocProvider.of<AllEventsBloc>(context).add(TriggerPagination());
            }
          }),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                customBuildSearchAndFilterButton(
                    searchFunction: () {
                      BlocProvider.of<AllEventsBloc>(context).add(
                          TriggerSearchEvent(
                              filterType: state.filterType, isList: true));
                    },
                    formKey: state.formKeyForList,
                    eraserFunction: () {
                      BlocProvider.of<AllEventsBloc>(context)
                          .add(TriggerEraseSearchKeywordEvent());
                    },
                    isFilterOn: true,
                    onChangeSearchFunction: (value) {
                      BlocProvider.of<AllEventsBloc>(context)
                          .add(TriggerOnChangeSearchEvent(searchValue: value));
                    },
                    filterOnFunction: () {
                      BlocProvider.of<AllEventsBloc>(context)
                          .add(const TriggerTapOnFilter());
                    },
                    searchController: state.searchController,
                    focusNode: state.focusNode,
                    showEraser: state.showEraser,
                    isFilterAvailable: false),
                SizedBox(
                  height: 10.h,
                ),
                Visibility(
                  visible: state.isFilterOnForList,
                  child: buildCustomTabBar(
                    isScrollRequired: false,
                    tabElements: [
                      TabElements(
                        title: AppStrings.allEvents_upcomingTab_title,
                        onTap: () {
                          BlocProvider.of<AllEventsBloc>(context).add(
                              TriggerFetchFilterResults(
                                  isSwitch: true,
                                  isList: true,
                                  page: 1,
                                  filterType: FilterType.upcoming));
                        },
                        isSelected: state.filterType == FilterType.upcoming,
                      ),
                      TabElements(
                        title: AppStrings.allEvents_pastTab_title,
                        onTap: () {
                          BlocProvider.of<AllEventsBloc>(context).add(
                              TriggerFetchFilterResults(
                                  isSwitch: true,
                                  isList: true,
                                  page: 1,
                                  filterType: FilterType.past));
                        },
                        isSelected: state.filterType == FilterType.past,
                      ),
                    ],
                  ),
                ),
                if (state.allEventsData.isEmpty && !state.isLoadingList) ...[
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(10.r),
                      height: state.filterType == FilterType.miscellaneous
                          ? Dimensions.getScreenHeight() * 0.7
                          : Dimensions.getScreenHeight() * 0.6,
                      width: Dimensions.getScreenWidth() * 0.7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Text(
                              state.isSearchModeOn
                                  ? AppStrings.allEvents_emptySearchResult_text(
                                      searchKey: state.searchController.text)
                                  : state.filterType == FilterType.upcoming
                                      ? AppStrings
                                          .allEvents_emptyUpcomingList_text
                                      : state.filterType == FilterType.past
                                          ? AppStrings
                                              .allEvents_emptyPastList_text
                                          : AppStrings
                                              .allEvents_emptyMiscellaneousList_text,
                              textAlign: TextAlign.center,
                              maxLines: 10,
                              style: AppTextStyles.smallTitle(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (state.allEventsData.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return buildCustomEventCard(
                    isFromHome: false,
                    eventId: state.allEventsData[index].underscoreId!,
                    athleteProfiles:
                        state.allEventsData[index].athleteProfiles ?? [],
                    context: context,
                    timezone: state.allEventsData[index].timezone!,
                    coverImage: state.allEventsData[index].coverImage!,
                    eventName: state.allEventsData[index].title!,
                    location: state.allEventsData[index].address!,
                    endDate: state.allEventsData[index].endDatetime!,
                    startDate: state.allEventsData[index].startDatetime!,
                    isLimitedRegistration: state.allEventsData[index].eventRegistrationLimit != null && state.allEventsData[index].eventRegistrationLimit! > 0
                  );
                },
                childCount: state.allEventsData.length,
              ),
            ),
        ],
      ),
    );
  }
// Widget buildAllEventsListLayout(AllEventsWithInitialState state) {
//   return customScaffold(
//       customAppBar: CustomAppBar(
//           title: AppStrings.allEvents_title(
//               season: globalCurrentSeason.title ??
//                   AppStrings.global_empty_string),
//           isLeadingPresent: true),
//       hasForm: true,
//       formOrColumnInsideSingleChildScrollView:
//       Column(
//         children: [
//           customBuildSearchAndFilterButton(
//             searchFunction: () {
//               BlocProvider.of<AllEventsBloc>(context).add(TriggerSearchEvent());
//             },
//             eraserFunction: () {
//               BlocProvider.of<AllEventsBloc>(context).add(TriggerEraseSearchKeywordEvent());
//             },
//             isFilterOn: state.isFilterOn,
//             onChangeSearchFunction: (value) {
//               BlocProvider.of<AllEventsBloc>(context)
//                   .add(TriggerOnChangeSearchEvent(searchValue: value));
//             },
//             filterOnFunction: () {
//               BlocProvider.of<AllEventsBloc>(context).add(TriggerTapOnFilter());
//             },
//             searchController: state.searchController,
//             focusNode: state.focusNode,
//             showEraser: state.showEraser,
//           ),
//           SizedBox(
//             height: 10.h,
//           ),
//           Visibility(
//               visible: state.isFilterOn,
//               child: buildCustomTabBar(isScrollRequired: false, tabElements: [
//                 TabElements(
//                     title: AppStrings.allEvents_upcomingTab_title,
//                     onTap: () {
//                       BlocProvider.of<AllEventsBloc>(context).add(const TriggerFetchFilterResults(
//                           filterType: FilterType.upcoming));
//                     },
//                     isSelected: state.filterType == FilterType.upcoming),
//                 TabElements(
//                     title: AppStrings.allEvents_pastTab_title,
//                     onTap: () {
//                       BlocProvider.of<AllEventsBloc>(context).add(const TriggerFetchFilterResults(
//                           filterType: FilterType.past));
//                     },
//                     isSelected: state.filterType == FilterType.past),
//               ])),
//           if (state.allEventsData.isEmpty && !state.isLoading) ...[
//             Center(
//               child: Container(
//                 padding: EdgeInsets.all(10.r),
//                 height: state.filterType == FilterType.miscellaneous
//                     ? Dimensions.getScreenHeight() * 0.7
//                     : Dimensions.getScreenHeight() * 0.6,
//                 width: double.infinity,
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         state.isSearchModeOn
//                             ? AppStrings.allEvents_emptySearchResult_text(
//                                 searchKey: state.searchKeyForNoResult)
//                             : state.filterType == FilterType.upcoming
//                                 ? AppStrings.allEvents_emptyUpcomingList_text
//                                 : state.filterType == FilterType.past
//                                     ? AppStrings.allEvents_emptyPastList_text
//                                     : AppStrings
//                                         .allEvents_emptyMiscellaneousList_text,
//                         maxLines: 3,
//                         style: AppTextStyles.smallTitle(),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//           if (state.allEventsData.isNotEmpty)
//             Container(
//               padding: EdgeInsets.zero,
//               height: Dimensions.getScreenHeight() * 0.8,
//               margin: EdgeInsets.only(bottom: 10.h),
//               child: ListView.separated(
//                   padding: EdgeInsets.zero,
//                   controller: state.scrollController,
//                   itemBuilder: (context, index) {
//                     return buildCustomEventCard(
//                       eventId: state.allEventsData[index].underscoreId!,
//                       athleteProfiles:
//                           state.allEventsData[index].athleteProfiles ?? [],
//                       context: context,
//                       coverImage: state.allEventsData[index].coverImage!,
//                       eventName: state.allEventsData[index].title!,
//                       location: state.allEventsData[index].address!,
//                       endDate: state.allEventsData[index].endDatetime!,
//                       startDate: state.allEventsData[index].startDatetime!,
//                     );
//                   },
//                   separatorBuilder: (context, index) {
//                     return SizedBox(
//                       height: 20.h,
//                     );
//                   },
//                   itemCount: state.allEventsData.length),
//             )
//         ],
//       ),
//       anyWidgetWithoutSingleChildScrollView: null);
// }
}

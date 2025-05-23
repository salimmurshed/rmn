import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rmnevents/common/resources/app_text_styles.dart';
import 'package:rmnevents/common/widgets/buttons/custom_footer_btn.dart';
import 'package:rmnevents/common/widgets/loader/custom_loader.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/dimensions/dimensions.dart';
import '../../../common/functions/string_manipulation.dart';
import '../../../common/resources/app_assets.dart';
import '../../../common/resources/app_colors.dart';
import '../../../common/resources/app_enums.dart';
import '../../../common/resources/app_routes.dart';
import '../../../common/resources/app_strings.dart';
import '../../../common/widgets/appbar/custom_appbar.dart';
import '../../../common/widgets/appbar/custom_appbar_for_image_behind.dart';
import '../../../common/widgets/bottomsheets/bottom_sheet_with_body_text.dart';
import '../../../common/widgets/buttons/build_twin_buttons.dart';
import '../../../common/widgets/nested_scroll_view_body/custom_nested_scroll_view_for_image_behind.dart';
import '../../../common/widgets/tabs/build_custom_tab_bar.dart';
import '../../../data/models/arguments/chat_arguments.dart';
import '../../../root_app.dart';
import '../../notification/bloc/notification_bloc.dart';
import '../bloc/event_details_bloc.dart';
import '../widgets/build_awards_tab.dart';
import '../widgets/build_bracket_chat_button.dart';
import '../widgets/build_division_tab.dart';
import '../widgets/build_hotels_tab.dart';
import '../widgets/build_information_tab.dart';
import '../widgets/build_products_tab.dart';
import '../widgets/build_schedule_tab.dart';
import '../widgets/dynamic_widget.dart';
import 'package:badges/badges.dart' as badges;

class EventDetailViewWithScrollAnimation extends StatefulWidget {
  const EventDetailViewWithScrollAnimation({super.key, required this.eventId});

  final String eventId;

  @override
  State<EventDetailViewWithScrollAnimation> createState() =>
      _EventDetailViewWithScrollAnimationState();
}

class _EventDetailViewWithScrollAnimationState
    extends State<EventDetailViewWithScrollAnimation> {
  @override
  Widget build(BuildContext context) {
    return EventDetailBody(
      eventId: widget.eventId,
    );
  }
}

class EventDetailBody extends StatefulWidget {
  const EventDetailBody({super.key, required this.eventId});

  final String eventId;

  @override
  State<EventDetailBody> createState() => _EventDetailBodyState();
}

class _EventDetailBodyState extends State<EventDetailBody> {
  final controller = ScrollController();
  double appBarHeight = 100.h;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<EventDetailsBloc>(context)
        .add(TriggerFetchEventDetails(eventId: widget.eventId));
  }

  double calculateTextHeight(String text, TextStyle style, double maxWidth) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: null,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    return textPainter.size.height;
  }

  int calculateRequiredLines({
    required String text,
    required TextStyle style,
    required double availableHeight,
  }) {
    // Create a TextPainter to measure the text height
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      maxLines:
          null, // Allow unlimited lines, since we are calculating it manually
    );

    textPainter.layout(
        maxWidth: double.infinity); // Layout the text with unlimited width

    // Get the height of the text (total height needed to render all lines)
    double textHeight = textPainter.size.height;

    // Calculate the number of lines that will fit within the available height
    int numberOfLines =
        (availableHeight / textHeight * text.split('\n').length).ceil();

    return numberOfLines;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventDetailsBloc, EventDetailsWithInitialState>(
      builder: (context, state) {
        if (state.eventDescription.isNotEmpty) {
          // Calculate the text height dynamically
          final textHeight = calculateTextHeight(
            state.eventDescription,
            AppTextStyles.normalNeutral(),
            MediaQuery.of(context).size.width - 32.sp, // Subtract padding
          );

          // Update app bar height
          appBarHeight = textHeight + (isTablet ? 400.spMin : 250.spMin);
        }

        return buildEventDetailLayout(state, context);
      },
    );
  }

  Widget buildEventDetailLayout(
      EventDetailsWithInitialState state, BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Theme(
        data: Theme.of(navigatorKey.currentContext!).copyWith(
          dividerColor: Colors.transparent,
          dividerTheme: DividerTheme.of(navigatorKey.currentContext!).copyWith(
            color: Colors.transparent,
          ),
        ),
        child: Scaffold(
          backgroundColor: AppColors.colorPrimary,
          appBar: state.isLoading || state.eventResponseData == null
              ? CustomAppBar(
                  title: AppStrings.global_empty_string, isLeadingPresent: true)
              : null,
          persistentFooterButtons: [
            if (!state.isLoading) ...[
              if (state.eventResponseData != null) ...[
                if (state.eventStatus != EventStatus.past) ...[
                  buildCustomLargeFooterBtn(
                      onTap: () {
                        if (state.eventResponseData!.event!
                            .isRegistrationAvailable!) {
                          if (!state.eventResponseData!.event!
                              .isRegistrationExternal!) {
                            Navigator.pushNamed(navigatorKey.currentContext!,
                                AppRouteNames.routePurchaseRegs,
                                arguments: state.eventStatus == EventStatus.upcoming?
                                CouponModules.registration: CouponModules.tickets);
                          } else {
                            buildBottomSheetWithBodyText(
                              context: context,
                              title: AppStrings
                                  .bottomSheet_externalRegistration_title,
                              subtitle: AppStrings
                                  .bottomSheet_externalRegistration_subtitle,
                              leftButtonText: AppStrings.btn_cancel,
                              rightButtonText: AppStrings.btn_register,
                              isSingeButtonPresent: false,
                              onLeftButtonPressed: () {
                                Navigator.pop(context);
                              },
                              onRightButtonPressed: () async {
                                String url = state.regsLink;
                                if (!url.contains('https')) {
                                  await launchUrl(Uri.parse('https://$url'));
                                } else {
                                  await launchUrl(Uri.parse(url));
                                }
                              },
                            );
                          }
                        } else {
                          buildBottomSheetWithBodyText(
                            onLeftButtonPressed: () {
                              Navigator.pop(context);
                            },
                            onRightButtonPressed: () {
                              Navigator.pop(context);
                            },
                            context: context,
                            title:
                                AppStrings.bottomSheet_closedRegistration_title,
                            subtitle: AppStrings
                                .bottomSheet_closedRegistration_subtitle,
                            singleButtonText: AppStrings.btn_ok,
                            isSingeButtonPresent: true,
                            singleButtonFunction: () {
                              Navigator.pop(context);
                            },
                          );
                        }
                      },
                      btnLabel: state.eventStatus == EventStatus.upcoming?
                      'Register & Purchase': 'Purchase',
                      hasKeyBoardOpened: false,
                      isColorFilledButton: true)
                ]
              ]
            ]
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Padding(
            //     padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 16.h),
            //     child: SizedBox(
            //       height: isTablet ? 55.h : 50.h,
            //       child: Row(children: [
            //         if (!state.isLoading) ...[
            //           if (state.eventResponseData != null)
            //             if (state.eventStatus != EventStatus.past) ...[
            //               if (state.eventStatus == EventStatus.upcoming) ...[
            //                 Expanded(
            //                   child: buildBtn(
            //                     hasHeight: false,
            //                     onTap: () {
            //                       if (state.eventResponseData!.event!
            //                           .isRegistrationAvailable!) {
            //                         if (!state.eventResponseData!.event!
            //                             .isRegistrationExternal!) {
            //                           Navigator.pushNamed(
            //                               navigatorKey.currentContext!,
            //                               AppRouteNames.routePurchaseRegs,
            //                               arguments:
            //                                   CouponModules.registration);
            //                         } else {
            //                           buildBottomSheetWithBodyText(
            //                             context: context,
            //                             title: AppStrings
            //                                 .bottomSheet_externalRegistration_title,
            //                             subtitle: AppStrings
            //                                 .bottomSheet_externalRegistration_subtitle,
            //                             leftButtonText: AppStrings.btn_cancel,
            //                             rightButtonText:
            //                                 AppStrings.btn_register,
            //                             isSingeButtonPresent: false,
            //                             onLeftButtonPressed: () {
            //                               Navigator.pop(context);
            //                             },
            //                             onRightButtonPressed: () async {
            //                               String url = state.regsLink;
            //                               if (!url.contains('https')) {
            //                                 await launchUrl(
            //                                     Uri.parse('https://$url'));
            //                               } else {
            //                                 await launchUrl(Uri.parse(url));
            //                               }
            //                             },
            //                           );
            //                         }
            //                       } else {
            //                         buildBottomSheetWithBodyText(
            //                           onLeftButtonPressed: () {
            //                             Navigator.pop(context);
            //                           },
            //                           onRightButtonPressed: () {
            //                             Navigator.pop(context);
            //                           },
            //                           context: context,
            //                           title: AppStrings
            //                               .bottomSheet_closedRegistration_title,
            //                           subtitle: AppStrings
            //                               .bottomSheet_closedRegistration_subtitle,
            //                           singleButtonText: AppStrings.btn_ok,
            //                           isSingeButtonPresent: true,
            //                           singleButtonFunction: () {
            //                             Navigator.pop(context);
            //                           },
            //                         );
            //                       }
            //                     },
            //                     btnLabel: AppStrings
            //                         .eventDetailsView_registration_button_title,
            //                     isColorFilledButton: true,
            //                     isActive: true,
            //                   ),
            //                 ),
            //                 SizedBox(
            //                   width: 10.w,
            //                 ),
            //               ],
            //               Expanded(
            //                 child: buildBtn(
            //                   hasHeight: false,
            //                   onTap: () {
            //                     Navigator.pushNamed(
            //                         context, AppRouteNames.routePurchaseRegs,
            //                         arguments: CouponModules.tickets);
            //                   },
            //                   btnLabel: AppStrings
            //                       .eventDetailsView_buyTicket_button_title,
            //                   isColorFilledButton: true,
            //                   isActive: true,
            //                 ),
            //               )
            //             ]
            //         ],
            //       ]),
            //     ),
            //   ),
            // )
          ],
          body: state.isLoading || state.eventResponseData == null
              ? CustomLoader(
                  child: Container(),
                )
              : Stack(
                  children: [
                    CustomScrollView(
                      slivers: <Widget>[
                        buildSliverAppBar(state, context),
                        SliverPadding(
                            padding: EdgeInsets.only(
                                top: calculateTextHeight(
                                      state.eventDescription,
                                      AppTextStyles.normalNeutral(),
                                      MediaQuery.of(context).size.width -
                                          32.sp, // Subtract padding
                                    ) /
                                    3),
                            sliver: buildSliverTabBar(state)),
                        buildSliverListOfEventContents(state),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  SliverList buildSliverListOfEventContents(
      EventDetailsWithInitialState state) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Container(
            color: AppColors.colorPrimary,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 0, left: 10.w, right: 10.w),
                  child: Column(
                    children: [
                      if (state.tabIndex == 0)
                        HTMLTabView(
                            isShorten: false,
                            state: state,
                            eventDetailTab: EventDetailTab.eventInformation,
                            text: state.eventInformation),
                      if (state.tabIndex == 1)
                        HTMLTabView(
                          isShorten: false,
                          isRegistrationAvailable:
                              state.registrationTabList?.isAvailable ?? false,
                          state: state,
                          eventDetailTab: EventDetailTab.registration,
                          registrationTabList: state.registrationTabList,
                          text: state.registrationTabList!.isAvailable!
                              ? (state.registrationTabList?.title ?? '')
                              : AppStrings.global_empty_string,
                        ),
                      if (state.tabIndex == 2)
                        ...buildDivisionTab(
                          isShorten: false,
                          state: state,
                          divisionsTypes: state.divisionsTypes,
                          onExpansionChangedParent: (divisionIndex, value) {
                            BlocProvider.of<EventDetailsBloc>(context).add(
                                TriggerExpandTileDivisionTab(
                                    sublistIndex: -1,
                                    index: divisionIndex,
                                    divisionsTypes: state.divisionsTypes,
                                    isExpanded: value));
                          },
                          onExpansionChangedChild:
                              (divisionIndex, childIndex, value) {
                            BlocProvider.of<EventDetailsBloc>(context).add(
                                TriggerExpandTileDivisionTab(
                                    sublistIndex: childIndex,
                                    index: divisionIndex,
                                    divisionsTypes: state.divisionsTypes,
                                    isExpanded: value));
                          },
                          weighInDescription:
                              "${state.weightInGuidelines?.description}",
                          divisionTabIndex: state.divisionTabIndex,
                          customTabBar: buildCustomTabBar(
                            isScrollRequired: false,
                            tabElements: buildTabElementList(
                              isDivTabIndex: true,
                              titles: state.divisionTabTitles,
                              index: state.divisionTabIndex,
                            ),
                          ),
                        ),
                      if (state.tabIndex == 3)
                        ScheduleTab(
                          isShorten: false,
                          onExpansionChanged: (val, index) {
                            BlocProvider.of<EventDetailsBloc>(context).add(
                                TriggerExpandTileScheduleTile(
                                    scheduleTileIndex: val ? index : -1));
                          },
                          scheduleOverView: state.scheduleOverView,
                          schedules: state.schedules,
                        ),
                      if (state.tabIndex == 4) ...[
                        if (state.hotels.isNotEmpty) ...[
                          HotelsTab(hotels: state.hotels, isShorten: false)
                        ] else ...[
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20.w, right: 20.w, bottom: 10.h),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: Dimensions.getScreenHeight() * 0.15,
                                ),
                                Center(
                                  child: Text(
                                    AppStrings.eventDetailView_hotelsTab_empty,
                                    style:
                                        AppTextStyles.smallTitleForEmptyList(),
                                  ),
                                )
                              ],
                            ),
                          )
                        ]
                      ],
                      if (state.tabIndex == 5)
                        AwardsTab(awards: state.awards, isShorten: false),
                      if (state.tabIndex == 6) ...[
                        if (state.products.isNotEmpty) ...[
                          ProductsTab(
                            products: state.products,
                            isShorten: false,
                          )
                        ] else ...[
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20.w, right: 20.w, bottom: 10.h),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: Dimensions.getScreenHeight() * 0.15,
                                ),
                                Center(
                                  child: Text(
                                    AppStrings
                                        .eventDetailView_productsTab_empty,
                                    style:
                                        AppTextStyles.smallTitleForEmptyList(),
                                  ),
                                )
                              ],
                            ),
                          )
                        ]
                      ],
                      if (!state.isLoading &&
                          state.eventResponseData != null) ...[
                        if (state.eventResponseData!.event!.additionalData!
                            .isNotEmpty)
                          for (int i = 0;
                              i <
                                  state.eventResponseData!.event!
                                      .additionalData!.length;
                              i++)
                            if (state.tabIndex ==
                                state.tabButtonTitles.length -
                                    state.eventResponseData!.event!
                                        .additionalData!.length +
                                    i)
                              DynamicWidget(
                                i: i,
                                state: state,
                                isShorten: false,
                              )
                      ]
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        childCount: 1,
      ),
    );
  }

  SliverPersistentHeader buildSliverTabBar(EventDetailsWithInitialState state) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _CustomHeaderDelegate(
          child: Container(
        height: isTablet ? 120 : 70,
        color: AppColors.colorPrimary,
        child: state.isLoading || state.eventResponseData == null
            ? Container()
            : Container(
                color: AppColors.colorPrimary,
                margin: EdgeInsets.only(
                    top: isTablet ? 20.h : 10.h, left: 16.w, bottom: 0.h),
                child: buildCustomTabBar(
                  isScrollRequired: true,
                  tabElements: buildTabElementList(
                      isDivTabIndex: false,
                      index: state.tabIndex,
                      titles: state.tabButtonTitles),
                ),
              ),
      )),
    );
  }

  SliverAppBar buildSliverAppBar(
      EventDetailsWithInitialState state, BuildContext context) {
    return SliverAppBar(
      actions: [
        if (state.eventStatus == EventStatus.live) ...[
          if (state.eventResponseData?.event?.liveStreamUrl != null)
            InkWell(
              onTap: state.isLoading
                  ? () {}
                  : () {
                      String url =
                          state.eventResponseData?.event?.liveStreamUrl ?? '';
                      if (!url.contains('https')) {
                        launchUrl(Uri.parse('https://$url'));
                      } else {
                        launchUrl(Uri.parse(url));
                      }
                    },
              child: Container(
                margin: EdgeInsets.only(top: Dimensions.appBarToolVerticalGap),
                child: SvgPicture.asset(
                  AppAssets.icLiveNotification,
                  height: 37.h,
                  width: 38.w,
                ),
              ),
            ),
          SizedBox(
            width: 10.w,
          ),
          buildLiveIcon(),
          SizedBox(
            width: 10.w,
          ),
        ],
        if (state.eventStatus == EventStatus.past)
          InkWell(
            splashColor: Colors.transparent,
            onTap: state.isLoading
                ? () {}
                : () {
                    if (state.eventResponseData != null) {
                      Navigator.pushNamed(context, AppRouteNames.routeRanking,
                          arguments:
                              state.eventResponseData!.event!.underscoreId);
                    }
                  },
            child: buildAppBarIconButton(svgAddress: AppAssets.icRank),
          ),
        buildBracketChatButton(
            isLoading: state.isLoading,
            onTap: state.isLoading
                ? () {}
                : () {
                    Navigator.pushNamed(
                      context,
                      AppRouteNames.routeChat,
                      arguments: ChatArguments(
                          eventId: state.eventResponseData!.event!.id!,
                          roomId: state.eventResponseData?.event?.chatRoomId ??
                              AppStrings.global_empty_string,
                          isFromDetailView: true),
                    );
                  }),
      ],
      backgroundColor: AppColors.colorPrimary,
      titleSpacing: 0,
      leadingWidth: 60.w,
      leading: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          height: 60.h,
          margin: EdgeInsets.only(
              left: Dimensions.appBarToolHorizontalGap, top: 4.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.appBarToolRadius),
            color: AppColors.colorSecondary,
          ),
          child: Center(
            child: SvgPicture.asset(
                height: 18.h, AppAssets.icAppbarBackButton, fit: BoxFit.cover),
          ),
        ),
      ),
      pinned: true,
      expandedHeight: appBarHeight,
      toolbarHeight: isTablet ? 47.h : kToolbarHeight,
      floating: true,
      collapsedHeight: kToolbarHeight +
          (isTablet ? 100.h : MediaQuery.of(context).size.height * 0.063),
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return state.isLoading || state.eventResponseData == null
              ? Container()
              : Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: state.coverImage,
                      width: Dimensions.getScreenWidth(),
                      fit: BoxFit.cover,
                      height: isTablet ? 170.h : 155.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top +
                            kToolbarHeight +
                            (isTablet ? 100 : 10),
                      ),
                      child: Align(
                        alignment: Alignment(
                            0,
                            calculateTextHeight(
                                  state.eventDescription,
                                  AppTextStyles.normalNeutral(),
                                  MediaQuery.of(context).size.width -
                                      32.sp, // Subtract padding
                                ) /
                                45),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: ClipRect(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.colorPrimary.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              padding: EdgeInsets.all(5.r),
                              child: SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        if (state.eventStatus !=
                                            EventStatus.none)
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.w, vertical: 2.h),
                                            margin:
                                                EdgeInsets.only(right: 10.w),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(3.r),
                                              color: state.eventStatus ==
                                                      EventStatus.live
                                                  ? AppColors.colorPrimaryAccent
                                                  : state.eventStatus ==
                                                          EventStatus.upcoming
                                                      ? AppColors
                                                          .colorGreenAccent
                                                      : AppColors
                                                          .colorSecondaryAccent,
                                            ),
                                            child: Center(
                                              child: Text(
                                                StringManipulation
                                                    .capitalizeTheInitial(
                                                        value: state
                                                            .eventStatus.name),
                                                style: TextStyle(
                                                  color: AppColors
                                                      .colorPrimaryInverseText,
                                                  fontFamily:
                                                      AppFontFamilies.squada,
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            state.eventTitle,
                                            style: AppTextStyles.smallTitle(),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 10.h),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.eventDescription,
                                            style:
                                                AppTextStyles.normalNeutral(),
                                          ),
                                          buildSvgWithInfo(
                                              text: state.eventDateTime,
                                              isDate: true),
                                          buildSvgWithInfo(
                                              text: state.eventLocation,
                                              isDate: false),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}

class _CustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _CustomHeaderDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => isTablet ? 120 : 70; // Height of the container
  @override
  double get minExtent => isTablet ? 120 : 70; // Height of the container
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

List<TabElements> buildTabElementList(
    {required bool isDivTabIndex,
    required int index,
    required List<String> titles}) {
  return titles
      .map((tabElement) => TabElements(
          title: tabElement,
          onTap: () {
            BlocProvider.of<EventDetailsBloc>(navigatorKey.currentContext!).add(
                TriggerSwitchTab(
                    isDivTabIndex: isDivTabIndex,
                    index: titles.indexOf(tabElement)));
          },
          isSelected: index == titles.indexOf(tabElement)))
      .toList();
}

BlocBuilder<NotificationBloc, NotificationWithInitialState> buildLiveIcon() {
  return BlocBuilder<NotificationBloc, NotificationWithInitialState>(
    builder: (context, state) {
      return InkWell(
          onTap: state.isLoading
              ? () {}
              : () {
                  Navigator.pushNamed(
                    context,
                    AppRouteNames.routeNotification,
                    arguments: 'event-notification',
                  ).then(
                    (value) {
                      if (context.mounted) {
                        BlocProvider.of<NotificationBloc>(context)
                            .add(const TriggerGetNotificationCount(
                          messageType: AppStrings.global_empty_string,
                        ));
                      }
                    },
                  );
                },
          child: Container(
            margin: EdgeInsets.only(top: Dimensions.appBarToolVerticalGap),
            child: state.unreads != '0'
                ? badges.Badge(
                    position:
                        badges.BadgePosition.topEnd(top: -14.h, end: -10.w),
                    showBadge: true,
                    ignorePointer: false,
                    badgeContent: Text(state.unreads,
                        style: AppTextStyles.normalPrimary()),
                    badgeAnimation: const badges.BadgeAnimation.rotation(
                      animationDuration: Duration(seconds: 1),
                      loopAnimation: false,
                      curve: Curves.bounceInOut,
                      colorChangeAnimationCurve: Curves.easeInCubic,
                    ),
                    badgeStyle: badges.BadgeStyle(
                      shape: badges.BadgeShape.circle,
                      badgeColor: AppColors.colorPrimaryAccent,
                      padding: state.unreads.length == 1
                          ? EdgeInsets.all(7.r)
                          : EdgeInsets.all(6.r),
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                          color: AppColors.colorPrimaryInverse, width: 2),
                      elevation: 2,
                    ),
                    child: SvgPicture.asset(
                        width: 40.w, height: 36.h, AppAssets.icNotificationBlue)
                    //buildAppBarIconButton(svgAddress: AppAssets.icBell)
                    )
                : SvgPicture.asset(
                    width: 40.w, height: 36.h, AppAssets.icNotificationBlue),
          )
          //buildAppBarIconButton(svgAddress: AppAssets.icBell),
          );
    },
  );
}

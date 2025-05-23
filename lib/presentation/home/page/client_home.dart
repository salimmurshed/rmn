import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/presentation/home/client_home_bloc/client_home_bloc.dart';
import '../../../common/widgets/images/build_custom_landing_image.dart';
import '../../../imports/common.dart';
import '../../../imports/data.dart';
import '../../../root_app.dart';
import '../../create_edit_profile/widgets/build_card_for_null_live.dart';
import '../../notification/bloc/notification_bloc.dart';
import '../widgets/build_empty_list_display.dart';
import '../widgets/build_list_of_athletes.dart';
import '../widgets/build_list_of_upcoming_events.dart';
import '../widgets/build_live_or_next_card.dart';
import '../widgets/build_section_title.dart';

class ClientHome extends StatefulWidget {
  const ClientHome({super.key});

  @override
  State<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  @override
  initState() {
    super.initState();

    BlocProvider.of<ClientHomeBloc>(context).add(TriggerHomeDataFetch());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClientHomeBloc, ClientHomeWithInitialState>(
      listener: (context, state) {
        if (state.message.isNotEmpty) {
          buildCustomToast(msg: state.message, isFailure: state.isFailure);
        }
      },
      child: BlocBuilder<ClientHomeBloc, ClientHomeWithInitialState>(
        builder: (context, state) {
          return state.isLoadingEvents || state.isLoadingAthletes
              ? CustomLoader(
                  child: buildClientHomeLayout(state, context),
                )
              : buildClientHomeLayout(state, context);
        },
      ),
    );
  }

  Widget buildClientHomeLayout(
      ClientHomeWithInitialState state, BuildContext context) {
    return customScaffold(
      hasForm: false,
      customAppBar: CustomAppBar(
        isLeadingPresent: false,
        title: AppStrings.clientHome_title,
        color: AppColors.colorPrimaryAccent,
        appBarActionFunction: () {
          Navigator.pushNamed(context, AppRouteNames.routeNotification).then(
            (value) {
              BlocProvider.of<NotificationBloc>(navigatorKey.currentContext!)
                  .add(const TriggerGetNotificationCount(
                messageType: AppStrings.global_empty_string,
              ));
            },
          );
        },
        appBarActionSvgAddress: AppAssets.icBell,
        isNotification: true,
      ),
      formOrColumnInsideSingleChildScrollView: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (state.liveEvent == null) buildCardForNullLive(),
          if (state.liveEvent != null)
            buildLiveOrNextCard(
              isFromHome: true,
              timezone: state.liveEvent!.timezone!,
              location: state.liveEvent!.address!,
              nameOfTheEvent: state.liveEvent!.title!,
              context: context,
              endDate: state.liveEvent!.endDatetime!,
              startDate: state.liveEvent!.startDatetime!,
              imageUrl: state.liveEvent!.coverImage!,
              onTap: () {
                if (state.liveEvent?.underscoreId != null) {
                  Navigator.pushNamed(context, AppRouteNames.routeEventDetails,
                      arguments: state.liveEvent!.id!);
                }
              },
              eventCardType: state.liveEvent!.eventStatus!,
            ),
          SizedBox(
            height: Dimensions.generalGap,
          ),
          buildSectionTitle(
              title: AppStrings.clientHome_nextEvents_title,
              isButtonPresent: state.upcomingRegistrations.isNotEmpty,
              isEvent: true),
          if (state.upcomingRegistrations.isEmpty)
            buildEmptyListDisplay(
              isEvents: true,
            ),
          if (state.upcomingRegistrations.isNotEmpty)
            ...buildListOfUpComingEvents(state, true),
          buildSectionTitle(
              title: AppStrings.clientHome_athletes_title,
              isButtonPresent: state.homeAthletes.isNotEmpty,
              isEvent: false),
          if (state.homeAthletes.isEmpty)
            buildEmptyListDisplay(isEvents: false),
          if (state.homeAthletes.isNotEmpty) ...buildListOfAthletes(state)
        ],
      ),
      anyWidgetWithoutSingleChildScrollView: null,
    );
  }
}

class PromotionalPopup extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String description;
  final bool isEvent;
  final String eventId;
  final VoidCallback onEventTap;
  final VoidCallback onClose;

  final bool dontShowAgain;
  final String id;

  const PromotionalPopup({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.eventId,
    this.isEvent = false,
    required this.onEventTap,
    required this.onClose,
    required this.id,
    required this.dontShowAgain,
  });

  @override
  _PromotionalPopupState createState() => _PromotionalPopupState();
}

class _PromotionalPopupState extends State<PromotionalPopup> {
  bool dontShowAgain = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientHomeBloc, ClientHomeWithInitialState>(
      builder: (context, state) {
        return Dialog(
          backgroundColor: AppColors.colorTertiary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: buildCustomLandingImage(
                        imageUrl: widget.imageUrl,
                        height: 150.h,
                        width: double.infinity),
                  ),
                  Positioned(
                    top: 2.h,
                    right: 3.w,
                    child: IconButton(
                      icon: Icon(
                        Icons.highlight_remove,
                        size: 20.sp,
                        color: AppColors.colorPrimaryInverse,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(widget.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.largeTitle()),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                            child: Text(widget.description,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 10,
                                style: AppTextStyles.regularNeutralOrAccented(
                                    isOutfit: true))),
                      ],
                    )),
                    SizedBox(height: 15.h),
                    GestureDetector(
                      onTap: () {
                        BlocProvider.of<ClientHomeBloc>(context)
                            .add(TriggerCheckBoxPopUp(id: widget.id));
                        dontShowAgain = !dontShowAgain;
                        setState(() {});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildCustomCheckbox(
                              isChecked: dontShowAgain,
                              onChanged: (value) {
                                BlocProvider.of<ClientHomeBloc>(context)
                                    .add(TriggerCheckBoxPopUp(id: widget.id));
                                dontShowAgain = !dontShowAgain;
                                setState(() {});
                              },
                              isSmall: true),
                          SizedBox(width: 10.w),
                          Flexible(
                            child: Text(
                                AppStrings.popUp_dontShowThis_checkBox_text,
                                style: AppTextStyles.subtitle(isOutFit: false)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    if (widget.isEvent)
                      Row(
                        children: [
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.r),
                                border: Border.all(
                                    color: AppColors.colorPrimaryInverse),
                                color: AppColors.colorPrimaryInverse,
                              ),
                              //margin: EdgeInsets.symmetric(horizontal: 15.w),
                              padding: EdgeInsets.all(5.r),
                              child: Center(
                                  child: Text(
                                AppStrings.btn_later,
                                style: AppTextStyles.buttonTitle(
                                    color: AppColors.colorSecondaryAccent),
                              )),
                            ),
                          )),
                          SizedBox(
                            width: 15.w,
                          ),
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                  context, AppRouteNames.routeEventDetails,
                                  arguments: widget.eventId);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.r),
                                border: Border.all(
                                    color: AppColors.colorSecondaryAccent),
                                color: AppColors.colorSecondaryAccent,
                              ),
                              //margin: EdgeInsets.symmetric(horizontal: 15.w),
                              padding: EdgeInsets.all(5.r),
                              child: Center(
                                  child: Text(
                                AppStrings.btn_viewEvent,
                                style: AppTextStyles.buttonTitle(
                                    color: AppColors.colorPrimaryInverseText),
                              )),
                            ),
                          ))
                        ],
                      ),
                    if (!widget.isEvent)
                      buildCustomLargeFooterBtn(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          btnLabel: AppStrings.btn_thanks,
                          hasKeyBoardOpened: false,
                          isColorFilledButton: true),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

void showSequentialPopups(BuildContext context, List<PopUpData> popups) async {
  for (var popup in popups) {
    if (!popup.dontShowAgain!) {
      await showDialog(
        context: context,
        builder: (context) {
          return PromotionalPopup(
            id: popup.id!,
            dontShowAgain: popup.dontShowAgain!,
            imageUrl: '${popup.image}',
            title: popup.title!,
            description: popup.description!,
            isEvent:
                popup.popupType == 'event-specific' && popup.eventId != null,
            eventId: popup.eventId ?? '',
            onEventTap: () {
              Navigator.popAndPushNamed(
                  context, AppRouteNames.routeEventDetails,
                  arguments: popup.eventId);
            },
            onClose: () {
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }
}

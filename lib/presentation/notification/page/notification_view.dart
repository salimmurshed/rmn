import 'package:clear_all_notifications/clear_all_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rmnevents/common/functions/global_handlers.dart';
import 'package:rmnevents/common/functions/string_manipulation.dart';
import 'package:rmnevents/common/resources/app_colors.dart';
import 'package:rmnevents/common/resources/app_routes.dart';
import 'package:rmnevents/common/resources/app_text_styles.dart';
import 'package:rmnevents/common/widgets/appbar/custom_appbar.dart';
import 'package:rmnevents/common/widgets/loader/custom_loader.dart';
import 'package:rmnevents/common/widgets/scaffold/custom_scaffold.dart';
import 'package:rmnevents/data/models/arguments/chat_arguments.dart';
import 'package:rmnevents/root_app.dart';

import '../../../common/resources/app_assets.dart';
import '../../../common/resources/app_strings.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_handler.dart';

class NotificationView extends StatefulWidget {
  NotificationView({super.key, this.type});

  String? type;

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  void initState() {
    getNotificationClear();

    BlocProvider.of<NotificationBloc>(navigatorKey.currentContext!)
        .add(TriggerGetNotifications(
      type: widget.type ?? AppStrings.global_empty_string,
    ));
    super.initState();
  }

  getNotificationClear() async {
    await ClearAllNotifications.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationWithInitialState>(
      builder: (context, state) {
        return customScaffold(
            hasForm: false,
            customAppBar: CustomAppBar(
              title: AppStrings.notifications_title,
              isLeadingPresent: true,
            ),
            formOrColumnInsideSingleChildScrollView: null,
            anyWidgetWithoutSingleChildScrollView: state.isLoading
                ? CustomLoader(child: buildNotificationsLayout(state))
                : buildNotificationsLayout(state));
      },
    );
  }

  Widget buildNotificationsLayout(NotificationWithInitialState state) {
    return state.notifications.isEmpty && !state.isLoading
        ? Center(
            child: Text(
              'You have no new notifications.',
              style: AppTextStyles.smallTitleForEmptyList(),
            ),
          )
        : ListView.separated(
            itemCount: state.notifications.length,
            padding: EdgeInsets.symmetric(vertical: 10.h),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (state.notifications[index].notificationType ==
                      'event-notification') {
                    Navigator.pushNamed(
                        context, AppRouteNames.routeEventDetails,
                        arguments: state.notifications[index].refId!);
                  } else if (state.notifications[index].notificationType ==
                      'athlete-request') {
                    Navigator.pushNamed(
                        context, AppRouteNames.routeMyAthleteProfiles,
                        arguments: 2);
                  } else if (state.notifications[index].notificationType ==
                      'event-message') {
                    Navigator.pushNamed(
                      context,
                      AppRouteNames.routeChat,
                      arguments: ChatArguments(
                          eventId: state.notifications[index].refId!,
                          roomId: state.notifications[index].addtionalData!.chatRoomId!,
                          isFromDetailView: false),
                    );
                  } else if (state.notifications[index].notificationType ==
                      'athlete-request-response') {
                    Navigator.pushNamed(
                      context,
                      AppRouteNames.routeMyAthleteProfiles,
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.h),
                  margin: EdgeInsets.symmetric(
                    horizontal: 2.w,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.colorSecondary,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: !state.notifications[index].isRead!
                        ? const [
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
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SvgPicture.asset(
                          AppAssets.icBell,
                          height: 25.h,
                          width: 25.w,
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          margin: EdgeInsets.only(right: 5.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      margin: EdgeInsets.only(right: 5.w),
                                      child: Text(
                                        StringManipulation
                                            .capitalizeFirstLetterOfEachWord(
                                          value: state
                                                  .notifications[index].title ??
                                              AppStrings.global_general_string,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyles.subtitle(
                                            isOutFit: false),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        textAlign: TextAlign.end,
                                        GlobalHandlers
                                            .getHumanReadableTimeStampInAgoFormat(
                                                state.notifications[index]
                                                        .createdAt ??
                                                    DateTime.now().toString()),
                                        style: AppTextStyles.normalNeutral(),
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              NotificationHandler.customizeDescriptionHandler(
                                  keyword: state.notifications[index].keyword,
                                  keywordValue:
                                      state.notifications[index].keywordValue,
                                  fullMessage:
                                      state.notifications[index].message ??
                                          AppStrings.global_empty_string),
                              if (state.notifications[index].notificationType ==
                                  'event-notification') ...[
                                SizedBox(
                                  height: 5.h,
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Event: ',
                                    style: AppTextStyles.subtitle(
                                        isOutFit: false,
                                        color:
                                            AppColors.colorPrimaryNeutralText),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: state.notifications[index]
                                                .keywordValue ??
                                            AppStrings.global_empty_string,
                                        style: AppTextStyles.subtitle(
                                            isOutFit: false,
                                            color:
                                                AppColors.colorPrimaryAccent),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 20.h,
              );
            },
          );
  }
}

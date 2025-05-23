import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';
import '../../../root_app.dart';
import 'build_event_info.dart';
import 'build_image_and_date_holder.dart';
import 'empty_tab_list_text.dart';

Widget buildEventList({
  required bool isUpcoming,
  required List<EventsSeasonWiseForAthlete> events,
  required void Function(int index) onTapToEventDetails,
  required void Function(int index) onTapToOpenBottomSheet,
}) {
  return events.isEmpty
      ? emptyTabListText(
          text: isUpcoming
              ? AppStrings.athleteDetails_emptyUpcomingEvents_text
              : AppStrings.athleteDetails_emptyPastEvents_text,
        )
      : Expanded(
          child: ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              return Container(
                height: isTablet? 120.h:100.h,
                margin: EdgeInsets.symmetric(vertical: 5.h),
                decoration: BoxDecoration(
                    color: AppColors.colorSecondary,
                    borderRadius: BorderRadius.circular(Dimensions.generalSmallRadius)),
                padding: EdgeInsets.symmetric(
                  horizontal: 5.w,
                  vertical: 3.h,
                ),
                child: Row(
                  children: [
                    buildImageAndDateHolder(

                      timezone: events[index].timezone!,
                        imageUrl: events[index].mainImage!,
                        endDate: events[index].startDatetime!,
                        startDate: events[index].endDatetime!,
                        onTapToEventDetails: (){
                          onTapToEventDetails(index);
                        }),
                    SizedBox(
                      width: 5.w,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildEventInfo(
                              location: events[index].address!,
                              eventName: events[index].title!,
                              onTapToEventDetails: (){
                                onTapToEventDetails(index);
                              }),
                         const Spacer(),
                          buildTotalRegistrationInfo(
                              rank: isUpcoming
                                  ? 0
                                  : events[index].placement ?? 0,
                              isUpcoming: isUpcoming,
                              value: events[index].registrations == null
                                  ? '0'
                                  : events[index]
                                      .registrations!
                                      .length
                                      .toString(),
                              onTapToOpenBottomSheet: () {
                                onTapToOpenBottomSheet(index);
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
}

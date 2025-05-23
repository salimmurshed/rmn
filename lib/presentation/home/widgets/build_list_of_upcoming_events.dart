import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';
import '../client_home_bloc/client_home_bloc.dart';

List<Widget> buildListOfUpComingEvents(ClientHomeWithInitialState state,  bool isFromHome) {
  return [
    buildCustomCarousel(
        height: 220.h,
        currentIndex: state.eventCurrentIndex,
        itemCount: state.upcomingRegistrations.length,
        pageController: state.eventPageController,
        itemBuilder: (context, index) {
          return buildCustomEventCard(
            timezone: state.upcomingRegistrations[index].timezone!,
            isFromHome: isFromHome,
            eventId: state.upcomingRegistrations[index].underscoreId!,
            athleteProfiles:
                state.upcomingRegistrations[index].athleteProfiles ?? [],
            context: context,
            coverImage: state.upcomingRegistrations[index].coverImage!,
            eventName: state.upcomingRegistrations[index].title!,
            location: state.upcomingRegistrations[index].address!,
            endDate: state.upcomingRegistrations[index].endDatetime!,
            startDate: state.upcomingRegistrations[index].startDatetime!,
            isLimitedRegistration: state.upcomingRegistrations[index].eventRegistrationLimit != null && state.upcomingRegistrations[index].eventRegistrationLimit! > 0
          );
        }),
  ];
}

import 'package:flutter/material.dart';

import '../../../imports/common.dart';
import '../../../root_app.dart';
import 'build_view_all_button.dart';

Widget buildSectionTitle(
    {required String title, required bool isEvent, required isButtonPresent}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.largeTitle(),
          ),
          if (isButtonPresent && isEvent)
            buildViewAllButton(onPressed: () {
              Navigator.pushNamed(navigatorKey.currentState!.context,
                  AppRouteNames.routeAllEvents,
                  arguments: AllEventsViewType.listView);
            }),
          if (isButtonPresent && !isEvent)
            buildViewAllButton(onPressed: () {
              Navigator.pushNamed(
                navigatorKey.currentState!.context,
                AppRouteNames.routeMyAthleteProfiles,
              );
            }),
        ],
      ),
      customDivider(),
      SizedBox(
        height: Dimensions.generalGapSmall,
      )
    ],
  );
}

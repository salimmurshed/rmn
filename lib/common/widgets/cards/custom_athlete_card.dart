import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../imports/common.dart';
import '../../../../imports/data.dart';
import '../../../data/models/response_models/season_passes_response_model.dart';

Widget customAthleteCard({
  required String imageUrl,
  required AthleteTab athleteTab,
  bool isMarginRequired = false,
  required String userStatus,
  required BuildContext context,
  required String firstName,
  required String athleteId,
  required List<Team> teams,
  required List<SeasonPass> seasons,
  required List<Map<TypeOfMetric, String>> metricKeyValuePairs,
  SizeType sizeType = SizeType.large,
  required String lastName,
  required Memberships? membership,
  required RequestData? requestData,
  void Function()? viewProfile,
  void Function()? requestAthlete,
  void Function()? coachProfile,
  void Function()? cancelRequest,
  void Function()? askForSupport,
  void Function()? answerRequest,
  void Function()? purchase,
}) {
  return Container(
    margin: isMarginRequired ? EdgeInsets.only(right: 10.w) : null,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.generalRadius),
        color: AppColors.colorTertiary),
    padding: EdgeInsets.only(right: 7.w, left: 7.w, top: 6.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            children: [
              buildCustomImagePlaceHolder(
                  onTapImage: athleteTab == AthleteTab.home
                      ? viewProfile
                      : athleteTab == AthleteTab.requests
                          ? viewProfile
                          : (athleteTab == AthleteTab.myAthletesBeforeRequest ||
                                  athleteTab ==
                                      AthleteTab.myAthletesAfterRequest)
                              ? viewProfile
                              : athleteTab ==
                                      AthleteTab.allAthletesBeforeRequest
                                  ? requestAthlete
                                  : athleteTab ==
                                          AthleteTab.allAthletesAfterRequest
                                      ? cancelRequest
                                      : () {},
                  sizeType: sizeType,
                  imageUrl: imageUrl,
                  userStatus: userStatus,
                  seasons: seasons,
                  // athleteId: athleteId,
                  // teams: teams,
                  membership: membership),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List<Widget>.generate(
                      metricKeyValuePairs.length,
                      (index) => Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          metrics(
                              context: context,
                              sizeType: sizeType,
                              typeOfMetric: TypeOfMetric.values[index],
                              athleteFirstName: firstName,
                              athleteLastName: lastName,
                              metricValue: metricKeyValuePairs[index]
                                  .values
                                  .first
                                  .toString()),
                          if (index < 2) ...[
                            SizedBox(
                                height:
                                    sizeType == SizeType.medium ? 3.h : 5.h),
                            // dividerLine(sizeType: sizeType),
                          ] else if (index == 2) ...[
                            dividerLine(sizeType: sizeType),
                          ] else if (index == 3) ...[
                            SizedBox(
                                height:
                                    sizeType == SizeType.medium ? 3.h : 6.h),
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 5.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: sizeType == SizeType.large ? 2.h : 1.h),
                    child: svgPlaceHolder(
                      isMetric: false,
                      typeOfMetric: TypeOfMetric.none,
                      sizeType: sizeType,
                      imageUrl: AppAssets.icProfile,
                    ),
                  ),
                  SizedBox(width: sizeType == SizeType.large ? 5.w : 2.w),
                  Expanded(
                    child: Text(
                      StringManipulation.combineFirstNameWithLastName(
                          firstName: firstName, lastName: lastName),
                      style: sizeType == SizeType.large
                          ? AppTextStyles.largeTitle()
                          : sizeType == SizeType.medium
                              ? AppTextStyles.subtitle(isOutFit: false)
                              : AppTextStyles.componentLabels(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              if (requestData != null && athleteTab == AthleteTab.requests)
                Row(
                  children: [
                    Text(
                      'Request: ',
                      style: AppTextStyles.componentLabels(
                          color: AppColors.colorPrimaryAccent),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      requestData.accessType == 0
                          ? 'View Access'
                          : requestData.accessType == 2
                              ? 'Coach Access'
                              : 'Owner Access',
                      style: AppTextStyles.componentLabels(),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
            ],
          ),
        ),
        if (athleteTab != AthleteTab.none) ...[
          if (athleteTab == AthleteTab.myAthletesBeforeRequest)
            ...buildMyAthleteAccessButtons(
                membership: membership,
                purchaseProfile: purchase,
                isLeftButtonFilled: true,
                userStatus: userStatus,
                viewProfile: viewProfile,
                coachProfile: coachProfile,
                requestAthlete: requestAthlete),
          if (athleteTab == AthleteTab.myAthletesAfterRequest) ...[
            athleteWithDoubleButtons(
                leftTap: cancelRequest,
                isLeftButtonFilled: false,
                buttonTextLeft: AppStrings.myAthletes_allAthleteTab_cancel_btn,
                buttonTextRight:
                    AppStrings.myAthletes_allAthleteTab_support_btn,
                rightTap: askForSupport)
          ],
          if (athleteTab == AthleteTab.allAthletesBeforeRequest) ...[
            if (userStatus.isNotEmpty)
              ...buildMyAthleteAccessButtons(
                  membership: membership,
                  purchaseProfile: purchase,
                  isLeftButtonFilled: true,
                  userStatus: userStatus,
                  viewProfile: viewProfile,
                  coachProfile: coachProfile,
                  requestAthlete: requestAthlete)
            else ...[
              athleteWithSingleAccessButton(
                onTap: requestAthlete,
                buttonText:
                    AppStrings.myAthletes_allAthleteTab_requestAccess_btn,
              ),
            ]
          ],
          if (athleteTab == AthleteTab.allAthletesAfterRequest) ...[
            if (userStatus.isNotEmpty && requestData == null)
              ...buildMyAthleteAccessButtons(
                  membership: membership,
                  purchaseProfile: purchase,
                  isLeftButtonFilled: true,
                  userStatus: userStatus,
                  viewProfile: viewProfile,
                  coachProfile: coachProfile,
                  requestAthlete: requestAthlete)
            else ...[
              athleteWithDoubleButtons(
                  leftTap: cancelRequest,
                  isLeftButtonFilled: false,
                  buttonTextLeft:
                      AppStrings.myAthletes_allAthleteTab_cancel_btn,
                  buttonTextRight:
                      AppStrings.myAthletes_allAthleteTab_support_btn,
                  rightTap: askForSupport)
            ]
          ],
          if (athleteTab == AthleteTab.requests) ...[
            athleteWithSingleAccessButton(
              onTap: answerRequest,
              buttonText: AppStrings.myAthletes_myAthleteTab_answerRequest_btn,
            )
          ]
        ],
      ],
    ),
  );
}

List<Widget> buildMyAthleteAccessButtons(
    {required String userStatus,
    required bool isLeftButtonFilled,
    required Memberships? membership,
    required void Function()? viewProfile,
    required void Function()? purchaseProfile,
    required void Function()? coachProfile,
    required void Function()? requestAthlete}) {
  return [
    if (userStatus == TypeOfAccess.owner.name) ...[
      if (membership != null) ...[
        athleteWithSingleAccessButton(
          onTap: viewProfile,
          buttonText: AppStrings.myAthletes_myAthleteTab_viewProfile_btn,
        )
      ] else ...[
        athleteWithDoubleButtons(
            isLeftButtonFilled: isLeftButtonFilled,
            leftTap: viewProfile,
            isPurchasePass: true,
            buttonTextLeft: AppStrings.myAthletes_myAthleteTab_viewProfile_btn,
            buttonTextRight:
                AppStrings.myAthletes_myAthleteTab_purchaseProfile_btn,
            rightTap: purchaseProfile)
      ]
    ] else if (userStatus == TypeOfAccess.coach.name) ...[
      athleteWithDoubleButtons(
          isLeftButtonFilled: isLeftButtonFilled,
          leftTap: coachProfile,
          buttonTextLeft: AppStrings.myAthletes_myAthleteTab_coach_btn,
          buttonTextRight:
              AppStrings.myAthletes_myAthleteTab_requestProfile_btn,
          rightTap: requestAthlete)
    ] else if (userStatus == TypeOfAccess.view.name) ...[
      athleteWithDoubleButtons(
          isLeftButtonFilled: isLeftButtonFilled,
          leftTap: viewProfile,
          buttonTextLeft: AppStrings.myAthletes_myAthleteTab_viewProfile_btn,
          buttonTextRight:
              AppStrings.myAthletes_myAthleteTab_requestProfile_btn,
          rightTap: requestAthlete)
    ]
  ];
}

Row athleteWithDoubleButtons(
    {void Function()? leftTap,
    required bool isLeftButtonFilled,
    bool isPurchasePass = false,
    required String buttonTextLeft,
    required String buttonTextRight,
    required Function()? rightTap}) {
  return Row(children: [
    Expanded(
        child: athleteButtonForRow(
            isButtonFilled: isLeftButtonFilled,
            buttonText: buttonTextLeft,
            onTap: leftTap)),
    SizedBox(
      width: 3.w,
    ),
    Expanded(
        child: athleteButtonForRow(
            isPurchasePass: isPurchasePass,
            isButtonFilled: true,
            buttonText: buttonTextRight,
            onTap: rightTap))
  ]);
}

GestureDetector athleteButtonForRow(
    {required bool isButtonFilled,
    required String buttonText,
    bool isPurchasePass = false,
    void Function()? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 25.h,
      margin: EdgeInsets.only(right: 1.w, left: 1.w, bottom: 8.h),
      decoration: isButtonFilled
          ? BoxDecoration(
              color: isPurchasePass
                  ? Colors.white
                  : AppColors.colorSecondaryAccent,
              borderRadius: BorderRadius.circular(2.r))
          : BoxDecoration(
              color: AppColors.colorSecondary,
              border: Border.all(color: AppColors.colorPrimaryAccent, width: 1),
              borderRadius: BorderRadius.circular(2.r)),
      child: Center(
          child: Text(
        buttonText,
        style: AppTextStyles.componentLabels(
          isNormal: true,
            color: isPurchasePass
                ? AppColors.colorSecondaryAccent
                : AppColors.colorPrimaryInverseText),
      )),
    ),
  );
}

GestureDetector athleteWithSingleAccessButton(
    {required void Function()? onTap, required String buttonText}) {
  return GestureDetector(
    onTap: onTap,
    child: pictureContainer(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
              child: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.w),
            decoration: BoxDecoration(
                color: AppColors.colorSecondaryAccent,
                borderRadius: BorderRadius.circular(2.r)),
            child: Center(
                child: Text(
              buttonText,
              style: AppTextStyles.componentLabels(isNormal: true,),
            )),
          ))
        ],
      ),
    ),
  );
}

Widget pictureContainer({required Widget child}) =>
    Container(height: 25.h, margin: EdgeInsets.only(bottom: 8.h), child: child);

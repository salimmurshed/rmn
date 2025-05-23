import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:high_q_paginated_drop_down/high_q_paginated_drop_down.dart';
import 'package:rmnevents/presentation/home/staff_home_bloc/staff_home_bloc.dart';
import 'package:rmnevents/presentation/pos_settings/bloc/pos_settings_bloc.dart';
import '../../../imports/common.dart';
import '../../../imports/data.dart';
import '../../../root_app.dart';
import '../widgets/events_drop_down.dart';
import '../widgets/image_stack.dart';
import '../widgets/pos_device.dart';

class StaffHome extends StatefulWidget {
  const StaffHome({super.key});

  @override
  State<StaffHome> createState() => _StaffHomeState();
}

class _StaffHomeState extends State<StaffHome> {
  static const double borderRadius = 10.0;
  static const double iconSize = 148.0;
  static const double iconHeight = 150.0;

  @override
  void initState() {
   // BlocProvider.of<PosSettingsBloc>(context).add(TriggerFetchReaders());
    BlocProvider.of<StaffHomeBloc>(context).add(TriggerFetchStaffHomeInfo());
    super.initState();
  }

  final String imageUrl = AppAssets.imgStaffHomeLanding;

  @override
  Widget build(BuildContext context) {
    return BlocListener<StaffHomeBloc, StaffHomeWithInitialState>(
      listener: (context, state) {},
      child: BlocBuilder<StaffHomeBloc, StaffHomeWithInitialState>(
        builder: (context, state) {
          return customScaffoldForImageBehind(
            appBar: customAppBarForImageBehind(
                context: context, onTap: () {}, isLeadingPresent: false),
            body: state.isLoading
                ? CustomLoader(child: buildStaffBody(state))
                : buildStaffBody(state),
          );
        },
      ),
    );
  }

  Widget buildStaffBody(StaffHomeWithInitialState state) {
    return SizedBox(
      height: Dimensions.getScreenHeight(),
      child: Stack(
        children: [
          ImageStack(
            isLocal: state.eventData?.coverImage == null,
            imageUrl: state.eventData?.coverImage != null
                ? (state.assetUrl + state.eventData!.coverImage!)
                : imageUrl,
            address: 'LAS VEGAS, NEVADA',
            date: '27 Aug, 2022',
            title: 'F2W Colorado State Championships',
          ),
          Positioned(
            bottom: isTablet ? 0.h : 50.h,
            left: 0,
            right: 0,
            top: 75.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PosDevice(
                    deviceName: state.readerData == null
                        ? ''
                        : 'S700 (${state.readerData!.label})',
                    isConnected: state.readerData != null),
                SizedBox(height: 12.h),
                Container(
                  width: Dimensions.getScreenWidth(),
                  margin: EdgeInsets.symmetric(horizontal: 15.w),
                  padding: EdgeInsets.only(
                      left: 16.w, top: 10.h, right: 16.w, bottom: 10.h),
                  decoration: BoxDecoration(
                    color: AppColors.colorSecondary,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.staff_home_eventContainer_title,
                        style: AppTextStyles.smallTitle(isOutFit: false),
                      ),
                      SizedBox(height: 10.h),
                      EventsDropDown(
                        eventNames: state.eventList
                            .map((e) =>
                                e.title ?? AppStrings.global_empty_string)
                            .toList(),
                        onSelected: (v) {
                          BlocProvider.of<StaffHomeBloc>(context)
                              .add(TriggerChooseEvent(eventName: v));
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25.h),
                GestureDetector(
                  onTap: () {
                    if (state.eventData != null) {
                      Navigator.pushNamed(context, AppRouteNames.routeQRScan);
                    } else {
                      buildCustomToast(
                          msg: 'You must select an event to scan',
                          isFailure: true);
                    }
                  },
                  child: Opacity(
                    opacity: state.eventData != null ? 1 : 0.3,
                    child: Container(
                        height: !isTablet ? null : Dimensions.getScreenWidth() / 6,
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.w,),
                        width: Dimensions.getScreenWidth(),
                        child: SvgPicture.asset(AppAssets.icQRScanBtn,  width: Dimensions.getScreenWidth(),fit: BoxFit.fill,)),
                  ),
                ),
                SizedBox(height: 12.h),
                GestureDetector(
                    onTap: () {
                      if (state.eventData != null && state.readerData != null) {
                        Navigator.pushNamed(
                            context, AppRouteNames.routeRegisterNSell,arguments: state.eventData);
                      } else {
                        if (state.readerData == null &&
                            state.eventData == null) {
                          buildCustomToast(
                              msg:
                                  'You must connect a device and select an event to register & sell',
                              isFailure: true);
                        } else {
                          if (state.readerData == null) {
                            buildCustomToast(
                                msg:
                                    'You must connect a device to register & sell',
                                isFailure: true);
                          } else {
                            buildCustomToast(
                                msg:
                                    'You must select an event to register & sell',
                                isFailure: true);
                          }
                        }
                      }
                    },
                    child: Opacity(
                      opacity:
                          state.eventData != null && state.readerData != null
                              ? 1
                              : 0.3,
                      child: Container(
                        height: !isTablet ? null : Dimensions.getScreenWidth() / 6,
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w,),
                        width: Dimensions.getScreenWidth(),
                        child: SvgPicture.asset(
                          AppAssets.icRnSBtn,
                            width: Dimensions.getScreenWidth(),
                          fit: BoxFit.fill,
                        ),
                      ),
                    )),
                SizedBox(height: 12.h),
                GestureDetector(
                  onTap: () {
                    if (state.eventData != null) {
                      Navigator.pushNamed(
                              context, AppRouteNames.routeFindCustomers)
                          .then((value) => {
                                // BlocProvider.of<StaffHomeBloc>(context)
                                //     .add(TriggerCheckOnAppRestart())
                              });
                    } else {
                      buildCustomToast(
                          msg: 'You must select an event to find customers',
                          isFailure: true);
                    }
                  },
                  child: Opacity(
                      opacity: state.eventData != null ? 1 : 0.3,
                      child: Container(
                          height: !isTablet ? null : Dimensions.getScreenWidth() / 6,
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.w,),
                          width: Dimensions.getScreenWidth(),
                          child: SvgPicture.asset(AppAssets.icCustomerAccBtn, width: Dimensions.getScreenWidth(),fit: BoxFit.fill,))),
                ),
                SizedBox(height: 12.h),
                buildTransactionHistoryText(),
              ],
            ),
          )
        ],
      ),
    );
  }

  //
  //
  Widget buildActionButtons(
      EventData? eventData, StaffHomeWithInitialState state) {
    return SizedBox(
      width: isTablet ? (2 * iconSize.w - 20.w) : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildActionButton(
              toastMessage: eventData != null
                  ? AppStrings.global_empty_string
                  : 'You must select an event to scan',
              active: eventData != null,
              route: AppRouteNames.routeQRScan,
              asset: AppAssets.imgScan),
          SizedBox(width: isTablet ? 0 : 15.w),
          buildActionButton(
              toastMessage: eventData != null && state.readerData != null
                  ? AppStrings.global_empty_string
                  : (state.readerData == null
                      ? 'You must connect a device to register & sell'
                      : 'You must select an event to register & sell'),
              active: eventData != null && state.readerData != null,
              route: AppRouteNames.routeRegisterNSell,
              asset: AppAssets.imgRNP,
              navigatorValue: eventData),
        ],
      ),
    );
  }

  //

  Widget buildActionButton(
      {bool active = true,
      String? route,
      required String toastMessage,
      required String asset,
      dynamic navigatorValue}) {
    return GestureDetector(
      onTap: active
          ? () {
              if (route != null) {
                Navigator.pushNamed(context, route, arguments: navigatorValue);
              }
            }
          : () {
              buildCustomToast(msg: toastMessage, isFailure: true);
            },
      child: Opacity(
        opacity: active ? 1 : 0.2,
        child: Container(
          height: isTablet ? 150.h : 140.h,
          width: isTablet ? null : 140.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
          child: Image.asset(asset),
        ),
      ),
    );
  }

  Widget buildTransactionHistoryText() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRouteNames.routeHistory);
      },
      child: Text(
        'View Scan & Transaction History',
        style: TextStyle(
          decorationStyle: TextDecorationStyle.solid,
          decorationThickness: 2,
          decorationColor: AppColors.colorPrimaryInverseText,
          decoration: TextDecoration.underline,
          fontFamily: AppFontFamilies.squada,
          fontWeight: AppFontWeight.titleSmallWeightedOutFit,
          fontSize: AppFontSizes.titleSmall,
          color: AppColors.colorPrimaryInverseText,
        ),
      ),
    );
  }

  Positioned svgElevationComponent() {
    return Positioned(
      left: 3.w,
      top: 2.h,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.colorSecondary,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(17.r),
            bottomLeft: Radius.circular(15.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        height: 130.h,
        width: 148.w,
      ),
    );
  }
}

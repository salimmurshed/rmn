import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/imports/common.dart';

import '../../home/widgets/pos_device.dart';
import '../bloc/pos_settings_bloc.dart';
import '../widgets/pos_info_dialog.dart';

class PosSettingsView extends StatefulWidget {
  const PosSettingsView({super.key});

  @override
  State<PosSettingsView> createState() => _PosSettingsViewState();
}

class _PosSettingsViewState extends State<PosSettingsView> {
  @override
  initState() {
    BlocProvider.of<PosSettingsBloc>(context).add(TriggerFetchReaders());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosSettingsBloc, PosSettingsState>(
      builder: (context, state) {
        return customScaffold(
          hasForm: false,
          customAppBar: CustomAppBar(
            title: AppStrings.deviceSettings_title,
            isLeadingPresent: true,
          ),
          anyWidgetWithoutSingleChildScrollView: null,
          formOrColumnInsideSingleChildScrollView: state.isLoading
              ? SizedBox(
                  height: Dimensions.getScreenHeight() * 0.8,
                  child: Center(
                    child: CustomLoader(
                      child: Container(),
                    ),
                  ),
                )
              : buildPOSLayout(state),
        );
      },
    );
  }

  Column buildPOSLayout(PosSettingsState state) {
    return Column(
      children: [
        if (state.selectedReader != null)
          PosDevice(
              deviceName: 'S700 (${state.selectedReader!.label!})',
              isConnected: true,
              isFromSettings: true),
        SizedBox(
          height: 20.h,
        ),
        ListTileTheme(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: 0,
          minVerticalPadding: 0,
          minLeadingWidth: 0.w,
          tileColor: AppColors.colorSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: ExpansionTile(
            minTileHeight: 40.h,
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.r),
            ),
            initiallyExpanded: true,
            leading: SizedBox(height: 10.h, width: 10.w),
            tilePadding: EdgeInsets.only(right: 10.w),
            childrenPadding: EdgeInsets.symmetric(vertical: 10.h),
            iconColor: AppColors.colorPrimaryInverse,
            collapsedIconColor: AppColors.colorPrimaryInverse,
            collapsedTextColor: AppColors.colorPrimaryInverse,
            textColor: AppColors.colorPrimaryInverse,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.r),
            ),
            backgroundColor: AppColors.colorPrimary,
            collapsedBackgroundColor: AppColors.colorSecondary,

            // Background when collapsed
            onExpansionChanged: (val) {
              // onExpansionChanged(val);
            },
            title: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                margin: EdgeInsets.only(right: 10.w),
                child: Row(
                  children: [
                    Text(
                        AppStrings
                            .staff_home_posContainer_availableDevicesContainer_title,
                        style: TextStyle(
                            color: AppColors.colorPrimaryInverseText,
                            fontFamily: AppFontFamilies.squada,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w300)),
                    Text('(${state.readers.length})',
                        style: TextStyle(
                            color: AppColors.colorPrimaryNeutralText,
                            fontFamily: AppFontFamilies.squada,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w300)),
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: () {
                        buildDialogForStaffPosInfo(
                            context: context,
                            posInfoType: PosInfoType.available);
                      },
                      child: Icon(
                        Icons.info_outline,
                        color: AppColors.colorPrimaryNeutral,
                      ),
                    )
                  ],
                )),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.colorSecondary,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.colorSecondary,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          children: [
                            if (index != 0)
                              SizedBox(
                                height: 10.h,
                              ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    'S700 (${state.readers[index].label ?? AppStrings.global_empty_string})',
                                    maxLines: 3,
                                    style: TextStyle(
                                        color:
                                            AppColors.colorPrimaryInverseText,
                                        fontFamily: AppFontFamilies.squada,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(width: 10.w),
                                if (state.readers[index].status == 'online')
                                  GestureDetector(
                                    onTap:state.readers[index].isAvailable! ? (!state
                                            .readers[index].isConnectActive!
                                        ? () {
                                            buildCustomShowModalBottomSheetParent(
                                                ctx: context,
                                                isNavigationRequired: false,
                                                child:
                                                    customBottomSheetBasicBody(
                                                        title:
                                                            'Do you want to disconnect from the device',
                                                        highLightedAthleteName:
                                                            state.readers[index]
                                                                .label!,
                                                        highLightedString: state
                                                            .readers[index]
                                                            .label!,
                                                        isAccentedHighlight:
                                                            true,
                                                        afterHighlighterPortionIntitle:
                                                            ' ?',
                                                        isSingeButtonPresent:
                                                            false,
                                                        onLeftButtonPressed:
                                                            () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        leftButtonText:
                                                            AppStrings
                                                                .btn_cancel,
                                                        onRightButtonPressed:
                                                            () {
                                                          BlocProvider.of<
                                                                      PosSettingsBloc>(
                                                                  context)
                                                              .add(TriggerConnectToAReader(
                                                                  isConnect:
                                                                      false,
                                                                  deviceIndex:
                                                                      index, shouldCallDisconnectEmit: true));
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        rightButtonText:
                                                            'Disconnect',
                                                        context: context,
                                                        footerNote:
                                                            'If you disconnect from this device, you will not be able to make any further transactions until you connect to a new device.',
                                                        singleButtonText: AppStrings
                                                            .global_empty_string,
                                                        isActive: true,
                                                        isSingleButtonColorFilled:
                                                            false));
                                          }
                                        : () {
                                            if (state
                                                .readers[index].isAvailable!) {
                                              if(state
                                                  .readers[index].isConnectActive!){
                                                buildCustomShowModalBottomSheetParent(
                                                    ctx: context,
                                                    isNavigationRequired: false,
                                                    child:
                                                    customBottomSheetBasicBody(
                                                        title:
                                                        'Do you want to connect to device ',
                                                        highLightedAthleteName:
                                                        state
                                                            .readers[
                                                        index]
                                                            .label!,
                                                        highLightedString:
                                                        state
                                                            .readers[
                                                        index]
                                                            .label!,
                                                        isAccentedHighlight:
                                                        true,
                                                        afterHighlighterPortionIntitle:
                                                        ' ?',
                                                        isSingeButtonPresent:
                                                        false,
                                                        onLeftButtonPressed:
                                                            () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        leftButtonText:
                                                        AppStrings
                                                            .btn_cancel,
                                                        onRightButtonPressed:
                                                            () {
                                                          BlocProvider.of<
                                                              PosSettingsBloc>(
                                                              context)
                                                              .add(TriggerConnectToAReader(
                                                              isConnect:
                                                              true,
                                                              deviceIndex:
                                                              index));
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        rightButtonText:
                                                        'Connect',
                                                        context: context,
                                                        footerNote:
                                                        'Ensure that this is the correct device that you are using to avoid problems.\nIf you are already connected to a device, the connection to this device will be disconnected.',
                                                        singleButtonText:
                                                        AppStrings
                                                            .global_empty_string,
                                                        isActive: true,
                                                        isSingleButtonColorFilled:
                                                        false));
                                              }else{
                                                BlocProvider.of<
                                                    PosSettingsBloc>(
                                                    context)
                                                    .add(TriggerConnectToAReader(
                                                    isConnect:
                                                    false,
                                                    deviceIndex:
                                                    index,shouldCallDisconnectEmit: true));
                                                Navigator.pop(
                                                    context);
                                              }

                                            }
                                          }): (){
                                      if(!state.readers[index].isConnectActive!){
                                        buildCustomShowModalBottomSheetParent(
                                            ctx: context,
                                            isNavigationRequired: false,
                                            child:
                                            customBottomSheetBasicBody(
                                                title:
                                                'Do you want to disconnect from the device',
                                                highLightedAthleteName:
                                                state.readers[index]
                                                    .label!,
                                                highLightedString: state
                                                    .readers[index]
                                                    .label!,
                                                isAccentedHighlight:
                                                true,
                                                afterHighlighterPortionIntitle:
                                                ' ?',
                                                isSingeButtonPresent:
                                                false,
                                                onLeftButtonPressed:
                                                    () {
                                                  Navigator.pop(
                                                      context);
                                                },
                                                leftButtonText:
                                                AppStrings
                                                    .btn_cancel,
                                                onRightButtonPressed:
                                                    () {
                                                  BlocProvider.of<
                                                      PosSettingsBloc>(
                                                      context)
                                                      .add(TriggerConnectToAReader(
                                                      isConnect:
                                                      false,
                                                      deviceIndex:
                                                      index, shouldCallDisconnectEmit: true));
                                                  Navigator.pop(
                                                      context);
                                                },
                                                rightButtonText:
                                                'Disconnect',
                                                context: context,
                                                footerNote:
                                                'If you disconnect from this device, you will not be able to make any further transactions until you connect to a new device.',
                                                singleButtonText: AppStrings
                                                    .global_empty_string,
                                                isActive: true,
                                                isSingleButtonColorFilled:
                                                false));
                                      }else{
                                        buildCustomShowModalBottomSheetParent(
                                            ctx: context,
                                            isNavigationRequired: false,
                                            child:
                                            customBottomSheetBasicBody(
                                                title:
                                                'Do you want to connect with this device ',
                                                highLightedAthleteName:
                                                state
                                                    .readers[
                                                index]
                                                    .label!,
                                                highLightedString:
                                                state
                                                    .readers[
                                                index]
                                                    .label!,
                                                isAccentedHighlight:
                                                true,
                                                afterHighlighterPortionIntitle:
                                                ' ?',
                                                isSingeButtonPresent:
                                                false,
                                                onLeftButtonPressed:
                                                    () {
                                                  Navigator.pop(
                                                      context);
                                                },
                                                leftButtonText:
                                                AppStrings
                                                    .btn_cancel,
                                                onRightButtonPressed:
                                                    () {
                                                  BlocProvider.of<
                                                      PosSettingsBloc>(
                                                      context)
                                                      .add(TriggerConnectToAReader(
                                                      isConnect:
                                                      true,
                                                      deviceIndex:
                                                      index));
                                                  Navigator.pop(
                                                      context);
                                                },
                                                rightButtonText:
                                                'Connect',
                                                context: context,
                                                footerNote: 'This S700 is already in use by another employee. Connecting to this S700 will automatically disconnect the other employee. \n\nPlease only do this if you know that the other employee is not currently using it.',
                                                singleButtonText:
                                                AppStrings
                                                    .global_empty_string,
                                                isActive: true,
                                                isSingleButtonColorFilled:
                                                false));
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        if(!state.readers[index].isAvailable! && state.readers[index].status == 'online' && state.readers[index].isConnectActive!)
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8.0),
                                            child: Text('Already in use!', style: AppTextStyles.largeTitleWithoutLingThrough(color: AppColors.colorAccentText,isSquada: false),),
                                          ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: ((!state.readers[index]
                                                        .isConnectActive!)
                                                    ? Colors.transparent
                                                    : AppColors
                                                        .colorSecondaryAccent),
                                            borderRadius:
                                                BorderRadius.circular(5.r),
                                            border: ((!state.readers[index]
                                                        .isConnectActive!)
                                                    ? Border.all(
                                                        color: AppColors
                                                            .colorPrimaryAccent,
                                                        width: 1)
                                                    : null),
                                          ),
                                          padding:
                                          EdgeInsets.symmetric(
                                              horizontal: 13.w, vertical: 6.h),
                                          margin:
                                              EdgeInsets.symmetric(vertical: 2.h),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                Text(
                                                    (  (!state.readers[index]
                                                            .isConnectActive!)
                                                        ? 'Disconnect'
                                                        : 'Connect'),
                                                    style: AppTextStyles.regularPrimary(
                                                        color: ((!state.readers[index]
                                                                .isConnectActive!)
                                                            ? AppColors
                                                                .colorPrimaryAccent
                                                            : AppColors
                                                                .colorPrimaryInverseText),
                                                        isOutFit: false)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (state.readers[index].status != 'online')
                                  buildConnectedContainer(
                                      isConnected: false, string: 'Offline')
                              ],
                            ),
                            if (index == 0 || index != state.readers.length - 1)
                              if (state.readers.length != 1)
                                SizedBox(
                                  height: 10.h,
                                ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 0.5.h,
                        color: AppColors.colorPrimaryDivider,
                      );
                    },
                    itemCount: state.readers.length),
              )
            ],
          ),
        )
      ],
    );
  }
}

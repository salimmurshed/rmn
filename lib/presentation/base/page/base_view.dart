import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rmnevents/presentation/all_events/page/all_events_map_view.dart';
import 'package:rmnevents/presentation/home/page/client_home.dart';
import 'package:rmnevents/presentation/home/page/staff_home.dart';
import 'package:rmnevents/presentation/profile/bloc/profile_bloc.dart';
import '../../../imports/common.dart';
import '../../../root_app.dart';
import '../../profile/page/profile_view.dart';
import '../../staff_chat/event_general_view/page/staff_chat_view.dart';
import '../bloc/base_bloc.dart';

class BaseView extends StatefulWidget {
  BaseView({super.key, this.justSignedIn = true});

  bool? justSignedIn;

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> with RouteAware{
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      RouteObserverProvider.routeObserver.subscribe(this, route);
    }
  }
  @override
  void dispose() {
    RouteObserverProvider.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    debugPrint('Current route: ${ModalRoute.of(context)?.settings.name}');
  }

  @override
  void didPopNext() {
    debugPrint('Current route: ${ModalRoute.of(context)?.settings.name}');
  }
  @override
  void initState() {
    if(widget.justSignedIn != null){
      if (widget.justSignedIn!) {
        BlocProvider.of<BaseBloc>(context).add(TriggerFetchBaseData());
      }
      else {
        BlocProvider.of<ProfileBloc>(context).add(const TriggerUpdateProfile(
          isFromRestart: true,
        ));
      }
    }
    BlocProvider.of<BaseBloc>(context).add(TriggerGetIntialMessage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BaseBloc, BaseWithInitialState>(
      listener: (context, state) {
        // globalSeasons = state.seasons;
        globalTeams = state.teams;
        globalCurrentSeason = state.currentSeason;
        globalTransactionFee = state.transactionFee;
        currentRole = state.currentRole;
        globalGrades = state.gradeList;

      },
      child: BlocBuilder<BaseBloc, BaseWithInitialState>(
        builder: (context, state) {
          return Scaffold(
            body: state.isLoading
                ? CustomLoader(
              child: Container(),
            )
                : (state.viewNumber == 0
                ? (currentRole == AppStrings.global_role_user
                ? const ClientHome()
                : const StaffHome())
                : state.viewNumber == 1
                ? (currentRole == AppStrings.global_role_user
                ? const AllEventsMapView()
                : const StaffChatView())
                : const ProfileView()),
            backgroundColor: AppColors.colorPrimary,
            bottomNavigationBar: currentRole.isEmpty? null: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              unselectedLabelStyle: AppTextStyles.componentLabels(),
              selectedLabelStyle: AppTextStyles.componentLabels(),
              currentIndex: state.viewNumber,
              backgroundColor: AppColors.colorPrimary,
              selectedItemColor: AppColors.colorPrimaryAccent,
              unselectedItemColor: AppColors.colorPrimaryInverseText,
              onTap: state.isLoading ? (int i){}:(int i) {
                BlocProvider.of<BaseBloc>(context)
                    .add(TriggerViewNumberUpdates(viewNumber: i));
              },
              items: currentRole.isEmpty ? []:[
                BottomNavigationBarItem(
                  label: AppStrings.base_btmNavigation_homeView_title,
                  icon: SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child:
                      // state.currentRole.isEmpty
                      //     ? CircularProgressIndicator(
                      //         valueColor: AlwaysStoppedAnimation<Color>(
                      //             AppColors.colorPrimaryAccent),
                      //       )
                      //     :
                      SvgPicture.asset(
                          currentRole == AppStrings.global_role_user
                              ? AppAssets.icHome
                              : AppAssets.icQR,
                          colorFilter: ColorFilter.mode(
                              state.viewNumber == 0
                                  ? AppColors.colorPrimaryAccent
                                  : AppColors.colorPrimaryInverseText,
                              BlendMode.srcIn))),
                ),
                BottomNavigationBarItem(
                  label: currentRole == AppStrings.global_role_user
                      ? AppStrings.base_btmNavigation_eventsMapView_title
                      : AppStrings.base_btmNavigation_staff_chatView_title,
                  icon: SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              currentRole == AppStrings.global_role_user
                                  ? AppAssets.icWrestling
                                  : AppAssets.icChat,
                              colorFilter: ColorFilter.mode(
                                  state.viewNumber == 1
                                      ? AppColors.colorPrimaryAccent
                                      : AppColors.colorPrimaryInverseText,
                                  BlendMode.srcIn),
                            ),
                          ),
                          if(currentRole != AppStrings.global_role_user && state.unreadCount != 0)
                             Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                  color: state.viewNumber == 1 ? AppColors.colorPrimaryInverse : AppColors.colorPrimaryAccent,
                                shape: BoxShape.circle
                              ),
                              child: Center(
                                child: Text(state.unreadCount.toString(),style: AppTextStyles.verySmallTitle(color:  state.viewNumber == 1 ? AppColors.colorPrimaryAccent : AppColors.colorPrimaryInverse),),
                              )
                            ),
                          )
                        ],
                      )
                  ),
                ),
                BottomNavigationBarItem(
                  label: AppStrings.base_btmNavigation_profileView_title,
                  icon: SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: SvgPicture.asset(AppAssets.icNavProfile,
                          colorFilter: ColorFilter.mode(
                              state.viewNumber == 2
                                  ? AppColors.colorPrimaryAccent
                                  : AppColors.colorPrimaryInverseText,
                              BlendMode.srcIn))),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
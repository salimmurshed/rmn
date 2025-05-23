part of 'profile_bloc.dart';

@freezed
class ProfileWithInitialState with _$ProfileWithInitialState {
  const factory ProfileWithInitialState({
    required String fullName,
    required String email,
    required String phone,
    required String cachedNetworkImageUrl,
    required String noOfAthletes,
    required String noOfAwards,
    required String noOfUpcomingEvents,
    required String message,
    required bool isFailure,
    required bool isRefreshRequired,
    required bool isLoadingForUserInfo,
    required bool isLoadingForLogout,
    required bool isLogout,
    required String label,
    required bool isSwitchPresent,
    required String currentUser,
    required List<MyAccountMenuModel> myAccountMenuModelList,
  }) = _ProfileWithInitialState;

  factory ProfileWithInitialState.initial() =>
      ProfileWithInitialState(
        message: AppStrings.global_empty_string,
        noOfAthletes: '0',
        noOfAwards:'0',
        noOfUpcomingEvents: '0',
        isFailure: false,
        isLoadingForUserInfo: true,
        isLogout: false,
        email: AppStrings.global_empty_string,
        cachedNetworkImageUrl: AppStrings.global_empty_string,
        fullName: AppStrings.global_empty_string,
        myAccountMenuModelList: [
          MyAccountMenuModel(
            iconUrl: AppAssets.icAdd,
            routeName: AppRouteNames.routeCreateOrEditAthleteProfile,
            menuTitle: AppStrings.accountSettings_menu_addNewAthlete_title,
          ),
          MyAccountMenuModel(
            iconUrl: AppAssets.icEdit,
            routeName: AppRouteNames.routeCreateOrEditAthleteProfile,
            menuTitle: AppStrings.accountSettings_menu_myProfiles_title,
          ),
          MyAccountMenuModel(
            iconUrl: AppAssets.icProfile,
            routeName: AppRouteNames.routeMyAthleteProfiles,
            menuTitle: AppStrings.accountSettings_menu_myAthleteProfiles_title,
          ),
          MyAccountMenuModel(
            iconUrl: AppAssets.icCart,
            routeName: AppRouteNames.routeMyPurchases,
            menuTitle: AppStrings.accountSettings_menu_myPurchases_title,
          ),
          MyAccountMenuModel(
            iconUrl: AppAssets.icPeople,
            routeName: AppRouteNames.routeBuySeasonPasses,
            menuTitle: AppStrings.accountSettings_menu_seasonPass_title,
          ),
          MyAccountMenuModel(
            iconUrl: AppAssets.icAppSettings,
            routeName: AppRouteNames.routeAppSettings,
            menuTitle: AppStrings.accountSettings_menu_appSettings_title,
          ),
          MyAccountMenuModel(
            iconUrl: AppAssets.icLegals,
            routeName: AppRouteNames.routeLegals,
            menuTitle: AppStrings.accountSettings_menu_legals_title,
          ),
          MyAccountMenuModel(
            iconUrl: AppAssets.icEnvelope,
            routeName: AppRouteNames.routeGetInTouch,
            menuTitle: AppStrings.accountSettings_menu_getInTouch_title,
          ),
        ],
        phone: '',
        isLoadingForLogout: false,
        label: AppStrings.global_empty_string,
        isSwitchPresent: false,
        isRefreshRequired: false,
        currentUser: AppStrings.global_empty_string,
      );
}

class MyAccountMenuModel {
  String menuTitle;
  String routeName;
  String iconUrl;

  MyAccountMenuModel({
    required this.iconUrl,
    required this.routeName,
    required this.menuTitle,
  });
}
//rafia.chowdhury@vitec-visual.com
//shriyank.mendpara@vitec-visual.com
//Dragon1!123456
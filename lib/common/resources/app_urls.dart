import 'package:rmnevents/common/resources/app_enums.dart';
import 'package:rmnevents/presentation/base/bloc/base_bloc.dart';

import '../../imports/app_configurations.dart';
import 'app_strings.dart';

//rafiaraha04@gmail.com
class UrlSuffixes {
  static String privacyPolicy = "${UrlPrefixes.baseWebUrl}/privacy-policy";
  static String termsAndConditions =
      "${UrlPrefixes.baseWebUrl}/terms-condition";
  static const String signInSignUp = '/sign-up';
  static const String signInSignUpSocially = "/social-login";
  static const String verifyEmail = '/verify-otp';
  static const String resendOtp = '/resend-otp';
  static const String createOwnerProfile = '/update-userinfo';
  static const String createAthleteProfile = '/create-athlete';
  static const String updateAthleteProfile = '/update-athlete';
  static const String deleteAthleteProfile = '/delete-athlete';
  static const String purchaseMembership = '/purchase-membership';
  static const String homeAthlete = '/athletes';
  static const String sendRequestToAnAthlete = '/request-athlete';
  static const String cancelRequestToAnAthlete = '/cancel-request';
  static const String acceptRejectRequests = '/accept-reject-athlete';
  static const String removeCard = '/cards/remove';
  static const String listCMS = '/list-cms';
  static const String getFAQs = '/faqs';
  static const String getGrades = '/grades';
  static const String getUnreadCount = '/admin/unread-count';
  static const String submitQueries = '/create-contact';
  static const String logout = '/logout';
  static const String changeEmail = '/change-email';
  static const String updateEmail = '/update-email';
  static const String changePassword = '/change-password';
  static const String deleteAccount = '/delete-account';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = "/reset-password";
  static String getEventsOnMap = '/events/map?';
  static String getPopUps = '/popups';
  static String changeInitialPassword = '/change-initial-password';

  static String postProduct({required String eventId}) =>
      '/admin/events/$eventId/purchase';

  static String postRegistration({required String eventId}) =>
      '/admin/events/$eventId/registrations';

  static String getPlacements({required String id}) => '/events/$id/placements';

  static String getSearchEventsOnMap({required String searchKey}) =>
      '/events/map?search=$searchKey';

  static String getAllEvents({required num page}) =>
      '/events?page=$page&per_page=-1&season_id=${globalCurrentSeason.id}';

  static String getFilteredEvents(
          {required num page, required FilterType filterType}) =>
      '/events?type=${filterType.name}&page=$page&per_page=8&season_id=${globalCurrentSeason.id}';

  static String getFilteredEventsOnMaps({required FilterType filterType}) =>
      '/events/map?type=${filterType.name}';

  static String getSearchResults(
          {required num page,
          required FilterType filterType,
          required String searchKeyword}) =>
      filterType == FilterType.miscellaneous
          ? '/events?page=$page&per_page=-1&search=$searchKeyword'
          : '/events?type=${filterType.name}&page=$page&per_page=-1&search=$searchKeyword';

  static String myAthletes({required int page, required String searchKey}) =>
      searchKey.isEmpty
          ? '/athletes?page=$page'
          : '/athletes?search=$searchKey&page=$page';

  static String getEventWiseAthletes({required String eventId}) =>
      '/athletes?filter=owner-coach&event_id=$eventId';

  static String getDivsWeights(
          {required String divId, required String eventID}) =>
      '/divisions/$divId/weight-classes?event_id=$eventID';

  static String changeWC({required String eventId}) =>
      '/events/$eventId/register/weight-classes';

  static String allAthletes({
    required int page,
  }) =>
      '/all-athlete?page=$page';

  // static String eventRegister(String eventId) => '/events/$eventId/register';
  //
  // static String eventPurchaseProducts(String eventId) =>
  //     '/events/$eventId/purchase-tickets';

  static String eventPurchase (String eventId) => '/events/$eventId/purchase';
  static String eventPurchaseSeasons = '/purchase-membership';

  static String receivedAthleteRequests(
          {required int page, required String searchKey}) =>
      searchKey.isEmpty
          ? '/received-requests?page=$page'
          : '/received-requests?search=$searchKey&page=$page';

  static String findAthletes({required String searchKey}) =>
      '/all-athlete?search=$searchKey';
  static const String home = '/home';
  static const String getEventDetailsData = '/events';
  static const String getCurrentSeason = '/current-season';
  static const String getCardList = '/cards';
  static const String askContactSupport = '/contact-support';

  static String getQuestionnaire({required String eventId}) =>
      '/events/$eventId/questionnaire';
  static const String getNotificationList = '/notifications';
  static const String getNotificationCount = '/notifications/unread-count';

  static String searchEvents({required String searchKey}) =>
      '/events?search=$searchKey';

  static String getEventListSeasonWiseForSpecificAthlete(
          {required String athleteId,
          required String seasonId,
          required String eventType}) =>
      '/athletes/$athleteId/events/$eventType?season_id=$seasonId';

  static String removeAthletePartialOwner(
          {required String athleteId, required bool isViewer}) =>
      isViewer
          ? '/athletes/$athleteId/viewers/remove'
          : '/athletes/$athleteId/coaches/remove';

  static String getAthletePartialOwnerList(
          {required String athleteId, required bool isViewer}) =>
      isViewer
          ? '/athletes/$athleteId/viewers'
          : '/athletes/$athleteId/coaches';

  static String getAthleteDetails(
          {required String athleteId,
          String seasonId = AppStrings.global_empty_string}) =>
      '/athletes/$athleteId?season_id=$seasonId';
  static String getTeams = '/teams';
  static String getSeasons = '/seasons';
  static const String teamNameRequest = "/teams";
  static const String getProfile = "/profile";

  static String postOrGetQRId({required String id}) =>
      '/admin/purchases/$id/scan';
  static String getAthletesWithoutSeasonPass =
      '/athletes?without_membership=true&filter=owner';
  static String getMyPurchasesSeasonPasses = '/purchases/memberships';
  static String getSeasonPasses = '/memberships';
  static String getMyPurchasesProducts = '/purchases/products';
  static String getTransactionFee = '/settings/transaction_fees';

  static String getCouponDetails(
          {required String code, required String module}) =>
      '/coupons/$code?module=$module';

  static String getEventChat({required String eventId}) =>
      '/events/$eventId/chats';

  static String changeTeam({required String athleteId}) =>
      "/athletes/$athleteId/event-team";

  static String getMyPurchasedProductDetailEventWise(
          {required String eventId}) =>
      '/events/$eventId/purchases';

  static String getAwardsForSpecificAthlete(
          {required String athleteId, required String seasonId}) =>
      '/athletes/$athleteId/awards?season_id=$seasonId';

  static String getHistory({required int page, String type = 'all'}) =>
      '/admin/history/scans?page=$page&per_page=10&type=$type';

  static String getSales({required int page}) =>
      '/admin/history/purchases?page=$page&per_page=10';

  static String getRanksForSpecificAthlete(
          {required String athleteId, required String seasonId}) =>
      '/athletes/$athleteId/ranks?season_id=$seasonId';

  static String allEvents({required String type, required int page}) =>
      type == FilterType.miscellaneous.name
          ? '/events?page=$page&per_page=-1'
          : '/events?type=$type&page=$page';

  static String getRegsList(String id) => '/events/$id/registrations';
  static String getStripeReaders = '/admin/payments/readers';
  static String getEmployeeEventList = '/admin/events/upcoming';

  static String getStaffEventData({required String id, required String? userId}) => userId == null ? '/admin/events/$id':'/admin/events/$id?user_id=$userId';

  static String getGeneralChatList(
          {required int page, required String status}) =>
      '/admin/conversations/general/?page=$page&per_page=10&status=$status';

  static String getEventChatList() => '/admin/conversations/events';

  static String deleteGeneralChat({required String roomId}) =>
      '/admin/conversations/$roomId/delete';

  static String addToArchiveChat({required String roomId}) =>
      '/admin/conversations/$roomId/archive';

  static String unArchiveAll({String? eventId}) =>
      '/admin/conversations/unarchive-all${eventId != '' ? '?event_id=$eventId' : ''}';

  static String unReadCount({String? eventId}) =>
      '/admin/conversations/counts${eventId != '' ? '?event_id=$eventId' : ''}';

  static String removeFromArchiveChat({required String roomId}) =>
      '/admin/conversations/$roomId/un-archive';

  static String fetchEventChatsData(
          {required String eventId,
          required int page,
          required String status}) =>
      '/admin/events/$eventId/conversations?page=$page&status=$status';

  static String getGeneralChats({required String eventId}) =>
      '/admin/conversations/$eventId';

  static String unReadMessage({required String roomId}) =>
      '/admin/conversations/$roomId/mark-as-read';

  static String markAsRead({required String roomId}) =>
      '/conversations/$roomId/mark-as-read';

  static String cancelPurchase({required String paymentId}) =>
      '/admin/purchases/$paymentId/cancel';

  static String getUsers(
          {String searchKey = AppStrings.global_empty_string,
          required int page}) =>
      searchKey.isEmpty
          ? '/admin/users?page=$page&per_page=10'
          : '/admin/users?page=$page&per_page=10&search=$searchKey';

  static String getCustomerPurchases(
          {required String eventId, required String userId}) =>
      '/admin/users/$userId/purchases/$eventId';

  static String markAsScanned({required String purchaseId}) =>
      '/admin/purchases/$purchaseId/scan';

  static String getCustomerAthletes({required String userId, required String eventId}) =>
      '/admin/users/$userId/athletes?event_id=$eventId&filter=owner-coach';
}

class UrlPrefixes {
  static String baseUrl = AppEnvironments.baseUrl;
  static String baseWebUrl = AppEnvironments.baseWebUrl;

  static const String stripeTokenUrl = "https://api.stripe.com/v1/tokens";
}

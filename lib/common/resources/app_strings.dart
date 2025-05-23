// ignore_for_file: constant_identifier_names

import '../../imports/common.dart';

class AppStrings {
  //No internet
  static const String global_noInternet_text = 'No Internet Connection.';
  static const String global_calendar_monthYear_title = "Pick a month and year";

//Roles
  static const String global_url_no_launch = 'Could not launch url: ';
  static const String global_role_owner = 'owner';
  static const String global_role_admin = 'admin';
  static const String global_role_employee = 'employee';
  static const String global_role_user = 'user';
  static const String global_fillUpAllFields_text =
      'All fields are required and must be valid.';

  // Default Route
  static const String global_defaultRoute_title = 'Page not found.';
  static const String global_division_category_title = 'Division';
  static const String global_select_a_variant = 'Variant';
  static const String global_select_a_month = 'Select Month';
  static const String global_select_a_year = 'Select Year';
  static const String global_empty_string = '';
  static const String global_empty_user = 'N/A';
  static const String global_general_string = 'General Notification';
  static const String global_empty_zero = '0';
  static const String global_error_string = 'Invalid Request Error';
  static const String global_no_team = 'No Team';
  static const String global_used = 'Scanned';
  static const String global_search_hint = 'Search';
  static const String global_emptyAthleteProfile_text =
      "You've not registered any athlete yet!";
  static const String global_google_places_error =
      'An error occurred while fetching the data. Please try again later.';
  static const String global_date_format = 'yyyy-dd-MM';
  static const String global_phone_code = '1';
  static const String global_owner_flag = '0';
  static const String global_athlete_flag = '0';
  static const String global_gender_male = 'male';
  static const String global_gender_female = 'female';
  static const String global_no_season_pass = 'No Season Pass';
  static const String
      global_athleteRegistration_findOtherTeam_bottomSheet_title =
      'Did Not Find Your Team?';
  static const String
      global_athleteRegistration_findOtherTeam_bottomSheet_subtitle =
      "That's not a problem";
  static const String
      global_athleteRegistration_findOtherTeam_bottomSheet_body =
      "If you haven't found your team, you can submit it to us here for review.\nThis usually takes around 7 business days.\nYou will receive an email about our decision.\nIf we still have questions, our support team will get in touch with you.";
  static const String
      global_athleteRegistration_findOtherTeam_bottomSheet_warning_predecessor_text =
      "IMPORTANT: ";
  static const String
      global_athleteRegistration_findOtherTeam_bottomSheet_warning_body_text =
      "Please check beforehand whether this team really does not exist.";
  static const String
      global_athleteRegistration_findOtherTeam_bottomSheet_footer =
      "Already existing teams: ";

  static const String global_athleteAccessType_owner_title = 'Owner';
  static const String global_athleteAccessType_coach_title = 'Coach';
  static const String global_athleteAccessType_view_title = 'Viewer';

  //onboarding
  static const String onboarding_welcome_text = 'Welcome to RMN Events';
  static const String onboarding_welcome_predecessor_text =
      'Amazing wrestling\nexperience, you never\nhad before.';
  static const String onboarding_welcome_successor_text =
      'RMN Events reserves the right to combine weights.\nIf the wrestlers also want to combine weights.';

  //Base
  static const String base_btmNavigation_homeView_title = 'Home';
  static const String base_btmNavigation_eventsMapView_title = 'Events';
  static const String base_btmNavigation_staff_chatView_title = 'Chat';
  static const String base_btmNavigation_profileView_title = 'Profile';
  static const String base_btmNavigation_scanView_title = 'Sell & Scan';
  static const String base_btmNavigation_chatView_title = 'Chat';

  // Staff
  //Home
  static const String staff_home_title = 'Home';
  static const String staff_home_welcome_title = 'Welcome';
  static const String staff_home_history_noQRData_title =
      'No scanning history available.';
  static const String staff_home_staffInfo_body_text =
      'This is your workspace for scanning QR codes for registrations, products, and more.\nThe app shows you if a QR code was scanned successfully, failed, or if the code has already been used.\nIn the history you can find all your recent QR code scans.\nIf you have any questions, please contact your manager.';
  static const String staff_home_scanQRCode_button_text = 'Scan QR Code';
  static const String staff_home_posContainer_title = 'Selected S700 Device';
  static const String staff_home_eventContainer_title = 'Selected Event';
  static const String staff_home_posContainer_changeCTA = 'Change';
  static const String staff_home_posContainer_connectCTA = 'Connect to S700';
  static const String staff_home_posContainer_connected_status = 'Connected to';
  static const String staff_history_title = 'Scan & Transaction History';
  static const String staff_home_posContainer_noDevice_status =
      'No device selected';
  static const String staff_home_posContainer_availableDevicesContainer_title =
      'Other Available Devices ';
  static const String staff_home_posContainer_connectedDevice_title =
      'Current Connected PoS Device';
  static const String staff_home_posContainer_connectedDevice_subtitle =
      'This is the current device connected to handle all transactions.';
  static const String staff_home_posContainer_availableDevice_title =
      'Devices Available for Connection';
  static const String staff_home_posContainer_availableDevice_subtitle =
      'Several devices are currently available for connection and are ready to handle payment transactions.';

  //QR View
  static const String staff_qrView_title = 'Scan Purchase';
  static const String staff_qrView_scanAgain_btn_text = 'Scan Again';

  //History
  static const String staff_chat_title = 'Chats';
  static const String staff_history_empty_text =
      'No scanning history available.';
  static const String staff_history_itemStatus_success_text = 'Success';
  static const String staff_history_itemStatus_failure_text = 'Failed';
  static const String staff_history_itemScanner_prefix_text = 'Scanned By ';
  static const String staff_history_itemBuyer_prefix_text = 'Purchased By ';
  static const String staff_history_itemEvent_prefix_text = 'Event: ';

//Delete Account
  static const String deleteAccount_title = 'Delete Account';
  static const String deleteAccount_warningText_title =
      'Do you want to delete your account permanently?';
  static const String deleteAccount_warningText_subtitle =
      "Deleting your account is permanent.";
  static const String deleteAccount_warningText_body =
      "Deleting your account will remove your profile, settings, and you will lose access to all your purchases and data. This cannot be reversed. Are you sure?";

  // Sign In
  static const String authentication_signIn_title = 'Sign In';
  static const String authentication_signIn_subTitle =
      'Please sign in to get started';
  static const String authentication_signIn_signInBtn = 'Log In';
  static const String authentication_signInHere_signInBtn = 'Login here';
  static const String authentication_signIn_signUpBtn = 'Sign Up';
  static const String authentication_signIn_forgotPasswordBtn =
      'Forgot Password?';
  static const String authentication_signIn_noAccount_text =
      'Don\'t have an account?';
  static const String authentication_signIn_socialSignInOptions_text =
      'Or sign in with';

  // Sign Up
  static const String authentication_signUp_title = 'Let\'s Get Started';
  static const String authentication_signUp_subTitle =
      'Create an account to get started with RMN Events';
  static const String authentication_signUp_signUpBtn = 'Sign Up';
  static const String authentication_signUp_signInBtn = 'Log In';
  static const String authentication_signUp_alreadyHaveAccount_text =
      'Already have an account?';
  static const String authentication_signUp_socialSignInOptions_text =
      'Or sign in with';
  static const String authentication_signUp_condition_preceeding_text =
      'By signing up, you will agree to our ';
  static const String authentication_signUp_termsAndConditionsBtn =
      'Terms & Conditions ';
  static const String authentication_signUp_condition_joiner_text = 'and ';
  static const String authentication_signUp_privacyPolicyBtn = 'Privacy Policy';
  static const String authentication_checkBox_error =
      'Please, accept the terms & conditions and privacy policy to proceed.';

  // Password Validations
  static const String passwordValidation_minDigitCheck_text =
      'At least 1 digit';
  static const String passwordValidation_minLowerCaseCheck_text =
      'At least 1 lowercase letter';
  static const String passwordValidation_minUpperCaseCheck_text =
      'At least 1 uppercase letter';
  static const String passwordValidation_minSpecialCharCheck_text =
      'At least 1 special character';
  static const String passwordValidation_minLengthCheck_text =
      'At least 8 characters';

  //Sign Up Mask
  static const String authentication_signUpMask_title = 'Let\'s Get Started';
  static const String authentication_signUpMask_subTitle =
      'Create an account to get started with RMN Events';
  static const String authentication_signUpMask_signUpBtn = 'Sign Up';
  static const String authentication_signUpMask_signInBtn = 'Sign In';
  static const String authentication_signUpMask_alreadyHaveAccount_text =
      'Already have an account?';
  static const String authentication_signUpMask__condition_preceeding_text =
      'By signing up, you agree to our ';
  static const String authentication_signUpMask__termsAndConditionsBtn =
      'Terms & Conditions ';
  static const String authentication_signUpMask__condition_joiner_text = 'and ';
  static const String authentication_signUpMask__privacyPolicyBtn =
      'Privacy Policy';

  //Oto Verification
  static const String authentication_otpVerification_title = 'Verify Email';
  static const String authentication_otpVerification_subTitle1 =
      'To verify you email address and your identity, we have sent you a 6-digit code to your email: ';
  static const String authentication_otpVerification_subTitle2 =
      '.\nThe code is valid for 10 minutes. Please, also check your spam folder.';
  static const String authentication_otpVerification_resendCodeBtn =
      'Resend Code';
  static const String authentication_otpVerification_verifyBtn = 'Verify';
  static const String authentication_otpVerification_didNotReceiveCode_text =
      'Didn\'t receive the code?';
  static const String authentication_otpVerification_resendSuggestion_text =
      'You can resend the code in...';
  static const String authentication_otpVerification_checkSpamFolder_text =
      'If you can\'t find the email, please check your spam folder.';

  //Event Detail View
  static const String eventDetailView_information_tabButtonTitle =
      'Information';
  static const String eventDetailView_registrationList_tabButtonTitle =
      'Registration List';
  static const String eventDetailView_goLive_text = 'Live Stream';
  static const String eventDetailView_divisions_tabButtonTitle = 'Divisions';
  static const String eventDetailView_schedule_tabButtonTitle = 'Schedule';
  static const String eventDetailView_hotels_tabButtonTitle = 'Hotels';
  static const String eventDetailView_awards_tabButtonTitle = 'Awards';
  static const String eventDetailView_products_tabButtonTitle = 'Products';
  static const String
      eventDetailView_divisionTab_weightInGuideLines_tabButtonTitle =
      'Weigh-In Guidelines';
  static const String eventDetailView_divisionTab_divsions_tabButtonTitle =
      'Divisions';
  static const String eventDetailsView_appbarActions_button_title =
      'Bracket Chat';
  static const String eventDetailsView_registration_button_title = 'Register';
  static const String eventDetailsView_buyTicket_button_title = 'Buy';

  //Event registration limitation
  static const String event_registration_limitation_sold_out = 'Sold Out';
  static const String event_registration_limitation_available = 'Available';
  static const String event_registration_limitation_avilable_title =
      'Hurry! Limited registrations for this event!';
  static const String event_registration_limitation_avilable_subtitle =
      'Limited registrations left for this event left. Secure your spot now!';
  static const String event_registration_limitation_sold_out_title =
      'Sold Out!';
  static const String event_registration_limitation_sold_out_sub_title =
      'All registrations for this event have been taken.You can no longer register for this event. Please take a look at our other events!';

  //Event Detail Athlete Registration
  static const String eventDetails_athleteRegistration_team_textField_hint =
      'Team Name';
  static const String
      eventDetails_athleteRegistration_athleteInfo_noOfRegistration =
      'No. of Registrations: ';
  static const String eventDetailView_information_empty =
      "There is no information available for this event.";
  static const String eventDetailView_registrationListTab_empty =
      "The registration list has not yet been published.";
  static const String eventDetailView_registrationListSubTab_empty =
      "We will publish it a few days before the event begins.";
  static const String eventDetailView_divisionsTab_empty =
      "There are no divisions for this event yet.";
  static const String eventDetailView_scheduleTab_empty =
      "There is no schedule available for this event.";
  static const String eventDetailView_hotelsTab_empty =
      "There are no hotels available for this event.";
  static const String eventDetailView_awardsTab_empty =
      "There are no awards available for this event.";
  static const String eventDetailView_productsTab_empty =
      "There are no products available for this event.";
  static const String eventDetailView_divisionTab_weightInGuideLines_empty =
      "There are no weigh-in guidelines available for this event.";
  static const String eventDetailView_divisionTab_divsions_empty =
      "There are no divisions available for this event.";

  //Forgot Password -> Reset Password
  static const String authentication_resetPassword_title = 'Reset Password';
  static const String authentication_resetPassword_isRequired_title =
      'For security reasons, you have to change your password.';
  static const String authentication_resetPassword_subTitle =
      'Please enter your email associated with your account and we will send you an email with instructions to reset your password.';
  static const String authentication_resetPassword_resetPasswordBtn =
      'Reset Password';
  static const String authentication_resetPassword_rememberPassword_text =
      'Remember password?';
  static const String authentication_resetPassword_signInBtn = 'Sign In';
  static const String
      authentication_resetPassword_resetPasswordBottomSheet_title =
      'Password Changed';
  static const String
      authentication_resetPassword_resetPasswordBottomSheet_footer =
      'Your password has been changed successfully. Please sign in with your new password.';
  static const String
      authentication_resetPassword_resetPasswordBottomSheet_SignInBtn =
      'Sign In';

  //Profile
  //Owner
  static const String profile_createOwner_title = 'Create Profile';

  static const String profile_createProfile_successStatus_bottomSheet_title =
      'You Have Successfully Joined RMN Events';
  static const String profile_createProfile_successStatus_bottomSheet_subtitle =
      "Congratulations! Your account has been successfully created. Let's start the journey.";
  static const String profile_EditProfile_title = 'Account Settings';
  static const String profile_EditProfile_emailUpdate_bottomSheet_title =
      'Update Email Address';
  static const String profile_EditProfile_emailUpdate_bottomSheet_subtitle =
      "Please add your new email address here and verify the email.";
  static const String profile_EditProfile_changePassword_btn_text =
      "Change Password";
  static const String profile_EditProfile_update_btn_text = "Update";

  //Athlete
  static const String profile_createAthlete_title = 'Create Athlete';
  static const String profile_editAthlete_title = 'Edit Athlete';
  static const String profile_createAthlete_btn_text = 'Create Athlete';
  static const String profile_athlete_metrics_upcoming_title =
      'Upcoming Registrations';
  static const String profile_athlete_metrics_rank_title = 'Best ranking';
  static const String profile_athlete_metrics_awards_title = 'Total Awards Won';
  static const String profile_athlete_metrics_weight_title = 'Weight';
  static const String profile_athlete_metrics_age_title = 'Age';
  static const String profile_athlete_metrics_upcoming_subtitle =
      "This metric shows the number of upcoming registrations of this athlete for any event of the current season. Registrations for events that have already taken place are not counted.";
  static const String profile_athlete_metrics_rank_subtitle =
      "This metric shows the best ranking of this athlete in the current season across all brackets.";
  static const String profile_athlete_metrics_awards_subtitle =
      "This metric shows the total number of awards won for all seasons in which the athlete has participated.";
  static const String profile_athlete_metrics_weight_subtitle =
      "This metric shows the highest registered weight class for an upcoming registration for an event.";
  static const String profile_athlete_metrics_age_subtitle =
      "This metric shows the age of the athlete following our January 1st age group cut-off-date regulation.";

  static const String profile_createEditAthlete_uploadImage_bottomSheet_title =
      "Upload a Photo of the Athlete";
  static const String
      profile_createEditAthlete_uploadImage_bottomSheet_subtitle =
      "Please, use your phone's camera or gallery.";
  static const String
      profile_createEditAthlete_uploadImageWithCamera_bottomSheet_buttonTitle =
      "Camera";
  static const String
      profile_createEditAthlete_uploadImageFromGallery_bottomSheet_buttonTitle =
      "Gallery";
  static const String profile_createEditAthlete_dropDown_label =
      'Select a team';
  static const String profile_createEditAthlete_dropDownGrade_label =
      'Select Grade';
  static const String profile_createEditAthlete_dropDownGrade_hint =
      'Select your grade';
  static const String profile_createEditAthlete_dropDown_search_hint =
      'Search for a team...';
  static const String profile_createAthlete_dropDown_hint = 'Select Team';

  //Event Wise Athlete Registration
  static const String eventWiseAthleteRegistration_divisionList_title =
      'Select Division(s) & Assign Athletes';

  //Event Wise Athlete Registration
  static const String eventWiseAthleteRegistration_athleteEmptyList_text =
      "You don't have an athlete.";
  static const String
      eventWiseAthleteRegistration_selectedAthleteEmptyList_text =
      "No athletes selected for registration.";
  static const String eventWiseAthleteRegistration_yourAthleteEmptyList_title =
      "No matching athletes found.";
  static const String
      eventWiseAthleteRegistration_yourAthleteEmptyList_subtitle =
      "You do not have a matching athlete who can be registered in this age group.";

  //Chat View
  static const String chat_appBar_info_text =
      'If you have any questions about this event, from bracketing to the event itself, please contact us here.';
  static const String message_field = 'Enter your message';

  //Athlete Details
  static const String athleteDetails_title = 'Athlete Details';
  static const String athleteDetails_upcomingEvents_tab_title =
      'Upcoming Events';
  static const String athleteDetails_pastEvents_tab_title = 'Past Events';
  static const String athleteDetails_awards_tab_title = 'Awards';
  static const String athleteDetails_ranks_tab_title = 'Ranking';
  static const String athleteDetails_upcomingEvents_bottomSheet_subtitle =
      'Here’s the complete breakdown of registered upcoming events.';
  static const String athleteDetails_pastEvents_bottomSheet_subtitle =
      "Here’s the complete breakdown of registered past events.";
  static const String athleteDetails_seasonName_dropDown_hint =
      'Select a Season';
  static const String athleteDetails_totalRegistration_title =
      'Total Registrations: ';
  static const String athleteDetails_emptyUpcomingEvents_text =
      'No upcoming events found.';
  static const String athleteDetails_awardsList_text = 'No awards received.';
  static const String athleteDetails_ranksList_text = 'No ranks received.';
  static const String athleteDetails_emptyPastEvents_text =
      'No past events found.';
  static const String athleteDetails_emptyAwardsList_text =
      'No awards received';
  static const String athleteDetails_emptyRanksList_text = 'No ranks received.';

  //Metrics
  static const String athleteMetrics_rank_text = 'Best rank across all seasons';
  static const String athleteMetrics_award_text = 'Awards received all seasons';
  static const String athleteMetrics_weight_text = "Athlete's weight";
  static const String athleteMetrics_age_text = 'Athlete\'s age';
  static const String athleteMetrics_dob_text = 'Date of birth';
  static const String athleteMetrics_upcomingEvents_text =
      'Upcoming event registrations';

  //My athletes
  static const String myAthletes_title = 'My Athletes';
  static const String myAthletes_myAthletes_tabBar_title = 'My Athletes';
  static const String myAthletes_findAthletes_tabBar_title = 'Find Athletes';
  static const String myAthletes_requests_tabBar_title = 'Requests';
  static const String myAthletes_request_coachAccess_description_text =
      "Coach Access gives you the same ability as View Access, but additionally the ability to register this athlete for events.";
  static const String myAthletes_request_viewAccess_description_text =
      "View Access gives you the ability to view the athlete’s information about achievements, progress and events.";
  static const String myAthletes_request_ownerAccess_description_text =
      "Ownership Access gives you complete control over the profile. If this request is approved, the profile will be transferred to your account.";
  static const String myAthletes_myAthleteTab_viewProfile_btn = "View Profile";
  static const String myAthletes_myAthleteTab_answerRequest_btn =
      "Answer Request";
  static const String myAthletes_myAthleteTab_purchaseProfile_btn = "Get Pass";
  static const String myAthletes_myAthleteTab_requestProfile_btn = "Request";
  static const String myAthletes_myAthleteTab_viewProfileWithNoMembership_btn =
      "View";
  static const String myAthletes_myAthleteTab_coach_btn = "Coach";
  static const String myAthletes_myAthleteTab_requestFurtherAccess_btn =
      "Request";
  static const String myAthletes_allAthleteTab_requestAccess_btn =
      "Request Access";
  static const String myAthletes_allAthleteTab_cancel_btn = "Cancel";
  static const String myAthletes_allAthleteTab_support_btn = "Support";
  static const String myAthletes_requestsTab_accept_btn = "Accept";
  static const String myAthletes_requestTab_reject_btn = "Reject";
  static const String myAthletes_myAthletesTab_emptyAthleteList_text =
      "You have not yet added an athlete to your profile.";
  static const String myAthletes_requestsTab_emptyAthleteList_text =
      "You don't have any athlete requests.";
  static const String myAthletes_emptySearchList_text = "Athlete is not found.";
  static const String myAthletes_bottomSheet_accessRequest_title =
      "Request Access To";
  static const String myAthletes_bottomSheet_accessRequest_subtitle =
      "Select the type of access request you want to send to the athlete's responsible person.";
  static const String myAthletes_bottomSheet_supportRequest_title =
      "Support Request To";
  static const String myAthletes_bottomSheet_cancelRequest_title =
      "Cancel Request To";

  static String myAthletes_bottomSheet_cancelRequest_subtitle(
          {required TypeOfAccess typeOfAccess}) =>
      typeOfAccess == TypeOfAccess.owner
          ? "Are you sure you want to cancel the request for Ownership Access?"
          : typeOfAccess == TypeOfAccess.coach
              ? "Are you sure you want to cancel the request for Coach Access?"
              : "Are you sure you want to cancel the request for View Access?";
  static const String myAthletes_bottomSheet_supportRequest_footerNote =
      "You have not received any response and your request is pending for over 7 days?\nForward this request to our support team to follow up.\nWe will keep you updated.";
  static const String
      myAthletes_bottomSheet_supportRequest_contactSupport_btn_text =
      "Contact Support";
  static const String
      myAthletes_bottomSheet_supportRequest_noContactSupport_btn_text =
      "You can only contact the support 7 days after requesting.";

  static const String
      myAthletes_bottomSheet_acceptRejectBody_ownershipAccess_preceding_text =
      "If you agree to the request, the user will receive the administrative rights over the athlete ";
  static const String
      myAthletes_bottomSheet_acceptRejectBody_ownershipAccess_following_text =
      '.\nYou will no longer have access.\nTo continue to have, for example, view access, you must make a request for the athlete afterwards.';
  static const String
      myAthletes_bottomSheet_acceptRejectBody_ownershipAccess_footer_text =
      "The profile will be transferred to:";

  static const String
      myAthletes_bottomSheet_acceptRejectBody_coachAccess_preceding_text =
      "If you agree to the request, the user will receive coach rights about the athlete ";
  static const String
      myAthletes_bottomSheet_acceptRejectBody_coachAccess_following_text =
      '.\nThis means that user will be able to view the athlete\'s registrations, results and progress.\nAlso user can register this athlete in events.';
  static const String
      myAthletes_bottomSheet_acceptRejectBody_coachAccess_footer_text =
      "Coach rights will be granted to:";

  static const String
      myAthletes_bottomSheet_acceptRejectBody_viewAccess_preceding_text =
      "If you agree to the request, the user will receive view rights about the athlete ";
  static const String
      myAthletes_bottomSheet_acceptRejectBody_viewAccess_following_text =
      '.\nThis means that user will be able to view the athlete\'s registrations, results and progress.';
  static const String
      myAthletes_bottomSheet_acceptRejectBody_viewAccess_footer_text =
      "View rights will be granted to:";

  static String myAthletes_bottomSheet_acceptRejectBody_title(
          {required String access}) =>
      'Confirmation $access Request';

  static String myAthletes_bottomSheet_acceptRejectBody_accessType_title(
          {required int access}) =>
      access == 0
          ? 'View Access'
          : access == 1
              ? 'Ownership Access'
              : 'Coach Access';

  //Payment Card
  static const String payment_addCard_title = 'Add Credit Card';
  static const String payment_addCard_successToast =
      'Your card has been added successfully!';
  static const String payment_addCard_saveText =
      " Securely save card for future payments";
  static const String payment_addCard_deleteCard_bottomSheet_title =
      "Delete Card";
  static const String payment_addCard_deleteCard_successToast =
      "Card removed successfully";
  static const String payment_addCard_deleteCard_empty_bottomSheet_subtitle =
      "There is no card to delete. Please select a card first.";
  static const String
      payment_addCard_deleteCard_selectedCard_bottomSheet_subtitle =
      "Deleting the selected card will remove it from your account. Are you sure you want to delete this card?";
  static const String payment_addCard_noCard_text =
      "You have not added any card yet.\nPlease add a card to proceed.";

  //Client Home
  static const String clientHome_title = 'Home';
  static const String clientHome_nextEvents_title = 'Your Next Events';
  static const String clientHome_athletes_title = 'Your Athletes';
  static const String clientHome_eventType_live_text = 'LIVE';
  static const String clientHome_eventType_next_text = 'Next';
  static const String clientHome_viewAll_button_text = 'View All';
  static const String clientHome_nullLiveCard_text = 'No Live or Next Events';

  static const String clientHome_nextEvents_empty_text =
      'You have not yet registered for an event this season.';
  static const String clientHome_athletes_empty_text =
      'You have not yet added an athlete to your profile.';
  static const String clientHome_eventRegisterNow_button_text = 'Register Now';
  static const String clientHome_addAthleteNow_button_text = 'Add Athlete Now';

  //All Events
  static String allEvents_title({required String season}) => 'Event $season';
  static const String allEvents_upcomingTab_title = 'Upcoming';
  static const String allEvents_pastTab_title = 'Past';
  static const String allEvents_emptyUpcomingList_text =
      'There are no upcoming events available where you can register athletes in the current season.';
  static const String allEvents_emptyUpcomingMap_text =
      'There are no upcoming events available in the current season.';
  static const String allEvents_emptyPastList_text =
      'There are no past events in the current season.';
  static const String allEvents_emptyPastMap_text =
      'There are no past events in the current season in the current season.';
  static const String allEvents_emptyMiscellaneousList_text =
      'There are no events in the current season.';
  static const String allEvents_emptyMiscellaneousMap_text =
      'There are no events in the current season.';

  static String allEvents_emptySearchResult_text({required String searchKey}) =>
      "No events match your search for '$searchKey'. Check your spelling, try different keywords, or browse all events.";

//Notifications
  static const String notifications_title = 'Notifications';

  //Account Settings
  static const String accountSettings_menu_addNewAthlete_title =
      'Add a New Athlete';
  static const String accountSettings_menu_myAthleteProfiles_title =
      'My Athletes';
  static const String accountSettings_menu_myProfiles_title =
      'Profile Settings';
  static const String accountSettings_menu_myPurchases_title = 'My Purchases';
  static const String accountSettings_menu_seasonPass_title = 'Season Pass';
  static const String accountSettings_menu_appSettings_title = 'App Settings';
  static const String accountSettings_menu_legals_title = 'Legals';
  static const String accountSettings_menu_legals_imprints_title = 'Imprints';
  static const String accountSettings_menu_legals_tou_title = 'Terms of Usage';
  static const String accountSettings_menu_legals_foss_title = 'FOSS';
  static const String accountSettings_menu_legals_pp_title = 'Privacy Policy';
  static const String accountSettings_menu_getInTouch_title = 'Get in Touch';
  static const String accountSettings_logoutBtn_title = 'Log Out';
  static const String accountSettings_logoutBtn_subtitle =
      "You can stay logged in and simply close the app if you'll be back soon. Are you sure you want to log out instead?";
  static const String accountSettings_zeroAthleteMenu_preceding_title =
      'Set Up your first athlete profile';
  static const String accountSettings_settings_preceding_title = 'Settings';
  static const String accountSettings_profileMetrics_athlete_label = 'Athletes';
  static const String accountSettings_profileMetrics_awards_label = 'Awards';
  static const String accountSettings_profileMetrics_upcomings_label =
      'Upcomings';

  //Get In touch
  static const String getInTouch_contactUs_title = 'Contact Us';
  static const String getInTouch_aboutUs_title = 'About Us';
  static const String getInTouch_faq_title = 'FAQ';

  //Event registration
  static const String eventRegistration_athleteSelection_intro_text =
      "Select weight classes for your athletes";

  //Purchase

  static const String purchase_productsTab_emptyList = 'No products available.';
  static const String purchase_hotelTab_emptyList = 'No hotels available.';
  static const String purchase_awardTab_emptyList = 'No awards available.';
  static const String purchase_athletesTab_emptyList =
      'Select an athlete and season pass that you want to buy.';
  static const String purchase_tab_summary_title = 'Summary';
  static const String purchase_tab_registration_title = 'Registrations';
  static const String purchase_tab_registrationSummary_title =
      'Registration Summary';
  static const String purchase_tab_registrationSelection_title =
      'Select Division(s) & Assign Athletes';
  static const String purchase_tab_products_title = 'Products';
  static const String purchase_tab_productSelect_title = 'Select Products';
  static const String purchase_tab_athleteSelect_title = 'Select Products';
  static const String purchase_tab_payment_title = 'Payment';
  static const String purchase_tab_paymentSelect_title =
      'Select Payment Method';

  static const String purchase_registrationAthlete_pass_type =
      'Pass Registration';
  static const String purchase_registrationAthlete_guest_type =
      'Guest Registration';
  static const String purchase_registrationAthlete_selectCategory_title =
      'Select Category';
  static const String purchase_registrationAthlete_grade_title =
      'GRADE & WEIGHTS';
  static const String purchase_registrationAthlete_ageGroup_title =
      'Select AgeGroup(s) & Assign Athletes';

  //My Purchases
  //My Season Passes
  static const String myPurchases_title = 'My Purchases';
  static const String myPurchases_tab_seasonPasses_title = 'Season Passes';
  static const String myPurchases_tab_registration_title = 'Registrations';
  static const String myPurchases_tab_products_title = 'Products';
  static const String myPurchases_qrCode_noScanDetails_text =
      'Scan to Validate';
  static const String myPurchases_qrCode_scanDetailsConfirmed_text = 'Scanned';
  static const String myPurchases_qrCode_noScanDetailsCancelled_text =
      'Cancelled';
  static const String myPurchases_noSeasonPasses_text =
      "No season passes have been purchased.";
  static const String myPurchases_noProducts_text =
      "No registrations or products have been purchased.";

  //Purchased products
  static const String purchasedProducts_noRegistrations_text =
      "No athlete have been registered yet.";
  static const String purchasedProducts_noProducts_text =
      "No products have been purchased.";

  //Buy Season Passes
  static const String buySeasonPasses_subtitle =
      "Here you can find all our Season Passes for the current season. Each of them offers you different benefits. Get the Season Passes for your athletes and enjoy the full RMN Events experience.";
  static const String buySeasonPasses_athleteWithoutSeasonPass_title =
      "Athletes Without Season Pass";
  static const String buySeasonPasses_athleteWithoutSeasonPass_emptyList_text =
      "There is no athlete selected or existing without a season pass.";
  static const String
      buySeasonPasses_athleteWithoutSeasonPass_bottomSheetButton_title =
      "Select Season Pass";
  static const String buySeasonPass_selectSeasonPass_bottomSheet_subtitle =
      '''Select the tier you would like to assign to this athlete. You can only assign one tier to each athlete.''';
  static const String buySeasonPass_selectAthlete_bottomSheet_title =
      "Purchase Season Pass";
  static const String buySeasonPass_selectAthlete_bottomSheet_subtitle =
      "Select Athlete Profiles";

  static const String myPurchases_bottomSheet_invoiceDownload_title =
      'Select Invoice to Download';
  static const String myPurchases_bottomSheet_invoiceDownload_subtitle =
      'Select Invoice';
  static const String myPurchases_bottomSheet_invoiceDownload_hint =
      'Select Invoice';
  static const String myPurchases_bottomSheet_invoiceDownload_prompt =
      'Select Invoice';
  static const String myPurchases_bottomSheet_invoiceDownload_btn_text =
      'Download';
  static const String myPurchases_invoiceDownloaded_success_text =
      'Invoice Downloaded Successfully!';
  static const String
      myPurchases_registration_teamReselection_bottomSheet_title =
      'Change Team in Registration';

  static String myPurchases_registration_teamReselection_bottomSheet_subtitle(
          {required String athleteName, required String eventName}) =>
      'You may change the team for $athleteName for the event, $eventName. If you change the team, all registrations for this athlete for this event will be changed. Please select a team from the drop-down menu and confirm.';
  static const String
      myPurchases_registration_teamReselection_bottomSheet_prompt =
      'Select Team';
  static const String myPurchases_registration_changeWc_bottomsheet_title =
      'Change Weight Class in Registration';

  static String myPurchases_registration_changeWc_bottomsheet_subtitle(
          {required String athleteName,
          required String eventName,
          required String divisionName,
          required String divisionType,
          required String style}) =>
      'You are about to change the weight class(es) for $athleteName for the event, $eventName for $divisionName $divisionType $style. You are sure you want to do this?';

  //App Settings
  static const String appSettings_title = 'App Settings';
  static const String appSettings_permissionAccess_title = 'Permission Access';
  static const String appSettings_crashCollection_switch_title =
      'Data crash collection';
  static const String appSettings_crashCollection_switch_subtitle =
      'Enabling crash collection will allow us to build more reliable, well-functional, and joyful application for you.';
  static const String appSettings_enableLocation_switch_title =
      'Enable Location';
  static const String appSettings_enableLocation_switch_subtitle =
      'By enabling the location access, you’ll be able to see the RMN Events happening near you.';
  static const String appSettings_notification_switch_title = 'Notification';
  static const String appSettings_notification_switch_subtitle =
      'Enable notification so you don’t miss any updates from RMN Events.';

  static const String appSettings_appInformation_expansionTile_title =
      "App Information";
  static const String
      appSettings_appInformation_expansionTile_applicationName_title =
      "App Information";
  static const String
      appSettings_appInformation_expansionTile_applicationVersion_title =
      "Application Version:";
  static const String
      appSettings_appInformation_expansionTile_applicationBuildNumber_title =
      "Application Build-Number:";

  //TextFields
  //Labels
  static const String textfield_addEmail_label = 'Email Address';
  static const String textfield_password_label = 'Password';
  static const String textfield_newPassword_label = 'Password';
  static const String textfield_confirmPassword_label = 'Confirm Password';
  static const String textfield_oldPassword_label = 'Old Password';
  static const String textfield_addFirstName_label = 'First Name';
  static const String textfield_addLastName_label = 'Last Name';
  static const String textfield_addTeamName_label = 'Team Name';
  static const String textfield_addContactNumber_label = 'Contact Number';
  static const String textfield_addBodyWeight_label = 'Body Weight';
  static const String textfield_addAddress_label = 'Post Address';
  static const String textfield_addZip_label = 'Zip Code';
  static const String textfield_addCardHolderName_label = 'Card Holder Name';
  static const String textfield_addCardNumber_label = 'Card Number';
  static const String textfield_addCardNumber_cvc_label = 'CVC';
  static const String textfield_addCardNumber_expiryDate_label = 'Expiry Date';
  static const String textfield_selectGender_label = 'Select Gender';
  static const String textfield_selectATeam_label = 'Select A Team';
  static const String textfield_selectDateOfBirth_label = 'Date of Birth';
  static const String textfield_addMessage_label = 'Message';

  //hints
  static const String textfield_addEmail_hint = 'Enter email';
  static const String textfield_password_hint = 'Enter password';
  static const String textfield_confirmPassword_hint = 'Re-type password';
  static const String textfield_oldPassword_hint = 'Enter old password';
  static const String textfield_newPassword_hint = 'Enter new password';
  static const String textfield_addFirstName_hint = 'Enter first name';
  static const String textfield_addLastName_hint = 'Enter last name';
  static const String textfield_addTeamName_hint = 'Enter team name';
  static const String textfield_addContactNumber_hint =
      'Enter your contact number';
  static const String textfield_addBodyWeight_hint = 'Body weight';
  static const String textfield_addAddress_hint = 'Enter address';
  static const String textfield_addZip_hint = 'Enter zip code';
  static const String textfield_selectATeam_hint = 'Select Team';
  static const String textfield_selectDateOfBirth_hint = 'Date of Birth';
  static const String textfield_addCardHolderName_hint =
      'Enter Card Holder Name';
  static const String textfield_addCardNumber_hint = 'Enter Card Number';
  static const String textfield_addCouponCode_hint = 'Coupon Code';
  static const String textfield_addCardNumber_cvc_hint = 'Enter CVC';
  static const String textfield_addCardNumber_expiryDate_hint = 'MM/YY';
  static const String textfield_addMessage_hint = 'Enter your message';

  //errors
  static const String textfield_addEmail_emptyField_error =
      'Email field is required';
  static const String textfield_addEmail_invalidInput_error =
      'Please, enter a valid email';
  static const String textfield_addPassword_emptyField_error =
      'Password field is required';
  static const String textfield_addOldPassword_emptyField_error =
      'Old password field is required';
  static const String textfield_addPassword_invalidInput_error =
      'Please, enter a valid password';
  static const String textfield_addConfirmPassword_emptyField_error =
      'Confirm Password field is required';
  static const String textfield_addConfirmPassword_invalidInput_error =
      'Retyped password doesn\'t match with password';
  static const String textfield_addPin_invalidInput_error =
      'Please, enter a 6-digit valid pin';
  static const String textfield_addFirstName_emptyField_error =
      'First Name field is required';
  static const String textfield_addFirstName_minLength_error =
      'First Name should be at least 2 characters';
  static const String textfield_addFirstName_maxLength_error =
      'First Name should be at most 20 characters';
  static const String textfield_addLastName_maxLength_error =
      'Last Name should be at most 20 characters';
  static const String textfield_addLastName_minLength_error =
      'Last Name should be at least 2 characters';
  static const String textfield_addLastName_emptyField_error =
      'Last Name field is required';
  static const String textfield_addCardHolderName_emptyField_error =
      'Card Holder Name field is required';
  static const String textfield_addCardHolderName_minLength_error =
      'Card Holder Name should be at least 2 characters';
  static const String textfield_addCardHolderName_maxLength_error =
      'Card Holder Name should be at most 40 characters';
  static const String textfield_addPostalAddress_emptyField_error =
      'Postal Address field is required to have a valid address with city name';
  static const String textfield_addContactNumber_emptyField_error =
      'Contact Number field is required';
  static const String texfield_addZip_emptyField_error =
      'Zip Code field is required';
  static const String texfield_addZip_invalid_error =
      'Zip Code can only contain numbers';
  static const String textfield_selectDateOfBirth_emptyField_error =
      'Date of Birth field is required';
  static const String textfield_selectDateOfBirth_owner_minYear_error =
      'Your age must be at least of 13 years.';
  static const String textfield_selectDateOfBirth_athlete_minYear_error =
      'Your athlete must be at least 4 years old';
  static const String textfield_addWeight_emptyField_error =
      'Weight field is required';
  static const String textfield_addMessage_emptyField_error =
      'Please enter your message';
  static const String textfield_emptyField_error = 'Please enter text';

  static const String image_uploadTooSmallFile_error =
      "Image size must be at least 2.5 MB.";
  static const String image_uploadTooLargeFile_error =
      "Image size must not exceed 2.5 MB.";
  static const String textfield_addCardNumber_emptyField_error =
      "Card Number field is required";
  static const String textfield_addCardNumber_invalidInput_error =
      "Please, enter a valid card number";
  static const String textfield_addCardNumber_cvc_emptyField_error =
      "CVC field is required";
  static const String textfield_addCardNumber_cvc_invalidInput_error =
      "Please, enter a valid CVC";
  static const String textfield_addCardNumber_expiryDate_emptyField_error =
      "Expiry Date field is required";

  //Buttons
  static const String btn_create = 'Create';
  static const String btn_logOut = 'Log Out';
  static const String btn_stay = 'Stay';
  static const String btn_continue = 'Continue';
  static const String btn_apply = 'Apply';
  static const String btn_addAthlete = 'Create Athlete';
  static const String btn_selectAthlete = 'Select Athlete';
  static const String btn_back = 'Back';
  static const String btn_accept = 'Accept';
  static const String btn_reject = 'Reject';
  static const String btn_remove = 'Remove';
  static const String btn_cancel = 'Cancel';
  static const String btn_goBack = 'Go Back';
  static const String btn_register = 'Register';
  static const String btn_checkout = 'Checkout';
  static const String btn_saveNcontinue = 'Save and Continue';
  static const String btn_save = 'Save';
  static const String btn_delete = 'Delete';
  static const String btn_decline = 'Decline';
  static const String btn_change_email = 'Change Email';
  static const String btn_submit = 'Submit';
  static const String btn_sendMessage = 'Send Message';
  static const String btn_edit = 'Edit';
  static const String btn_yes = 'Yes';
  static const String btn_no = 'No';
  static const String btn_explore = "Let's Explore";
  static const String btn_request = "Request";
  static const String btn_purchase = "Purchase";
  static const String btn_previous = "Previous";
  static const String btn_next = "Next";
  static const String btn_ok = "Ok";
  static const String btn_startIt = 'Start It!';
  static const String btn_scanAgain = "Scan Again";
  static const String btn_add = "Add";
  static const String btn_leave = "Leave";
  static const String btn_buy = "Buy";
  static const String btn_viewMore = "View More";
  static const String btn_visit = "Visit";
  static const String btn_update = "Update";
  static const String btn_verify = "Verify";
  static const String btn_keepIt = "Keep It";
  static const String btn_changeWC = "Change Weight";
  static const String btn_changeTeam = "Change Team";
  static const String btn_addCard = "Add Card";
  static const String btn_camera = "Camera";
  static const String btn_gallery = "Gallery";
  static const String btn_skip = "Skip";
  static const String btn_confirmSelection = "Confirm Selection";
  static const String btn_confirm = "Confirm";
  static const String btn_deleteAccount = "Delete Account";
  static const String btn_deleteAthlete = "Delete Athlete";
  static const String btn_viewEvent = "View Event";
  static const String btn_later = "Later";
  static const String btn_thanks = "Thanks!";

  //Radio label
  static const String radio_genderMale = 'Male';
  static const String radio_genderFemale = 'Female';
  static const String radio_viewAccess = 'View Access';
  static const String radio_coachAccess = 'Coach Access';
  static const String radio_ownerAccess = 'Ownership Access';

  //Checkboxes
  static const String checkbox_agreeAsParentOrGuardian_label =
      'I am parent/guardian.';

  //Bottom sheets
  static const String bottomSheet_logout_title = 'Do You Want To Log Out?';
  static const String bottomSheet_selectStyle_title = 'Select Style';
  static const String bottomSheet_eventRegistrationBreakdown_subtitle =
      "Here is the full breakdown of registrations for this event.";
  static const String bottomSheet_uploadProfilePicture_title =
      'Upload Profile Picture';
  static const String bottomSheet_uploadProfilePicture_subtitle =
      'Please, upload a profile picture from camera or gallery';
  static const String bottomSheet_selectWeightClasses_title =
      'Select Weight Classes';
  static const String bottomSheet_selectTiers_title =
      "Select a pass that you would like to purchase for this athlete.\nYou can only buy one pass per athlete.\nEach pass has different benefits.";

  static const String bottomSheet_addAthlete_title =
      'Do You Want To Add An Athlete?';
  static const String bottomSheet_addAthlete_subtitle =
      'You can also add an athlete later in your profile settings.';
  static const String bottomSheet_successfulRegistrationStatus_title_firstLine =
      'You Have Successfully Joined';
  static const String
      bottomSheet_successfulRegistrationStatus_title_secondLine = 'RMN Events';
  static const String bottomSheet_successfulRegistrationStatus_subtitle =
      "Congratulations! Your account has been successfully created. Let's start the journey.";
  static const String bottomSheet_athleteViewerEmptyList_bodyText =
      'There are no viewers for this athlete yet.';
  static const String bottomSheet_athleteCoachesEmptyList_bodyText =
      'There are no coaches for this athlete yet.';
  static const String bottomSheet_athleteViewerList_title = 'Viewers Of ';
  static const String bottomSheet_athleteViewerList_subtitle =
      'Here are the viewers of your profile';
  static const String bottomSheet_athleteCoachList_title = 'Coaches Of ';
  static const String bottomSheet_athleteCoachesList_subtitle =
      'Here are the coaches of your profile';
  static const String bottomSheet_athleteViewerRemoval_title =
      'Are You Sure You Want To Remove The Viewer?';
  static const String bottomSheet_athleteCoachRemoval_title =
      'Are You Sure You Want To Remove The Coach?';
  static const String
      bottomSheet_athletePartialOwnerRemoval_predecessor_subtitle =
      'If you remove the access, ';
  static const String bottomSheet_delete_chat_title = 'Are You Sure?';
  static const String bottomSheet_delete_chat_subTitle =
      'All messages will be deleted for parmanent.';

  static String bottomSheet_athletePartialOwnerRemoval_successor_subtitle(
          bool isViewer) =>
      isViewer
          ? ' will lose the ability to view '
          : ' will lose the ability to coach ';
  static const String bottomSheet_closedRegistration_title =
      'Registration Is Closed';
  static const String bottomSheet_closedRegistration_subtitle =
      'Unfortunately, registration for this event is currently not possible.\nThere may be various reasons for this, e.g. registration has not yet started, has already ended or is fully booked.\nIf you have any questions, please contact our support team.';
  static const String bottomSheet_externalRegistration_title = 'Registration';
  static const String bottomSheet_externalRegistration_subtitle =
      'The registration for this event will not take place here, but on another platform.\nYou will be redirected to another website to process the registration';
  static const String bottomSheet_athleteDelete_title =
      'Are You Sure Want To Delete Athlete Profile?';
  static const String bottomSheet_athleteDelete_subtitle =
      'You cannot recover this athlete once you delete the athlete profile';
  static const String bottomSheet_resetPassword_title = 'Password Changed';
  static const String bottomSheet_resetPassword_subtitle =
      'Your password has been changed successfully!';
  static const String bottomSheet_leaveRegistration_title =
      'You Want To Leave?';
  static const String bottomSheet_leaveRegistration_for_cancel_payment_title =
      'You want to cancel the payment?';
  static const String bottomSheet_leaveRegistration_subtitle =
      'All added data will be lost and you will have to enter it again.';
  static const String bottomSheet_leavePayment_subtitle =
      'The payment request on the S700 will be removed.';
  static const String bottomSheet_didNotFindTeam_title = 'Did not find team?';
  static const String bottomSheet_viewRight_title =
      'View rights will be granted to: ';
  static const String bottomSheet_coachRight_title =
      'Coach rights will be granted to: ';
  static const String bottomSheet_ownershipRight_title =
      'Ownership rights will be granted to: ';
  static const String bottomSheet_leaveWarning_title = 'You Want To Leave?';

  //Popup
  static const String popUp_dontShowThis_checkBox_text =
      "Don't show this again.";

  //dialogs
  static const String dialog_athleteWithNoTeamChange_title =
      "Team Can't Be Changed";

  static const String dialog_athleteWithNoTeamChange_preceding_subtitle =
      "The athlete has already been registered for the event with team ";
  static const String dialog_athleteWithNoTeamChange_following_subtitle =
      "\nEach athlete can only be registered for one team.\nIf you want to change this, you can change it in your purchase history.";

  static const String dialog_athleteDetail_event_title = "Registered Events";
  static const String dialog_athleteDetail_awards_title = "Awards Won";
  static const String dialog_athleteDetail_rank_title = "Ranking";
  static const String dialog_athleteDetail_event_subtitle =
      "This metric shows the number of registered events of this athlete for any event (past or upcoming) for the selected season.";
  static const String dialog_athleteDetail_awards_subtitle =
      "This metric shows the current/final ranking of the athlete for the selected season.";
  static const String dialog_athleteDetail_rank_subtitle =
      "This metric shows the total number of awards won for the selected season.";

  //QR
  static const String qrCode_popUp_product_title = 'PRODUCT DETAILS';
  static const String qrCode_popUp_registration_title = 'REGISTRATION DETAILS';
  static const String qrCode_popUp_product_status = 'Purchase';
  static const String qrCode_popUp_registration_status = 'Registration';
  static const String qrCode_popUp_subjectDetails_title = 'MORE DETAILS';
  static const String qrCode_popUp_itemScanner_prefix_text = 'Scanned by ';
  static const String qrCode_popUp_itemBuyer_prefix_text = 'Purchased by ';
  static const String qrCode_popUp_alreadyScanned_status = 'Already Scanned!';

  //Pos Settings
  static const String posSettings_title = 'S700 Device Settings';
  static const String posSettings_deviceSettings_title = 'Device Settings';
  static const String posSettings_unavailableDevice_text =
      'This S700 is already in use. Please make sure that no other device (mobile app) is connected to it, as only one device can be connected to an S700 at a time.';

  static const String deviceSettings_title = "S700 Device Settings";
  static const String qrCode_popUp_deletedUser = 'User has been removed';

  //Questionnaire

  static const String questionnaire_textformfield_hint =
      'Type your answer here...';
  static const String questionnaire_landingPage_title =
      'It takes just 1 minute.';
  static const String questionnaire_landingPage_subtitle =
      'Let’s Personalize Your Registration';
  static const String questionnaire_landingPage_des =
      "To make sure we offer the best experience for the athletes you're registering, we need to ask a few quick questions. Your answers will help us to offer you the best possible experience at the event.";
  static const String questionnaire_footer =
      '  Mandatory questions will need to be answered to proceed.';
  static const String questionnaire_radioList_info_title =
      'You can select 1 option';
  static const String questionnaire_checkBoxList_info_title =
      'You can select 1+ option';

  //Find customer
  static const String findCustomer_title = 'Find Customer';
  static const String findCustomer_search_noResults = 'No results found';
  static const String findCustomer_search_hint =
      'Search by e-mail, first or last name...';

  //Customer Purchases
  static const String customerPurchases_title = 'Customer Purchases';
  static const String customerPurchases_tab_all_title = 'All';
  static const String customerPurchases_tab_scanned_title = 'Scanned';
  static const String customerPurchases_tab_unscanned_title = 'Not Scanned';

  //Register & Sell
  static const String registerAndSell_title =
      'Register Athletes & Sell Products';
  static const String registerAndSell_form_title = 'Coach/Parent';
  static const String registerAndSell_selectDivision_title = 'Select Division';
  static const String registerAndSell_alreadyExistingAthlete_message =
      'Athlete with the same name already exists.';
  static const String registerAndSell_unsuccessfulPayment =
      'Payment unsuccessful. Please, try again.';

  //Selected Customer
  static const String selectedCustomer_readerAbsent_text =
      'Please, select a S700.';
  static const String eventDetail_products_giveAwayUnavailable_warning = 'You already purchased giveaway for all your registered athletes.';
}

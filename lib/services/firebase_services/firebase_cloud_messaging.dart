import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rmnevents/common/resources/app_routes.dart';
import 'package:rmnevents/data/models/arguments/chat_arguments.dart';
import 'package:rmnevents/presentation/base/bloc/base_bloc.dart';

import '../../common/resources/app_colors.dart';
import '../../presentation/notification/bloc/notification_bloc.dart';
import '../../root_app.dart';

// import 'package:template_flutter_mvvm_repo_bloc/presentation/notifications/bloc/notification_bloc.dart';
// import '../di/di.dart';
// import '../imports/common.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;

// THIS FUNCTION ASYNCHRONOUSLY RETRIEVES BOTH THE FCM AND APN TOKENS, INTRODUCING A SHORT DELAY BETWEEN THEM, AND RETURNS THE FCM TOKEN ONCE IT'S RETRIEVED.
retrieveFcmTokens() async {
  // THIS LINE ASYNCHRONOUSLY RETRIEVES THE FCM (Firebase Cloud Messaging)
  // TOKEN USING THE getToken METHOD OF THE messaging OBJECT.
  // THE AWAIT KEYWORD ENSURES THAT THE CODE WAITS FOR THE TOKEN
  // TO BE RETRIEVED BEFORE PROCEEDING. THE TOKEN IS STORED IN THE VARIABLE fcmToken,
  // WHICH IS DECLARED AS A NULLABLE STRING.
  String? fcmToken = await messaging.getToken();
  debugPrint("FCM Token: $fcmToken");

  // DELAY FOR 3 SECONDS BEFORE RETRIEVING APN TOKEN
  await Future.delayed(const Duration(seconds: 3));

// THIS LINE ASYNCHRONOUSLY RETRIEVES THE APN (Apple Push Notification) TOKEN
// USING THE getAPNSToken METHOD OF THE FirebaseMessaging.instance OBJECT.
// THE AWAIT KEYWORD ENSURES THAT THE CODE WAITS FOR THE APN TOKEN TO BE RETRIEVED BEFORE PROCEEDING.
// THE TOKEN IS STORED IN THE VARIABLE apnToken, WHICH IS DECLARED AS A NULLABLE STRING.

  return fcmToken;
}

getAPNToken() async {
  String? apnToken = await FirebaseMessaging.instance.getAPNSToken();
  debugPrint("APN Token: $apnToken");
}

class FirebaseCloudMessage {
  late FirebaseMessaging fcm;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late NotificationSettings settings;

  //The METHOD is RESPONSIBLE for INITIALIZING the
  // Flutter local notifications plugin WITH PLATFORM-SPECIFIC SETTINGS (Android and iOS)
  // and then CONFIGURING Firebase Cloud Messaging TO HANDLE NOTIFICATIONS in the app."
  Future setUpNotificationServiceForOS({required isCalledFromBg}) async {
    // THIS LINE INITIALIZES AN INSTANCE OF FLUTTER LOCAL NOTIFICATIONS PLUGIN, WHICH IS THE MAIN CLASS FOR MANAGING LOCAL NOTIFICATIONS IN FLUTTER.
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // THIS LINE INITIALIZES THE ANDROID-SPECIFIC SETTINGS FOR LOCAL NOTIFICATIONS. IT SPECIFIES THE LAUNCHER ICON TO BE USED FOR NOTIFICATIONS ON ANDROID DEVICES.
    var android = const AndroidInitializationSettings('app_launcher');
    // THIS LINE INITIALIZES THE iOS-SPECIFIC SETTINGS FOR LOCAL NOTIFICATIONS.
    // IT SPECIFIES PERMISSIONS REQUIRED FOR NOTIFICATIONS ON iOS DEVICES, SUCH AS SOUND, BADGE, AND ALERT PERMISSIONS.
    var ios = const DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,   // Shows banner
      badge: true,   // Updates app icon badge count
      sound: true, // Plays sound for the notification
    );

// THIS LINE CREATES AN INITIALIZATION SETTINGS OBJECT, WHICH ENCAPSULATES THE INITIALIZATION SETTINGS FOR BOTH ANDROID AND iOS PLATFORMS
    var initializationSetting = InitializationSettings(
      android: android,
      iOS: ios,
    );

// THIS LINE INITIALIZES THE FLUTTER LOCAL NOTIFICATIONS PLUGIN WITH THE PREVIOUSLY CREATED INITIALIZATION SETTINGS.
// IT WAITS FOR THE INITIALIZATION PROCESS TO COMPLETE BEFORE MOVING TO THE NEXT STEP.
    await flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: actionButtonCallBack,
    );

    if (!isCalledFromBg) {
      await configureFCM();
    }
  }

  // THIS FUNCTION IS THE CALLBACK FUNCTION FOR HANDLING NOTIFICATION ACTIONS.
  actionButtonCallBack(NotificationResponse notificationResponse) async {
    var payloadData = jsonDecode(notificationResponse.payload!);
    debugPrint("payload $payloadData");
    FlutterAppBadger.removeBadge();
    if (notificationResponse.actionId == "yes_action") {
      debugPrint("Yes action is clicked");
    } else {
      debugPrint("No action is clicked");
    }

    // YOU COULD NAVIGATE USER
    if (payloadData["notification_type"] == "event-message") {
      Navigator.pushNamed(navigatorKey.currentContext!, AppRouteNames.routeChat,
          arguments: ChatArguments(
              eventId: payloadData["ref_id"],
              roomId: payloadData["chat_room_id"]));
    } else if (payloadData["notification_type"] == "staff-event-message" || payloadData["notification_type"] == "general-message"){
        Navigator.pushNamed(navigatorKey.currentContext!, AppRouteNames.routeChat,
        arguments: ChatArguments(
          isFromPush: true,
        isForGeneralChat: true,
        eventId: payloadData["event_id"] ?? '',
        roomId: payloadData["chat_room_id"] ?? '', profileImage: payloadData["profile"] ?? '',recevierId: payloadData["sender_id"] ?? payloadData["chat_room_id"] ?? '',userName: payloadData['first_name'] + payloadData['last_name']));
    }else{
      Navigator.pushNamed(
        navigatorKey.currentContext!,
        AppRouteNames.routeNotification,
      );
    }

    // TO A SPECIFIC SCREEN BASED ON THE PAYLOAD DATA
    // YOU COULD CALL AN API TO UPDATE THE STATUS OF THE NOTIFICATION
  }

  // THIS FUNCTION SETS UP THE NOTIFICATION DETAILS FOR BOTH ANDROID AND iOS PLATFORMS,
  // GENERATES A UNIQUE NOTIFICATION ID,
  // DECODES THE PAYLOAD DATA, AND THEN DISPLAYS THE NOTIFICATION USING THE
  // flutterLocalNotificationsPlugin.show METHOD.
  Future showNotification(title, notification, payload) async {
/*Creating channel for notifications*/
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'rmn_channel', 'rmn_channel',
        description: 'This channel is used for RMN EVENTS',
        importance: Importance.high,
        showBadge: true,
        enableVibration: true,
        playSound: true);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    // THIS LINE CREATES AN ANDROID NOTIFICATION DETAILS OBJECT WHICH DEFINES
    // THE SPECIFIC DETAILS OF THE NOTIFICATION FOR ANDROID DEVICES.
    // THESE DETAILS INCLUDE
    // THE CHANNEL ID, CHANNEL NAME, DESCRIPTION, IMPORTANCE LEVEL, COLOR, PRIORITY,
    // AND OTHER PROPERTIES SUCH AS WHETHER TO PLAY SOUND, VIBRATE, OR ENABLE LIGHTS.
    var android = AndroidNotificationDetails(
      "rmn_channel",
      'rmn_channel',
      channelDescription: 'This channel is used for RMN EVENTS',
      importance: Importance.max,
      color: AppColors.colorPrimaryText,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      ticker: 'ticker',
      actions: const <AndroidNotificationAction>[
        // AndroidNotificationAction(
        //   'yes_action', // ID of the action
        //   'Yes', // Label of the action
        //   showsUserInterface: true,
        // ),
        // AndroidNotificationAction(
        //   'no_action', // ID of the action
        //   'No', // Label of the action
        //   showsUserInterface: true,
        // ),
      ],
    );

    // THIS LINE CREATES A DARWIN NOTIFICATION DETAILS OBJECT WHICH DEFINES THE SPECIFIC DETAILS
    // OF THE NOTIFICATION FOR iOS DEVICES.
    // THESE DETAILS INCLUDE WHETHER TO PRESENT AN ALERT, SOUND, BADGE, BANNER, AND LIST.

    var ios = const DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        presentBadge: true,
        presentBanner: true,
        presentList: true);

    // NOTIFICATION DETAILS OBJECT WHICH ENCAPSULATES
    // THE PLATFORM-SPECIFIC NOTIFICATION DETAILS DEFINED
    // FOR BOTH ANDROID AND iOS PLATFORMS.

    var platformSpecifics = NotificationDetails(
      android: android,
      iOS: ios,
    );

    // THIS LINE CREATES A RANDOM OBJECT TO GENERATE A UNIQUE NUMBER FOR THE NOTIFICATION ID.
    Random random = Random();
    // THIS LINE GENERATES A RANDOM INTEGER BETWEEN 0 AND 999 TO SERVE AS THE UNIQUE IDENTIFIER FOR THE NOTIFICATION.
    int uniqueNumber = random.nextInt(1000);
    debugPrint("object number is $uniqueNumber");

    // THIS LINE DECODES THE PAYLOAD PARAMETER (CONTAINING JSON DATA) USING THE jsonDecode FUNCTION.
    var load = jsonDecode(payload);
    debugPrint("payload is $load");

    // THIS LINE DISPLAYS THE NOTIFICATION USING THE SHOW METHOD OF THE
    // FLUTTER LOCAL NOTIFICATIONS PLUGIN OBJECT.
    // IT TAKES PARAMETERS SUCH AS THE UNIQUE NOTIFICATION ID,
    // TITLE, NOTIFICATION CONTENT, PLATFORM-SPECIFIC NOTIFICATION DETAILS,
    // AND OPTIONAL PAYLOAD DATA.




    if(Platform.isAndroid){
      await flutterLocalNotificationsPlugin.show(
          uniqueNumber, '$title', '$notification', platformSpecifics,
          payload: payload);
    }
  }

  Future<void> configureFCM() async {
    // THIS LINE INITIALIZES THE fcm VARIABLE WITH THE FIREBASE MESSAGING INSTANCE.
    // THIS INSTANCE IS USED TO INTERACT WITH FIREBASE CLOUD MESSAGING.
    fcm = FirebaseMessaging.instance;

    // THIS LINE REQUESTS PERMISSION FOR NOTIFICATIONS USING THE
    // requestPermission METHOD OF THE fcm OBJECT.
    // IT AWAITS THE RESULT OF THIS OPERATION TO
    // ENSURE THAT PERMISSION IS OBTAINED BEFORE PROCEEDING.

    settings = await fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // THIS LINE CHECKS IF THE APP IS RUNNING IN DEBUG MODE (kDebugMode)
    // AND PRINTS A DEBUG MESSAGE INDICATING THAT THE USER HAS GRANTED PERMISSION FOR NOTIFICATIONS.
    if (kDebugMode) {
      debugPrint('User granted permission');
    }

    // THIS LINE SETS UP A LISTENER FOR INCOMING MESSAGES USING THE
    // onMessage STREAM OF FirebaseMessaging.
    // WHEN A MESSAGE IS RECEIVED, THE PROVIDED CALLBACK FUNCTION IS EXECUTED.

    // THE CALLBACK FUNCTION IS THE ANONYMOUS FUNCTION PASSED AS AN ARGUMENT
    // TO THE LISTEN METHOD OF THE onMessage STREAM. IT IS EXECUTED EVERY TIME
    // A NEW MESSAGE IS RECEIVED.

    // THE CALLBACK FUNCTION PERFORMS THE FOLLOWING ACTIONS:

    // - PRINTS DEBUG MESSAGES INDICATING THE RECEIVED NOTIFICATION DETAILS, TOAST MESSAGE,
    //  AND REFERENCE ID FROM THE MESSAGE DATA.
    // - CALLS THE showNotification FUNCTION TO DISPLAY THE NOTIFICATION WITH THE TITLE,
    // BODY, AND DATA OF THE RECEIVED MESSAGE.


    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      String title = message.notification?.title ?? 'Title';
      String body = message.notification?.body ?? 'Description';

      String payload = jsonEncode(message.data);
     showNotification(title, body, payload);

      debugPrint('payload: $payload');
      debugPrint('onMessage: $body');
      if(message.data["notification_type"] != null) {
        BlocProvider.of<NotificationBloc>(navigatorKey.currentContext!).add(
            TriggerGetNotificationCount(
                messageType: message.data["notification_type"]));
      }

      BlocProvider.of<BaseBloc>(navigatorKey.currentContext!).add(
          TriggergetUnreadCount());
    });

    // THIS LINE SETS UP A LISTENER FOR BACKGROUND MESSAGES USING THE
    // onBackgroundMessage METHOD OF FirebaseMessaging. IT SPECIFIES THE
    // firebaseMessagingBackgroundHandler FUNCTION TO HANDLE BACKGROUND MESSAGES.

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // THIS LINE SETS UP A LISTENER FOR MESSAGES
    // THAT ARE RECEIVED WHEN THE APP IS OPENED FROM THE BACKGROUND STATE.
    // IT USES THE onMessageOpenedApp STREAM OF FirebaseMessaging. WHEN SUCH A MESSAGE IS RECEIVED, THE PROVIDED CALLBACK FUNCTION IS EXECUTED.

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // Handle incoming data message when the app is in the background or terminated
      // Extract data and perform custom actions
      debugPrint("onMessageOpenedApp1st ${message.toMap()}");
      debugPrint("onMessageOpenedApp2nd notification value is ${message.data}");
      var notificationType = message.data["notification_type"];
      if (notificationType == "staff-event-message" || notificationType == "general-message") {
        print("Navigating to Chat with event_id: ${message.data['event_id']}");
        Navigator.pushNamed(
          navigatorKey.currentContext!,
          AppRouteNames.routeChat,
          arguments: ChatArguments(
            isForGeneralChat: true,
            eventId: message.data["event_id"] ?? '',
            roomId: message.data["chat_room_id"] ?? '',
            profileImage: message.data["profile"] ?? '',
            recevierId: message.data["sender_id"] ?? message.data["chat_room_id"] ?? '',
            userName: '${ message.data['first_name'] ?? ''} ${ message.data['last_name'] ?? ''}',
            isFromPush: true
          ),
        );
      }

    });
  }
}

// THIS IS A PRAGMA DIRECTIVE USED TO INDICATE TO THE
// DART VM THAT THIS FUNCTION SHOULD BE TREATED AS AN ENTRY POINT.
// ENTRY POINTS ARE FUNCTIONS THAT THE DART VM CAN INVOKE DIRECTLY.
// IN THIS CASE, THE FUNCTION IS MARKED AS AN ENTRY POINT
// BECAUSE IT IS INTENDED TO BE INVOKED BY THE DART VM WHEN HANDLING BACKGROUND MESSAGES.
@pragma('vm:entry-point')
// THIS IS THE FUNCTION DEFINITION.
// IT TAKES A SINGLE PARAMETER MESSAGE OF TYPE RemoteMessage,
// WHICH REPRESENTS THE MESSAGE RECEIVED IN THE BACKGROUND.
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  String title = message.notification?.title ?? 'Title';
  String body = message.notification?.body ?? 'Description';

  String payload = jsonEncode(message.data);

  FirebaseCloudMessage firebaseCloudMessage = FirebaseCloudMessage();

  await firebaseCloudMessage.setUpNotificationServiceForOS(
      isCalledFromBg: true);

  await Firebase.initializeApp();
  //await firebaseCloudMessage.showNotification(title, body, payload);

  if (navigatorKey.currentContext != null) {
    BlocProvider.of<NotificationBloc>(navigatorKey.currentContext!).add(
        TriggerGetNotificationCount(
            messageType: message.data["notification_type"]));
  }
  return;

  // debugPrint('Handling a background message ${message.messageId}');
  // THIS LINE INITIALIZES FIREBASE SERVICES ASYNCHRONOUSLY USING THE Firebase.initializeApp() METHOD.
  // IT ENSURES THAT FIREBASE SERVICES ARE PROPERLY INITIALIZED
  // BEFORE ANY OTHER FIREBASE-RELATED OPERATIONS
  // ARE PERFORMED IN THE BACKGROUND MESSAGE HANDLER FUNCTION.
}

//firebaseMessagingBackgroundHandler IS RESPONSIBLE FOR HANDLING BACKGROUND MESSAGES
// RECEIVED BY FIREBASE CLOUD MESSAGING, ENSURING THAT FIREBASE
// SERVICES ARE INITIALIZED BEFORE PROCESSING THE MESSAGE.
// IT IS MARKED AS AN ENTRY POINT TO BE INVOKED
// BY THE DART VM WHEN HANDLING BACKGROUND MESSAGES.

/*
 For customizing background notification with action buttons,notification param must be encapsulated with data:
 {
  "registration_ids": [
      "cTLD7FKRQBmsqBO_2_M0fM:APA91bHToKZa-68YfQBQm25stEQ9jeybJqs2Y-HJ_EKZ8R8Q52ExC7siCdDLFcI4Tqsr01Ln3Kf4jdvz7lXl6jLWZiLkLzEsvF5UWUxzMXoA3vHJfkZiqmKiuwGSQxDL3EQG17jKZzT9"
  ],

  "data":{
    "notification": {
    "title": "hello",
    "body": "world"

  }
  },

    "priority":"high"
}


use POST https://fcm.googleapis.com/fcm/send in postman to send the notification
 */

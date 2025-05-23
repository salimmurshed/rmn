import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rmnevents/data/repository/grade_repository.dart';
import 'package:rmnevents/data/repository/transaction_fee_repository.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rmnevents/presentation/chat/bloc/chat_bloc.dart';
import 'package:rmnevents/presentation/home/client_home_bloc/client_home_bloc.dart';
import 'package:rmnevents/presentation/register_and_sell/bloc/register_and_sell_bloc.dart';
import 'package:rmnevents/root_app.dart';

import '../../../app_configurations/app_environments.dart';
import '../../../data/models/arguments/chat_arguments.dart';
import '../../../data/models/response_models/admin_avialibility_response_model.dart';
import '../../../data/models/response_models/received_chat_response_model.dart';
import '../../../data/models/response_models/season_passes_response_model.dart';
import '../../../data/remote_data_source/socket_data_source.dart';
import '../../../di/di.dart';
import '../../../imports/common.dart';
import '../../../imports/data.dart';
import '../../../imports/services.dart';
import '../../athlete_details/bloc/athlete_details_bloc.dart';
import '../../home/staff_home_bloc/staff_home_bloc.dart';
import '../../pos_settings/bloc/pos_settings_bloc.dart';
import '../../profile/bloc/profile_handlers.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../staff_chat/event_general_view/bloc/staff_chat_bloc.dart';
import '../../staff_chat/user_chat_list/bloc/user_chat_list_bloc.dart';
part 'base_event.dart';

part 'base_state.dart';

part 'base_bloc.freezed.dart';

IO.Socket? socket;

class BaseBloc extends Bloc<BaseEvent, BaseWithInitialState> {
  var currentRoute = ModalRoute.of(navigatorKey.currentContext!)?.settings.name;
  initSocket(bool isEmployee)async {
    if (isEmployee){
      DataBaseUser user = await GlobalHandlers.extractUserHandler();
      socket = IO.io(
          "${AppEnvironments.socketUrl}?token=${user.token}",
          <String, dynamic>{
            'autoConnect': false,
            'transports': ['websocket'],
          });
      socket?.connect();
      socket?.onConnect((_) {
        debugPrint('Connection established');
        socket?.emit('joinRoom', {"room_id": 'admin-global'});
      });
      socket?.on('connect_error', (data) => debugPrint('-------$data'));

      socket?.on(
          'newMessageForStaff',
              (data)  {
            List<ReceivedChatResponseModel> receivedMessages = [];
            List<Chats> extractedChat = [];
            ReceivedChatResponseModel messageReceived =
            ReceivedChatResponseModel.fromJson(data);
            receivedMessages.add(messageReceived);
            List<String>chatIds =[];
            for (ReceivedChatResponseModel message in receivedMessages) {
              if(!chatIds.contains(message.messageData!.id)){
                chatIds.add(message.messageData!.id!);
                extractedChat.add(message.messageData!);
                print(message.messageData?.createdAt ?? '');
                BlocProvider.of<StaffChatBloc>(navigatorKey.currentContext!).add(TriggerUpdateEventListOnMessage(message: message.messageData!));
                if (message.messageData?.eventId == null){
                  BlocProvider.of<UserChatListBloc>(navigatorKey.currentContext!).add(TriggerUpdateEventListOnMessageForGeneral(message: message.messageData!));
                }else{
                  BlocProvider.of<UserChatListBloc>(navigatorKey.currentContext!).add(TriggerUpdateEventListOnMessageForEvent(message: message.messageData!));
                }
               bool isInsideChatView = navigatorKey.currentContext!.read<ChatBloc>().state.isInsideChatView;
               String rooomId = navigatorKey.currentContext!.read<ChatBloc>().state.roomId;
                if(isInsideChatView){
                  if(extractedChat.last.roomId == rooomId)
                  BlocProvider.of<ChatBloc>(navigatorKey.currentContext!).add(TriggerReceiveMessage(
                      receivedMessages: extractedChat, isFromGeneralChat: true));
                }
              }
            }
          }
      );
    }else{
      DataBaseUser user = await GlobalHandlers.extractUserHandler();
      socket = IO.io(
          "${AppEnvironments.socketUrl}/event-chat?token=${user.token}",
          <String, dynamic>{
            'autoConnect': false,
            'transports': ['websocket'],
          });
      socket?.connect();
      socket?.onConnect((_) {
        debugPrint('Connection established');
      });
      socket?.on(
        'newMessage',
            (data) {
          List<ReceivedChatResponseModel> receivedMessages = [];
          List<Chats> extractedChat = [];
          ReceivedChatResponseModel messageReceived =
          ReceivedChatResponseModel.fromJson(data);
          receivedMessages.add(messageReceived);
          List<String> chatIds = [];
          for (ReceivedChatResponseModel message in receivedMessages) {
            if (!chatIds.contains(message.messageData!.id)) {
              chatIds.add(message.messageData!.id!);
              extractedChat.add(message.messageData!);
            }
          }
          BlocProvider.of<ChatBloc>(navigatorKey.currentContext!).add(TriggerReceiveMessage(receivedMessages: extractedChat));
        },
      );
      socket?.on(
        'userOnlineStatus',
            (data) {
          print('user statue $data');
          AdminAvialibilityResponseModel value = AdminAvialibilityResponseModel.fromJson(data);
          BlocProvider.of<BaseBloc>(navigatorKey.currentContext!).add(TriggerISSupportAgentAvialable(isAvailable: value.isOnline ?? false));

        },
      );
    }


    socket?.onDisconnect((_) => debugPrint('Connection Disconnection'));
    socket?.onConnectError((err) => debugPrint('error in chat connection $err'));
    socket?.onError((err) => debugPrint('error in chat $err'));
    socket?.onPing((err) => debugPrint('show err $err'));
  }



  UserCachedData userCachedData = instance<UserCachedData>();
  BaseBloc() : super(BaseWithInitialState.initial()) {
    on<TriggerViewNumberUpdates>(_onTriggerViewNumberUpdates);
    on<TriggerTeamsFetch>(_onTriggerTeamsFetch);
    on<TriggerSeasonsFetch>(_onTriggerSeasonsFetch);
    on<TriggerFetchCurrentSeason>(_onTriggerFetchCurrentSeason);
    on<TriggerFetchBaseData>(_onTriggerFetchBaseData);
    on<TriggerMyAthletesFetch>(_onTriggerMyAthletesFetch);
    on<TriggerTransactionFeeFetch>(_onTriggerTransactionFeeFetch);
    on<TriggerSwitchBetweenRoles>(_onTriggerSwitchBetweenRoles);
    on<TriggerGradeFetch>(_onTriggerGradeFetch);
    on<TriggergetUnreadCount>(_onTriggerFetchUnreadCount);
    on<TriggerGetIntialMessage>(_onTriggergetIntialMessage);
    on<TriggerISSupportAgentAvialable>(_onTriggerIsSupoortAgentAvailable);
  }


  Future<void> _onTriggergetIntialMessage(
      TriggerGetIntialMessage event, Emitter<BaseWithInitialState> emit) async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      var notificationType = initialMessage.data["notification_type"];

      if (notificationType == "staff-event-message" ||
          notificationType == "general-message") {
        print("Navigating to Chat with event_id: ${initialMessage.data['event_id']}");

        Future.delayed(const Duration(milliseconds: 500), () {
          // Delay ensures navigator is available
          if (navigatorKey.currentContext != null) {
            Navigator.pushNamed(
              navigatorKey.currentContext!,
              AppRouteNames.routeChat,
              arguments: ChatArguments(
                isForGeneralChat: true,
                eventId: initialMessage.data["event_id"] ?? '',
                roomId: initialMessage.data["chat_room_id"] ?? '',
                profileImage: initialMessage.data["profile"] ?? '',
                recevierId: initialMessage.data["sender_id"] ?? '',
                userName:
                (initialMessage.data['first_name'] ?? '') + " " + (initialMessage.data['last_name'] ?? ''),
              ),
            );
          } else {
            print("Navigator context is not available yet");
          }
        });
      }else{
        emit(state.copyWith(isLoading: false));
      }
    }
  }
  FutureOr<void> _onTriggerViewNumberUpdates(
      TriggerViewNumberUpdates event, Emitter<BaseWithInitialState> emit) {
    emit(state.copyWith(
      isRefreshedRequired: true,
    ));
    emit(state.copyWith(
        isRefreshedRequired: false, viewNumber: event.viewNumber));
  }

  FutureOr<void> _onTriggerTeamsFetch(
      TriggerTeamsFetch event, Emitter<BaseWithInitialState> emit) async {
    emit(state.copyWith(
        isLoading: true,
        isFailure: false,
        isFetchingTeams: true,
        message: AppStrings.global_empty_string));
    try {
      final response = await TeamsRepository.getTeams();
      response.fold(
          (failure) => emit(state.copyWith(
              isLoading: false,
              isFailure: true,
              isFetchingTeams: false,
              message: failure.message)), (success) {
        List<Team> team = success.responseData!.data!;

        team.insert(1, Team(id: '0', name: "No Team"));
        emit(
          state.copyWith(
              isLoading: false,
              isFetchingTeams: false,
              isFailure: false,
              teams: team),
        );
      });
    } catch (e) {
      emit(state.copyWith(
          isLoading: false,
          isFailure: true,
          isFetchingTeams: false,
          message: e.toString()));
    }
  }

  FutureOr<void> _onTriggerSeasonsFetch(
      TriggerSeasonsFetch event, Emitter<BaseWithInitialState> emit) async {
    emit(state.copyWith(
        isFailure: false,
        isFetchingSeasons: true,
        message: AppStrings.global_empty_string));
    try {
      final response = await SeasonRepository.getSeasons();
      response.fold(
          (failure) => emit(state.copyWith(
              isLoading: false,
              isFailure: true,
              isFetchingSeasons: false,
              message: failure.message)), (success) {
        List<SeasonPass> seasons = success.responseData!.data!;

        emit(
          state.copyWith(
              isLoading: false,
              isFetchingSeasons: false,
              isFailure: false,
              seasons: seasons),
        );
        globalSeasons = seasons;
        BlocProvider.of<AthleteDetailsBloc>(navigatorKey.currentContext!).add(TriggerAthleteDetailsFetch(
            seasons: globalSeasons,
            athleteId: event.athleteId,
            seasonId: AppStrings.global_empty_string));
      });
    } catch (e) {
      emit(state.copyWith(
          isLoading: false,
          isFailure: true,
          isFetchingSeasons: false,
          message: e.toString()));
    }
  }

  FutureOr<void> _onTriggerFetchBaseData(
      TriggerFetchBaseData event, Emitter<BaseWithInitialState> emit) async {
    emit(BaseWithInitialState.initial());
    String id = await userCachedData.getUserId() ?? '';
    debugPrint('id $id');
    retrieveFcmTokens();
   if(kReleaseMode){
      await messaging.subscribeToTopic(id);
   }

    await FirebaseCloudMessage()
        .setUpNotificationServiceForOS(isCalledFromBg: false);
    initSocket(event.currentRole != AppStrings.global_role_user);
    if (event.isFromRestart) {
      currentRole = event.currentRole;
    } else {
      DataBaseUser user = await GlobalHandlers.extractUserHandler();
      currentRole = user.currentRole!;
    }

    if(currentRole != UserTypes.user.name){
      BlocProvider.of<StaffHomeBloc>(navigatorKey.currentContext!)
          .add(TriggerCheckOnAppRestart());
    }
    emit(state.copyWith(
        isFailure: false,
        isRefreshedRequired: false,
        isLoadingForTheFirstTime: false,
        isLoading: false,
        currentRole: currentRole,
        message: AppStrings.global_empty_string));
    if(currentRole != UserTypes.user.name){
      SocketDataSource.connectWithSocket();
      BlocProvider.of<StaffHomeBloc>(navigatorKey.currentContext!)
          .add(TriggerRefreshHome());
      BlocProvider.of<PosSettingsBloc>(navigatorKey.currentContext!)
          .add(TriggerRefreshPosSettings());
     BlocProvider.of<RegisterAndSellBloc>(navigatorKey.currentContext!)
          .add(TriggerRefreshRegistrationAndSellForm());
    }
    add(TriggerTeamsFetch());

    add(TriggerFetchCurrentSeason());
    add(TriggerTransactionFeeFetch());
    add(TriggerGradeFetch());
    BlocProvider.of<ClientHomeBloc>(navigatorKey.currentContext!)
        .add(TriggerCleanHomeData());
  }

  FutureOr<void> _onTriggerTransactionFeeFetch(TriggerTransactionFeeFetch event,
      Emitter<BaseWithInitialState> emit) async {
    emit(state.copyWith(
        isFailure: false, message: AppStrings.global_empty_string));
    try {
      final response = await TransactionFeeRepository.getTransactionFee();
      response.fold(
          (failure) => emit(state.copyWith(
              isLoading: false,
              isFailure: true,
              message: failure.message)), (success) {
        emit(
          state.copyWith(
            isLoading: false,
            transactionFee: success.responseData!.data!.transactionFees!,
            isFailure: false,
          ),
        );
      });
    } catch (e) {
      emit(state.copyWith(
          isLoading: false,
          isFailure: true,
          isFetchingSeasons: false,
          message: e.toString()));
    }
  }

  FutureOr<void> _onTriggerFetchCurrentSeason(TriggerFetchCurrentSeason event,
      Emitter<BaseWithInitialState> emit) async {
    emit(state.copyWith(
        isFetchingCurrentSeason: true,
        isFailure: false,
        message: AppStrings.global_empty_string));

    try {
      final response = await CurrentSeasonRepository.getCurrentSeason();
      response.fold(
          (failure) => emit(state.copyWith(
              isLoading: false,
              isFailure: true,
              isFetchingCurrentSeason: false,
              message: failure.message)), (success) {
        emit(
          state.copyWith(
              isLoading: false,
              isFetchingCurrentSeason: false,
              isFailure: false,
              currentSeason: success.responseData!.data!),
        );
      });
    } catch (e) {
      emit(state.copyWith(
          isLoading: false,
          isFailure: true,
          isFetchingCurrentSeason: false,
          message: e.toString()));
    }
  }

  FutureOr<void> _onTriggerMyAthletesFetch(
      TriggerMyAthletesFetch event, Emitter<BaseWithInitialState> emit) {}

  FutureOr<void> _onTriggerSwitchBetweenRoles(TriggerSwitchBetweenRoles event,
      Emitter<BaseWithInitialState> emit) async {
    add(TriggergetUnreadCount());
    emit(state.copyWith(
        isRefreshedRequired: true,
        isFailure: false,
        message: AppStrings.global_empty_string));
    UserCachedData userCachedData = instance<UserCachedData>();
    DataBaseUser user = await GlobalHandlers.extractUserHandler();
    switch (user.currentRole!) {
      case AppStrings.global_role_owner:
        initSocket(true);
        user.currentRole = UserTypes.user.name;
        instance<UserCachedData>().setCurrentRole(role: user.currentRole!);
        break;
      case AppStrings.global_role_admin:
        initSocket(true);
        user.currentRole = UserTypes.user.name;
        instance<UserCachedData>().setCurrentRole(role: user.currentRole!);
        break;
      case AppStrings.global_role_employee:
        initSocket(true);
        user.currentRole = UserTypes.user.name;
        instance<UserCachedData>().setCurrentRole(role: user.currentRole!);
        break;
      case AppStrings.global_role_user:
        initSocket(false);
        user.currentRole =
            AccountSettingsHandlers.switchToHighestRole(user.roles!);
        instance<UserCachedData>().setCurrentRole(role: user.currentRole!);
        BlocProvider.of<StaffHomeBloc>(navigatorKey.currentContext!)
            .add(TriggerCheckOnAppRestart());
        break;
    }

    emit(state.copyWith(
      isFailure: false,
      isRefreshedRequired: false,
      currentRole: user.currentRole!,
      message: AppStrings.global_empty_string,
    ));
    if(currentRole != UserTypes.owner.name){
      SocketDataSource.connectWithSocket();
    }else{
      SocketDataSource.disconnectSocket();
    }


    await userCachedData
        .removeSharedPreferencesGeneralFunction(UserKeyManager.userInfo);
    await userCachedData.setUserInfo(jsonEncodedValue: jsonEncode(user));
  }

  FutureOr<void> _onTriggerGradeFetch(
      TriggerGradeFetch event, Emitter<BaseWithInitialState> emit) async {
    try {
      final response = await GradeRepository.getGrades();
      response.fold(
          (failure) => emit(state.copyWith(
              isLoading: false,
              isFailure: true,
              isFetchingCurrentSeason: false,
              message: failure.message)), (success) async {
        emit(
          state.copyWith(
              isLoading: false,
              isFetchingCurrentSeason: false,
              isFailure: false,
              gradeList: success.responseData?.data ?? []),
        );
        add(TriggergetUnreadCount());
      });
    } catch (e) {
      emit(state.copyWith(
          isLoading: false,
          isFailure: true,
          isFetchingCurrentSeason: false,
          message: e.toString()));
    }
  }

  FutureOr<void> _onTriggerFetchUnreadCount(
      TriggergetUnreadCount event, Emitter<BaseWithInitialState> emit) async {
    try {
      DataBaseUser user = await GlobalHandlers.extractUserHandler();
      if (user.roles!.contains('admin') || user.roles!.contains('employee') || user.roles!.contains('owner')){
        final response = await GradeRepository.getUnreadCount();
        response.fold(
                (failure) => emit(state.copyWith(
                isLoading: false,
                isFailure: true,
                isFetchingCurrentSeason: false,
                message: failure.message)), (success) {
          emit(
            state.copyWith(isLoading: false, unreadCount: success.responseData?.unreadCount ?? 0),
          );
        });
      }else{
        emit(state.copyWith(
            isLoading: false,
            isFailure: true,
            isFetchingCurrentSeason: false,
            message: AppStrings.global_empty_string));
      }
    } catch (e) {
      emit(state.copyWith(
          isLoading: false,
          isFailure: true,
          isFetchingCurrentSeason: false,
          message: e.toString()));
    }
  }

  FutureOr<void> _onTriggerIsSupoortAgentAvailable(TriggerISSupportAgentAvialable event, Emitter<BaseWithInitialState> emit) {
    print('---------------------------><----------------------------');
    emit(state.copyWith(isFailure: false, isLoading: true));
    emit(state.copyWith(isFailure: false, isLoading: false, isSupportAgentAvilable: event.isAvailable));
    bool isInsideChatView = navigatorKey.currentContext!.read<ChatBloc>().state.isInsideChatView;
    if(isInsideChatView){
      BlocProvider.of<ChatBloc>(navigatorKey.currentContext!).add(TirggerAgentAvialibility(isAvailable: event.isAvailable));
    }
  }
}

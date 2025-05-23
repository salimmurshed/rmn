import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rmnevents/data/repository/contact_support_data_source.dart';

import '../../../imports/common.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../imports/data.dart';
import 'my_athletes_handler.dart';

part 'my_athletes_event.dart';

part 'my_athletes_state.dart';

part 'my_athletes_bloc.freezed.dart';

class MyAthletesBloc extends Bloc<MyAthletesEvent, MyAthletesWithInitialState> {
  int calledPage = 0;

  MyAthletesBloc() : super(MyAthletesWithInitialState.initial()) {
    on<TriggerFetchAthletes>(_onTriggerFetchAthletes);
    on<TriggerCheckForSearchText>(_onTriggerCheckForSearchText);
    on<TriggerRequestAccess>(_onTriggerRequestAccess);
    on<TriggerCancel>(_onTriggerCancel);
    on<TriggerAskForSupport>(_onTriggerAskForSupport);
    on<TriggerCheckForRequests>(_onTriggerCheckForRequests);
    on<TriggerAcceptOReject>(_onTriggerAcceptOrReject);
    on<TriggerRadioButtonValue>(_onTriggerRadioButtonValue);
    on<TriggerCleanScreen>(_onTriggerCleanScreen);
    on<TriggerSearchInLocal>(_onTriggerSearchInLocal);
    on<TriggerRequestAthleteSupport>(_onTriggerRequestAthleteSupport);
    on<TriggerUpdateScrollControllerPosition>(
        _onTriggerUpdateScrollControllerPosition);
  }

  FutureOr<void> _onTriggerFetchAthletes(TriggerFetchAthletes event,
      Emitter<MyAthletesWithInitialState> emit) async {
    if (state.isFetching) return;
    emit(state.copyWith(
      isFetching: true,
      selectedTabNumber: event.selectedTabIndex,
      message: AppStrings.global_empty_string,
    ));

    if (event.isNewTab == AthleteApiCallType.newTab) {
      if (event.isSearch) {
        emit(state.copyWith(
          showSearchIcon: false,
          athletes: [],
          isLoading: true,
          currentScrollController: ScrollController(),
          message: AppStrings.global_empty_string,
        ));
      } else {
        emit(state.copyWith(
          showSearchIcon: true,
          isLoading: true,
          athletes: [],
          searchFocusNode: FocusNode(),
          searchController: TextEditingController(),
          currentScrollController: ScrollController(),
          message: AppStrings.global_empty_string,
        ));
      }
      // if (event.selectedTabIndex == 0 || event.selectedTabIndex == 1) {
      //   emit(state.copyWith(
      //     athletes: [],
      //     isLoading: true,
      //     selectedTabNumber: event.selectedTabIndex,
      //   ));
      // }
      // else {
      //   if (event.isRequestClearTime) {
      //     emit(state.copyWith(
      //       athletes: [],
      //       isLoading: true,
      //       selectedTabNumber: event.selectedTabIndex,
      //     ));
      //   }
      // }
    }
    else if (event.isNewTab == AthleteApiCallType.notificationCall) {
      emit(state.copyWith(
        showSearchIcon: true,
        message: AppStrings.global_empty_string,
      ));
    }
    else {
      emit(state.copyWith(
          message: AppStrings.global_empty_string,
          isBottomLoading: true,
          isLoading: false,
          isRefreshRequired: false));
    }
    if (event.selectedTabIndex == 1) {
      state.currentScrollController.addListener(() {
        if (state.currentScrollController.position.pixels >
                state.currentScrollController.position.maxScrollExtent &&
            state.totalPage > state.page &&
            !state.isFetching) {
          add(TriggerFetchAthletes(
              athletes: state.athletes,
              searchKey: state.searchController.text,
              isSearch: state.isSearch,
              selectedTabIndex: state.selectedTabNumber,
              page: state.page + 1,
              isNewTab: AthleteApiCallType.none));
        }
      });
    }
    try {
      Either<Failure, AthleteResponseModel>? response;
      Either<Failure, AllAthletesResponseModel>? responseForFindTab;
      Either<Failure, ReceivedAthleteRequestModelResponse>?
          responseForAthleteRequests;
      switch (event.selectedTabIndex) {
        case 0:
          response = await AthleteRepository.getAthletesOrSearchAthletes(
              searchKey: event.searchKey,
              athleteApiType: AthleteApiType.myAthletes,
              page: event.page);
          break;
        case 1:
          responseForFindTab = await AthleteRepository.getAllOrSearchAthletes(
              searchKey: event.searchKey,
              athleteApiType: event.isSearch
                  ? AthleteApiType.findAthletes
                  : AthleteApiType.allAthletes,
              page: event.page);
          break;
        case 2:
          responseForAthleteRequests =
              await AthleteRepository.getReceivedRequests(
                  page: event.page, searchKey: event.searchKey);
          break;
      }
      if (event.selectedTabIndex == 0) {
        fetchMyAthletes(response, emit, event);
      } else if (event.selectedTabIndex == 2) {
        fetchRequestForAthletes(responseForAthleteRequests, emit, event);
      } else {
        fetchAllAthletesOrSearchAthletes(responseForFindTab, emit, event);
      }
    } catch (e) {
      emit(state.copyWith(
          isFailure: true,
          isRefreshRequired: false,
          isBottomLoading: false,
          message: e.toString(),
          isLoading: false));
    } finally {
      emit(state.copyWith(
          message: AppStrings.global_empty_string,
          isFailure: false,
          isFetching: false));
    }
  }

  void fetchRequestForAthletes(
      Either<Failure, ReceivedAthleteRequestModelResponse>?
          responseForAthleteRequests,
      Emitter<MyAthletesWithInitialState> emit,
      TriggerFetchAthletes event) {
    responseForAthleteRequests!.fold((failure) {
      emit(state.copyWith(
          isFailure: true,
          isFetching: false,
          isRefreshRequired: false,
          isBottomLoading: false,
          message: failure.message,
          isLoading: false));
    }, (success) {
      List<Athlete> athletes = [];
      for (ReceivedAthleteRequestData requests
          in success.responseData?.data ?? []) {
        athletes.add(Athlete(
          underscoreId: requests.athleteId,
          id: requests.athleteId,
          firstName: requests.firstName,
          lastName: requests.lastName,
          profileImage:
              success.responseData!.assetsUrl! + requests.profileImage!,
          age: requests.age,
          birthDate: requests.birthDate,
          noUpcomningEvents: requests.noUpcomningEvents,
          rankReceived: requests.rankReceived,
          awards: requests.awards,
          weightClass: requests.weightClass,
          membership: requests.membership,
          accessType: requests.accessType,
          senderName: requests.senderName,
          requestData: RequestData(
            id: requests.id,
            athleteId: requests.athleteId,
            accessType: requests.accessType,
            senderName: requests.senderName,
          ),
        ));
      }

      if (event.isRequestClearTime || event.isSearch) {
        emit(state.copyWith(
            athletes: athletes,
            requests: success.responseData?.data ?? [],
            message: AppStrings.global_empty_string,
            textForEmptyList: event.isSearch
                ? AppStrings.myAthletes_emptySearchList_text
                : AppStrings.myAthletes_requestsTab_emptyAthleteList_text,
            showFooterButton: false,
            isRefreshRequired: false,
            isBottomLoading: false,
            isFetching: false,
            selectedTabNumber: event.isNotification
                ? state.selectedTabNumber
                : event.selectedTabIndex,
            isSearch: event.isSearch,
            isLoading: false,
            isFailure: false));
      } else {
        emit(state.copyWith(
            message: AppStrings.global_empty_string,
            textForEmptyList: event.isSearch
                ? AppStrings.myAthletes_emptySearchList_text
                : AppStrings.myAthletes_requestsTab_emptyAthleteList_text,
            showFooterButton: false,
            requests: success.responseData?.data ?? [],
            isRefreshRequired: false,
            isBottomLoading: false,
            isSearch: event.isSearch,
            selectedTabNumber: event.isNotification
                ? state.selectedTabNumber
                : event.selectedTabIndex,
            isLoading: false,
            isFailure: false));
      }
    });
  }

  void fetchAllAthletesOrSearchAthletes(
      Either<Failure, AllAthletesResponseModel>? responseForFindTab,
      Emitter<MyAthletesWithInitialState> emit,
      TriggerFetchAthletes event) {
    responseForFindTab!.fold((failure) {
      emit(state.copyWith(
          isFailure: true,
          isFetching: false,
          isRefreshRequired: false,
          message: failure.message,
          isBottomLoading: false,
          isLoading: false));
    }, (success) {
      List<Athlete> athletes = success.responseData?.data ?? [];
      if (athletes.isNotEmpty) {
        for (var athlete in athletes) {
          athlete.profileImage =
              success.responseData!.assetsUrl! + athlete.profileImage!;
        }
      }
      List<Athlete> athletesScrolled = [];
      if (event.isSearch) {
        athletesScrolled = athletes;
      } else {
        athletesScrolled = [...state.athletes, ...athletes];
      }
      emit(state.copyWith(
          athletes: athletesScrolled,
          message: AppStrings.global_empty_string,
          page: int.parse(success.responseData!.page.toString()),
          textForEmptyList: event.isSearch
              ? AppStrings.myAthletes_emptySearchList_text
              : AppStrings.global_empty_string,
          isRefreshRequired: false,
          isSearch: event.isSearch,
          isLoading: false,
          isFetching: false,
          isBottomLoading: false,
          showFooterButton: false,
          totalPage: int.parse(success.responseData!.totalPage.toString()),
          isFailure: false));
    });
    // if (event.isNewTab == AthleteApiCallType.none) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     state.currentScrollController.animateTo(
    //       state.currentScrollController.position.maxScrollExtent,
    //       duration: const Duration(milliseconds: 100),
    //       // Adjust duration as needed
    //       curve: Curves.easeInOut, // Adjust curve as needed
    //     );
    //   });
    // }
  }

  void fetchMyAthletes(Either<Failure, AthleteResponseModel>? response,
      Emitter<MyAthletesWithInitialState> emit, TriggerFetchAthletes event) {
    response!.fold((failure) {
      emit(state.copyWith(
          isFailure: true,
          isFetching: false,
          isRefreshRequired: false,
          message: failure.message,
          isLoading: false));
    }, (success) {
      List<Athlete> athletes = success.responseData?.data ?? [];
      if (athletes.isNotEmpty) {
        for (var athlete in athletes) {
          athlete.profileImage =
              success.responseData!.assetsUrl! + athlete.profileImage!;
        }
      }
      emit(state.copyWith(
          athletes: athletes,
          isFetching: false,
          textForEmptyList: event.isSearch
              ? AppStrings.myAthletes_emptySearchList_text
              : athletes.isEmpty && event.selectedTabIndex == 0
                  ? AppStrings.myAthletes_myAthletesTab_emptyAthleteList_text
                  : athletes.isEmpty && event.selectedTabIndex == 2
                      ? AppStrings.myAthletes_requestsTab_emptyAthleteList_text
                      : AppStrings.global_empty_string,
          message: AppStrings.global_empty_string,
          isRefreshRequired: false,
          isLoading: false,
          showFooterButton: (event.selectedTabIndex == 0 && !event.isSearch),
          isSearch: event.isSearch,
          isFailure: false));
      if(event.isInitState) {
        add(TriggerCheckForRequests());
      }
    });
  }

  FutureOr<void> _onTriggerRequestAccess(TriggerRequestAccess event,
      Emitter<MyAthletesWithInitialState> emit) async {
    MyAthletesHandler.emitWithLoader(emit: emit, state: state);
    double position = event.scrollController.offset;
    String accessType = state.radioButtonValue == '1'
        ? '0'
        : state.radioButtonValue == '2'
            ? '1'
            : '2';
    try {
      final response = await AthleteRepository.sendRequestForAthlete(
          accessType: accessType, athleteId: event.athleteId);
      response.fold((failure) {
        emit(state.copyWith(
            isFailure: true,
            isRefreshRequired: false,
            message: failure.message,
            scrollerPosition: position,
            radioButtonValue: '1',
            isLoading: false));
      }, (success) {
        List<Athlete> athletes = event.athletes;
        athletes[event.index].requestData = RequestData(
            id: success.responseData!.data!.id,
            athleteId: success.responseData!.data!.athleteId,
            createdAt: success.responseData!.data!.createdAt != null
                ? DateTime.parse(success.responseData!.data!.createdAt!)
                : null,
            userId: success.responseData!.data!.userId,
            isAccept: success.responseData!.data!.isAccept,
            isAccess: success.responseData!.data!.isAccess,
            isSupportRequested: success.responseData!.data!.isSupportRequested!,
            accessType: success.responseData!.data!.accessType == null
                ? null
                : int.parse(
                    success.responseData!.data!.accessType!.toString()));

        emit(state.copyWith(
            athletes: athletes,
            isFailure: false,
            isRefreshRequired: false,
            scrollerPosition: position,
            radioButtonValue: '1',
            message: success.responseData!.message!,
            isLoading: false));
      });
    } catch (e) {
      emit(state.copyWith(
          isLoading: false,
          isFailure: true,
          scrollerPosition: position,
          radioButtonValue: '1',
          message: e.toString()));
    }
  }

  FutureOr<void> _onTriggerAskForSupport(
      TriggerAskForSupport event, Emitter<MyAthletesWithInitialState> emit) {}

  FutureOr<void> _onTriggerCancel(
      TriggerCancel event, Emitter<MyAthletesWithInitialState> emit) async {
    MyAthletesHandler.emitWithLoader(emit: emit, state: state);
    double position = event.scrollController.offset;
    try {
      final response = await AthleteRepository.cancelSentRequestForAthlete(
          athleteId: event.athleteId);
      response.fold((failure) {
        emit(state.copyWith(
            isFailure: true,
            scrollerPosition: position,
            isRefreshRequired: false,
            message: failure.message,
            isLoading: false));
      }, (success) {
        List<Athlete> athletes = event.athletes;
        athletes[event.index].requestData = null;
        emit(state.copyWith(
            athletes: athletes,
            isFailure: false,
            scrollerPosition: position,
            isRefreshRequired: false,
            message: success.responseData!.message!,
            isLoading: false));
      });
    } catch (e) {
      emit(state.copyWith(
          isFailure: true,
          isRefreshRequired: false,
          scrollerPosition: position,
          message: e.toString(),
          isLoading: false));
    }
  }

  FutureOr<void> _onTriggerAcceptOrReject(TriggerAcceptOReject event,
      Emitter<MyAthletesWithInitialState> emit) async {
    MyAthletesHandler.emitWithLoader(emit: emit, state: state);
    double position = event.scrollController.offset;
    try {
      final response = await AthleteRepository.acceptReject(
          requestId: event.requestId, isAccepted: event.isAccepted);
      response.fold((failure) {
        emit(state.copyWith(
            isFailure: true,
            scrollerPosition: position,
            isRefreshRequired: false,
            message: failure.message,
            isLoading: false));
      }, (success) {
        List<Athlete> athletes = List.from(event.athletes);
        athletes.removeAt(event.index);
        List<ReceivedAthleteRequestData> requests = List.from(state.requests);
        requests.removeWhere((element) => element.id == event.requestId);
        emit(state.copyWith(
            isFailure: false,
            isRefreshRequired: false,
            scrollerPosition: position,
            athletes: athletes,
            requests: requests,
            message: success.responseData!.message!,
            isLoading: false));
      });
    } catch (e) {
      emit(state.copyWith(
          isFailure: true,
          isRefreshRequired: false,
          scrollerPosition: position,
          message: e.toString(),
          isLoading: false));
    }
  }

  FutureOr<void> _onTriggerRadioButtonValue(
      TriggerRadioButtonValue event, Emitter<MyAthletesWithInitialState> emit) {
    MyAthletesHandler.emitInitialState(emit: emit, state: state);

    emit(state.copyWith(
        isRefreshRequired: false, radioButtonValue: event.value));
  }

  FutureOr<void> _onTriggerUpdateScrollControllerPosition(
      TriggerUpdateScrollControllerPosition event,
      Emitter<MyAthletesWithInitialState> emit) {
    MyAthletesHandler.emitInitialState(emit: emit, state: state);
    emit(state.copyWith(
        isRefreshRequired: false,
        scrollerPosition: event.scrollController.offset));
  }

  FutureOr<void> _onTriggerCheckForSearchText(TriggerCheckForSearchText event,
      Emitter<MyAthletesWithInitialState> emit) {
    MyAthletesHandler.emitInitialState(emit: emit, state: state);
    emit(state.copyWith(
        isRefreshRequired: false, showSearchIcon: event.searchText.isNotEmpty));
  }

  FutureOr<void> _onTriggerCheckForRequests(TriggerCheckForRequests event,
      Emitter<MyAthletesWithInitialState> emit) async {
    MyAthletesHandler.emitWithLoader(emit: emit, state: state);
    try {
      final responseForAthleteRequests =
          await AthleteRepository.getReceivedRequests(
              page: 1, searchKey: AppStrings.global_empty_string);
      responseForAthleteRequests.fold((failure) {
        emit(state.copyWith(
            isFailure: true, isRefreshRequired: false, isLoading: false));
      }, (success) {
        emit(state.copyWith(
            isFailure: true,
            isRefreshRequired: false,
            selectedTabNumber: 0,
            requests: success.responseData?.data ?? [],
            isLoading: false));
      });
    } catch (e) {
      emit(state.copyWith(
          isFailure: true, isRefreshRequired: false, isLoading: false));
    }
  }

  FutureOr<void> _onTriggerCleanScreen(
      TriggerCleanScreen event, Emitter<MyAthletesWithInitialState> emit) {
    emit(MyAthletesWithInitialState.initial());
  }

  FutureOr<void> _onTriggerSearchInLocal(
      TriggerSearchInLocal event, Emitter<MyAthletesWithInitialState> emit) {
    emit(state.copyWith(
      showSearchIcon: false,
      isLoading: true,
      currentScrollController: ScrollController(),
      message: AppStrings.global_empty_string,
    ));
    bool isFound = state.athletes.any((element) =>
        element.firstName!
            .toLowerCase()
            .contains(state.searchController.text.toLowerCase()) ||
        element.lastName!
            .toLowerCase()
            .contains(state.searchController.text.toLowerCase()));
    if (isFound) {
      List<Athlete> athletes = state.athletes
          .where((element) =>
              element.firstName!
                  .toLowerCase()
                  .contains(state.searchController.text.toLowerCase()) ||
              element.lastName!
                  .toLowerCase()
                  .contains(state.searchController.text.toLowerCase()))
          .toList();

      emit(state.copyWith(
        athletes: athletes,
        isLoading: false,
        message: AppStrings.global_empty_string,
      ));
    }else{
      emit(state.copyWith(
        athletes: [],
        isLoading: false,
        message: AppStrings.myAthletes_emptySearchList_text,
      ));
    }
  }

  FutureOr<void> _onTriggerRequestAthleteSupport(TriggerRequestAthleteSupport event, Emitter<MyAthletesWithInitialState> emit) async {
    MyAthletesHandler.emitWithLoader(emit: emit, state: state);
    try{
      final response = await ContactSupportRepository.askContactSupport(athleteId: event.athleteId);
      response.fold((failure) => emit(state.copyWith(
        message: failure.message,
        isLoading: false,
        isRefreshRequired: false,
        isFailure: true,

      )), (success) => emit(state.copyWith(
        message: success.responseData!.message!,
        isLoading: false,
        isRefreshRequired: false,
        isFailure: false,
      )));
    }catch(e){
      emit(state.copyWith(
          isFailure: true,
          isRefreshRequired: false,
          message: e.toString(),
          isLoading: false));
    }
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rmnevents/data/repository/questionnaire_repository.dart';
import '../../../data/models/request_models/event_purchase_request_model.dart';
import '../../../data/models/response_models/questionnaire_response_model.dart';
import '../../../imports/common.dart';
import '../../../root_app.dart';

part 'questionnaire_event.dart';

part 'questionnaire_bloc.freezed.dart';

part 'questionnaire_state.dart';

class QuestionnaireBloc extends Bloc<QuestionnaireEvent, QuestionnaireState> {
  QuestionnaireBloc() : super(QuestionnaireState.initial()) {
    on<TriggerQuestionnaireFetch>(_onTriggerQuestionnaireFetch);
    on<TriggerNextQuestion>(_onTriggerNextQuestion);
    on<TriggerResetQuestionnaire>(_onTriggerResetQuestionnaire);
    on<TriggerChooseAnswers>(_onTriggerChooseAnswers);
    on<TriggerCheckFreeText>(_onTriggerCheckFreeText);
    on<TriggerPreviousQuestion>(_onTriggerPreviousQuestion);
    on<TriggerSubmitQuestionnaire>(_onTriggerSubmitQuestionnaire);
  }

  FutureOr<void> _onTriggerQuestionnaireFetch(
      TriggerQuestionnaireFetch event, Emitter<QuestionnaireState> emit) async {
    emit(QuestionnaireState.initial());
    try {
      final response = await QuestionnaireRepository.getQuestionnaire(
          eventId: event.eventId);
      response.fold((failure) {
        emit(state.copyWith(isLoading: false));
      }, (success) {
        bool canProceedToRegister = success.responseData!.data!.isEmpty;
        if(!canProceedToRegister){
          for (int i = 0; i < success.responseData!.data!.length; i++) {
            if (success.responseData!.data![i].answerType! ==
                QuestionnaireType.free_text.name) {
              success.responseData!.data![i].storedAnswer = Questionnaire(
                formKey: GlobalKey<FormState>(),
                  questionId: success.responseData!.data![i].id,
                  answer: '',
                  focusNode: FocusNode(),
                  textEditingController: TextEditingController());
            }
            if (success.responseData!.data![i].answerType! ==
                QuestionnaireType.single_choice.name) {
              success.responseData!.data![i].storedAnswer = Questionnaire(
                  questionId: success.responseData!.data![i].id,
                  answer: '',
                  radioValue: AppStrings.global_empty_string);
            }
            if (success.responseData!.data![i].answerType! ==
                QuestionnaireType.multi_choice.name) {
              success.responseData!.data![i].storedAnswer = Questionnaire(
                  questionId: success.responseData!.data![i].id,
                  answer: '',
                  checkBoxValues: []);
            }
          }
        }

        emit(state.copyWith(
          isLoading: false,
          canProceedToRegister: canProceedToRegister,
          questions: success.responseData?.data ?? [],
          isFirstPage: true,
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
      ));
    }
  }

  FutureOr<void> _onTriggerNextQuestion(
      TriggerNextQuestion event, Emitter<QuestionnaireState> emit) {
    int currentIndex = state.currentIndex + 1 < state.questions.length
        ? state.currentIndex + 1
        : state.currentIndex;
    bool isNextActive = isNextActiveChecker(questionData: state.questions[currentIndex]);

    emit(state.copyWith(
      currentIndex: currentIndex,
      isLastPage: currentIndex == state.questions.length - 1,
    ));
    emit(state.copyWith(
      isFirstPage: false,
      isRefreshed: true,
    ));
    List<int> completedQuestions = List.from(state.completedQuestions);
    completedQuestions.add(currentIndex);

    emit(state.copyWith(
        isNextActive: isNextActive,
        completedQuestions: completedQuestions,
        isRefreshed: false));
  }

  FutureOr<void> _onTriggerChooseAnswers(
      TriggerChooseAnswers event, Emitter<QuestionnaireState> emit) {
    emit(state.copyWith(
      isRefreshed: true,
    ));
    bool isNextActive = !state.questions[state.currentIndex].isMandatory!;

    Questionnaire questionnaire =
        state.questions[state.currentIndex].storedAnswer!;
    List<String> answers = state.questions[state.currentIndex].options!;
    if (event.isSingleChoice) {
      questionnaire.radioValue = answers[event.i];
      debugPrint('radio value: ${questionnaire.radioValue}');
      if(!isNextActive){
        isNextActive = questionnaire.radioValue!.isNotEmpty;
      }
    }
    else {
      if (questionnaire.checkBoxValues!.contains(answers[event.i])) {
        questionnaire.checkBoxValues!.remove(answers[event.i]);
      } else {
        questionnaire.checkBoxValues!.add(answers[event.i]);
      }
      if(!isNextActive){
        isNextActive = questionnaire.checkBoxValues!.isNotEmpty;
      }
      debugPrint('checkbox values: ${questionnaire.checkBoxValues}');
    }

    emit(state.copyWith(
      isRefreshed: false,
      isNextActive: isNextActive,
    ));
  }

  FutureOr<void> _onTriggerCheckFreeText(TriggerCheckFreeText event, Emitter<QuestionnaireState> emit) {
    emit(state.copyWith(
      isRefreshed: true,
    ));
    bool isNextActive = !state.questions[state.currentIndex].isMandatory!;
    if(!isNextActive){
      isNextActive = event.answer.isNotEmpty;
    }
    emit(state.copyWith(
      isRefreshed: false,
      isNextActive: isNextActive,
    ));
  }

  FutureOr<void> _onTriggerPreviousQuestion(TriggerPreviousQuestion event, Emitter<QuestionnaireState> emit) {
    emit(state.copyWith(
      isRefreshed: true,
    ));
    List<int> completedQuestions = List.from(state.completedQuestions);

    if(completedQuestions.contains(state.currentIndex)){
      completedQuestions.remove(state.currentIndex);
    }
    int currentIndex = state.currentIndex  >= 0
        ? state.currentIndex - 1
        : state.currentIndex;

    bool isNextActive = isNextActiveChecker(questionData: state.questions[currentIndex]);
    debugPrint('current index: $currentIndex');
    emit(state.copyWith(
      isRefreshed: false,
      currentIndex: currentIndex,
      isNextActive:isNextActive ,
      completedQuestions: completedQuestions,
      isLastPage: currentIndex == state.questions.length - 1,
      isFirstPage: currentIndex == -1,
    ));

  }

  FutureOr<void> _onTriggerSubmitQuestionnaire(TriggerSubmitQuestionnaire event, Emitter<QuestionnaireState> emit) {
    emit(state.copyWith(
      isRefreshed: true,
    ));
    for(int i = 0; i < state.questions.length; i++){
      if(state.questions[i].answerType == QuestionnaireType.free_text.name){
        state.questions[i].storedAnswer!.answer = state.questions[i].storedAnswer!.textEditingController!.text;
      }
      if(state.questions[i].answerType == QuestionnaireType.single_choice.name){
        state.questions[i].storedAnswer!.answer = state.questions[i].storedAnswer!.radioValue!;
      }
      if(state.questions[i].answerType == QuestionnaireType.multi_choice.name){
        state.questions[i].storedAnswer!.answer = state.questions[i].storedAnswer!.checkBoxValues!.join(',');
      }
    }
    List<Questionnaire> storedAnswers = state.questions.map((e) => e.storedAnswer!).toList();
    emit(state.copyWith(
      isRefreshed: false,
      storedAnswers: storedAnswers,
      canProceedToRegister: true
    ));
    Navigator.pop(navigatorKey.currentContext!);
  }

  FutureOr<void> _onTriggerResetQuestionnaire(TriggerResetQuestionnaire event, Emitter<QuestionnaireState> emit) {
    emit(state.copyWith(
      isRefreshed: true,
    ));
    emit(state.copyWith(
      isRefreshed: false,
      currentIndex: 0,
      completedQuestions: [0],
      isLastPage: false,
      isFirstPage: false,
      canProceedToRegister: false
    ));
  }
}
isNextActiveChecker({required QuestionnaireData questionData}){
  bool isMandatory = questionData.isMandatory!;
  bool isNextActive = true;
  if(isMandatory){
    if (questionData.answerType ==
        QuestionnaireType.free_text.name) {
      isNextActive = questionData.storedAnswer!.textEditingController!
              .text.isNotEmpty;
    }
    if (questionData.answerType ==
        QuestionnaireType.single_choice.name) {
      isNextActive =
          questionData.storedAnswer!.radioValue!.isNotEmpty;
    }
    if (questionData.answerType ==
        QuestionnaireType.multi_choice.name) {
      isNextActive = questionData.storedAnswer!.checkBoxValues!
          .isNotEmpty;
    }
  }
  else{
    isNextActive = true;
  }
  return isNextActive;
}
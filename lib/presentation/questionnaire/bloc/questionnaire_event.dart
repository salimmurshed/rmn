part of 'questionnaire_bloc.dart';

@immutable
sealed class QuestionnaireEvent extends Equatable {
  const QuestionnaireEvent();

  @override
  List<Object?> get props => [];
}

class TriggerQuestionnaireFetch extends QuestionnaireEvent {
  final String eventId;

  const TriggerQuestionnaireFetch({required this.eventId});

  @override
  List<Object?> get props => [eventId];
}

class TriggerNextQuestion extends QuestionnaireEvent {}
class TriggerResetQuestionnaire extends QuestionnaireEvent {}

class TriggerChooseAnswers extends QuestionnaireEvent {
  final int i;
  final bool isSingleChoice;

  const TriggerChooseAnswers({required this.i, required this.isSingleChoice});

  @override
  List<Object?> get props => [i, isSingleChoice];
}

class TriggerPreviousQuestion extends QuestionnaireEvent {}

class TriggerSubmitQuestionnaire extends QuestionnaireEvent {}

class TriggerCheckFreeText extends QuestionnaireEvent {
  final String answer;

  const TriggerCheckFreeText({required this.answer});

  @override
  List<Object?> get props => [answer];
}

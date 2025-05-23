part of 'questionnaire_bloc.dart';


@freezed
class QuestionnaireState with _$QuestionnaireState {
  const factory QuestionnaireState({
    required List<QuestionnaireData> questions,
    required bool isLoading,
    required bool isRefreshed,
    required List<int> completedQuestions,
    required List<Questionnaire> storedAnswers,
    required List<TextEditingController> textEditingControllers,
    required List<FocusNode> focusNodes,
    required int currentIndex,
    required bool canProceedToRegister,
    required bool isFirstPage,
    required bool isNextActive,
    required bool isLastPage,
    required GlobalKey<FormState> formKey,
  }) = _QuestionnaireState;

  factory QuestionnaireState.initial() =>
        QuestionnaireState(
        isLoading: true,
        isRefreshed: false,
        formKey: GlobalKey<FormState>(),
        canProceedToRegister: false,
        focusNodes: [],
        textEditingControllers: [],
        storedAnswers: [],
        questions: [],
        completedQuestions: [],
        isLastPage: false,
        currentIndex: -1,
        isFirstPage: true,
        isNextActive: false,
      );
}

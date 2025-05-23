import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rmnevents/presentation/questionnaire/bloc/questionnaire_bloc.dart';

import '../../../imports/common.dart';

class QuestionnaireView extends StatefulWidget {
  const QuestionnaireView({super.key, });



  @override
  State<QuestionnaireView> createState() => _QuestionnaireViewState();
}

class _QuestionnaireViewState extends State<QuestionnaireView> {
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestionnaireBloc, QuestionnaireState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              dividerTheme: DividerTheme.of(context).copyWith(
                color: Colors.transparent,
              ),
            ),
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                extendBody: true,
                persistentFooterButtons: [
                  if (state.isFirstPage)
                    buildCustomLargeFooterBtn(
                        onTap: () {
                          BlocProvider.of<QuestionnaireBloc>(context)
                              .add(TriggerNextQuestion());
                        },
                        btnLabel: AppStrings.btn_startIt,
                        hasKeyBoardOpened: true,
                        isColorFilledButton: true),
                  if (!state.isFirstPage)
                    buildTwinButtons(
                        onLeftTap: () {

                          if(state.currentIndex == 0){
                            Navigator.pop(context);
                          }else{
                            BlocProvider.of<QuestionnaireBloc>(context)
                                .add(TriggerPreviousQuestion());
                          }
                        },
                        onRightTap: state.isNextActive
                            ? () {
                          if(state.isLastPage){
                            BlocProvider.of<QuestionnaireBloc>(context)
                                .add(TriggerSubmitQuestionnaire());
                          }
                              else{
                            BlocProvider.of<QuestionnaireBloc>(context)
                                .add(TriggerNextQuestion());
                          }
                              }
                            : () {},
                        leftBtnLabel: AppStrings.btn_previous,
                        rightBtnLabel: state.isLastPage
                            ? AppStrings.btn_submit
                            :
                        AppStrings.btn_next,
                        isActive: state.isNextActive)
                ],
                backgroundColor: AppColors.colorPrimary,
                body: Stack(
                  fit: StackFit.expand,
                  children: [
                    SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: Image.asset(AppAssets.imgQuestionnaire,
                          fit: BoxFit.cover),
                    ),

                    const BackButtonForImageStack(),
                    if(!state.isFirstPage)
                    QuestionIndicator(
                      state: state,
                    ),
                    QuestionContent(
                      state: state,
                    )
                  ],
                )),
          ),
        );
      },
    );
  }
}

class QuestionContent extends StatelessWidget {
  const QuestionContent({
    super.key,
    required this.state,
  });

  final QuestionnaireState state;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top:  Dimensions.getScreenHeight() * (state.isFirstPage? 0.18: 0.2),
        left: 0,
        right: 0,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              Text(AppStrings.questionnaire_landingPage_title,
                  style: AppTextStyles.subtitle(
                      color: AppColors.colorPrimaryNeutral,
                      fontWeight: FontWeight.w500)),
              SizedBox(
                height: Dimensions.getScreenHeight() * 0.7,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Text(
                        state.isFirstPage
                            ? AppStrings.questionnaire_landingPage_subtitle
                            : state.questions[state.currentIndex].question!,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        textWidthBasis: TextWidthBasis.longestLine,
                        style: AppTextStyles.landingTitle(
                            fontSize: 28.sp, fontWeight: FontWeight.w400)),
                    SizedBox(height: 16.h),
                    if (state.isFirstPage) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                             AppStrings.questionnaire_landingPage_des,
                              textAlign: TextAlign.left,
                              style: AppTextStyles.normalNeutral(
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '(',
                            textAlign: TextAlign.left,
                            style: AppTextStyles.normalPrimary(
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '*',
                            textAlign: TextAlign.left,
                            style: AppTextStyles.normalPrimary(
                                color: AppColors.colorPrimaryAccent,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            ')',
                            textAlign: TextAlign.left,
                            style: AppTextStyles.normalPrimary(
                                fontWeight: FontWeight.w500),
                          ),
                          Expanded(
                            child: Text(
                              AppStrings.questionnaire_footer,
                              textAlign: TextAlign.left,
                              style: AppTextStyles.normalPrimary(
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      )
                    ] else ...[
                      if (state.questions[state.currentIndex].answerType!
                              .toLowerCase() ==
                          QuestionnaireType.free_text.name)
                        CustomTextFormFields(
                          key: state.formKey,
                          formKey: state.questions[state.currentIndex]
                              .storedAnswer!.formKey!,
                          focusNode: state.questions[state.currentIndex]
                              .storedAnswer!.focusNode!,
                          textEditingController: state
                              .questions[state.currentIndex]
                              .storedAnswer!
                              .textEditingController!,
                          label: AppStrings.global_empty_string,
                          onChanged: (value) {
                            BlocProvider.of<QuestionnaireBloc>(context)
                                .add(TriggerCheckFreeText(answer: value,));
                          },
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 10.w),
                          isAsteriskPresent: false,
                          hint: AppStrings.questionnaire_textformfield_hint,
                          maxLength: 250,
                          validator: (value) {
                            return value!.isEmpty
                                ? AppStrings
                                    .textfield_emptyField_error
                                : null;
                          },
                          textInputType: TextInputType.multiline,
                        ),
                      if (state.questions[state.currentIndex].answerType!
                              .toLowerCase() ==
                          QuestionnaireType.single_choice.name)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: AppColors.colorPrimaryNeutral,
                                  size: 14.sp,
                                ),
                                SizedBox(width: 5.w),
                                Text(AppStrings.questionnaire_radioList_info_title,
                                    style: AppTextStyles
                                        .regularNeutralOrAccented()),
                              ],
                            ),
                            for (int i = 0;
                                i <
                                    state.questions[state.currentIndex].options!
                                        .length;
                                i++)
                              GestureDetector(
                                onTap: () {
                                  BlocProvider.of<QuestionnaireBloc>(context)
                                      .add(TriggerChooseAnswers(
                                          i: i, isSingleChoice: true));
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 40.h,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  margin: EdgeInsets.symmetric(vertical: 3.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    color: AppColors.colorTertiary,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      Text(
                                          state.questions[state.currentIndex]
                                              .options![i],
                                          style: AppTextStyles.smallTitle()),
                                      const Spacer(),
                                      Radio(
                                        visualDensity: VisualDensity.compact,
                                        value: state
                                            .questions[state.currentIndex].options![i],
                                        groupValue: state
                                            .questions[state.currentIndex]
                                            .storedAnswer!
                                            .radioValue,
                                        activeColor:
                                            AppColors.colorPrimaryAccent,
                                        fillColor: AppWidgetStyles
                                            .radioButtonFillColor(),
                                        focusColor:
                                            AppColors.colorPrimaryAccent,
                                        onChanged: (value) {
                                          BlocProvider.of<QuestionnaireBloc>(
                                                  context)
                                              .add(TriggerChooseAnswers(
                                                  i: i, isSingleChoice: true));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      if (state.questions[state.currentIndex].answerType!
                              .toLowerCase() ==
                          QuestionnaireType.multi_choice.name)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: AppColors.colorPrimaryNeutral,
                                  size: 14.sp,
                                ),
                                SizedBox(width: 5.w),
                                Text(AppStrings.questionnaire_checkBoxList_info_title,
                                    style: AppTextStyles
                                        .regularNeutralOrAccented()),
                              ],
                            ),
                            for (int i = 0;
                                i <
                                    state.questions[state.currentIndex].options!
                                        .length;
                                i++)
                              GestureDetector(
                                onTap: () {
                                  BlocProvider.of<QuestionnaireBloc>(context)
                                      .add(TriggerChooseAnswers(
                                          i: i, isSingleChoice: false));
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 40.h,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  margin: EdgeInsets.symmetric(vertical: 3.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    color: AppColors.colorTertiary,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      Text(
                                          state.questions[state.currentIndex]
                                              .options![i],
                                          style: AppTextStyles.smallTitle()),
                                      const Spacer(),
                                      buildCustomCheckbox(
                                        isChecked: state
                                            .questions[state.currentIndex]
                                            .storedAnswer!
                                            .checkBoxValues!
                                            .contains(state
                                                .questions[state.currentIndex]
                                                .options![i]),
                                        isSmall: true,
                                        isDisabled: false,
                                        onChanged: (value) {
                                          BlocProvider.of<QuestionnaireBloc>(
                                                  context)
                                              .add(TriggerChooseAnswers(
                                                  i: i, isSingleChoice: false));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class QuestionIndicator extends StatelessWidget {
  const QuestionIndicator({
    super.key,
    required this.state,
  });

  final QuestionnaireState state;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: Dimensions.getScreenHeight() * 0.15,
        left: 0,
        right: 0,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            children: [
              for (int i = 0; i < state.questions.length; i++)
                Expanded(
                  child: Container(
                    height: 5.h,
                    margin: EdgeInsets.symmetric(horizontal: 5.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: state.completedQuestions.contains(i)
                            ? AppColors.colorPrimaryAccent
                            : AppColors.colorDisabled),
                  ),
                ),
            ],
          ),
        ));
  }
}

class BackButtonForImageStack extends StatelessWidget {
  const BackButtonForImageStack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: Dimensions.getScreenHeight() * 0.05,
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
         Navigator.pop(context);
        },
        child: Container(
          width: 45.w,
          height: 42.h,
          margin: EdgeInsets.only(
            left: Dimensions.appBarToolHorizontalGap,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.appBarToolRadius),
            color: AppColors.colorSecondary,
          ),
          child: Center(
            child: SvgPicture.asset(
                height: 18.h, AppAssets.icAppbarBackButton, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}

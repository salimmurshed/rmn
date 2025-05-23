import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/presentation/get_in_touch/bloc/get_in_touch_bloc.dart';
import '../../../imports/common.dart';

class GetInTouchFaqView extends StatefulWidget {
  const GetInTouchFaqView({super.key});

  @override
  State<GetInTouchFaqView> createState() => _GetInTouchFaqViewState();
}

class _GetInTouchFaqViewState extends State<GetInTouchFaqView> {
  @override
  void initState() {
    BlocProvider.of<GetInTouchBloc>(context).add(TriggerFaqFetch());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetInTouchBloc, GetInTouchWithInitial>(
      builder: (context, state) {
        return customScaffold(
            hasForm: false,
            customAppBar: CustomAppBar(
                title: AppStrings.getInTouch_faq_title, isLeadingPresent: true),
            formOrColumnInsideSingleChildScrollView: null,
            anyWidgetWithoutSingleChildScrollView: state.isLoading? CustomLoader(child: buildFaqLayout(state),):
            buildFaqLayout(state));
      },
    );
  }

  ListView buildFaqLayout(GetInTouchWithInitial state) {
    return ListView.separated(
              itemBuilder: (context, index) {
                return customRegularExpansionTile(
                    isParent: false,
                    isNumZero: true,

                    title: '${state.faqData[index].question}',
                    onExpansionChanged: (value) {},
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.screenHorizontalGap),
                        child: buildHtmlWidget(
                            text: state.faqData[index].answer ??
                                AppStrings.global_empty_string),
                      )
                    ],
                    isExpansionTileOpened: false,
                    leading: SizedBox(width: 12.w),
                    isBackDropDarker: false);
              },
              separatorBuilder: (context, index) =>
                  SizedBox(height: Dimensions.generalGap),
              itemCount: state.faqData.length);
  }
}

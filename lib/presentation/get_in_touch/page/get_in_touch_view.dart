import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rmnevents/presentation/get_in_touch/bloc/get_in_touch_bloc.dart';

import '../../../imports/common.dart';

class GetInTouchView extends StatefulWidget {
  const GetInTouchView({super.key});

  @override
  State<GetInTouchView> createState() => _GetInTouchViewState();
}

class _GetInTouchViewState extends State<GetInTouchView> {
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetInTouchBloc, GetInTouchWithInitial>(
      builder: (context, state) {
        return customScaffold(
            customAppBar: CustomAppBar(
                title: AppStrings.accountSettings_menu_getInTouch_title,
                isLeadingPresent: true),
            hasForm: false,
            formOrColumnInsideSingleChildScrollView: null,
            anyWidgetWithoutSingleChildScrollView: customColumnsWithMenu(
                context: context,
                menuBarTitles: state.getInTouchTitles,
                onTapOnMenuBar: (i) {
                  if (i == 0) {
                    Navigator.of(context).pushNamed(AppRouteNames.routeCMS,
                        arguments: Legals.aboutUs);
                  } else if (i == 1) {
                    Navigator.of(context).pushNamed(
                      AppRouteNames.routeGetInTouchFaq,
                    );
                  }else{
                    Navigator.of(context).pushNamed(
                      AppRouteNames.routeGetInTouchContactUs,
                    );
                  }
                }));
      },
    );
  }
}

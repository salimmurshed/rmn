import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../imports/common.dart';
import '../bloc/legals_bloc.dart';

class LegalsView extends StatefulWidget {
  const LegalsView({super.key});

  @override
  State<LegalsView> createState() => _LegalsViewState();
}

class _LegalsViewState extends State<LegalsView> {
  @override
  void initState() {
    BlocProvider.of<LegalsBloc>(context).add(TriggerCMSFetch());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LegalsBloc, LegalsWithInitialState>(
      builder: (context, state) {
        return customScaffold(
            customAppBar: CustomAppBar(
              title: AppStrings.accountSettings_menu_legals_title,
              isLeadingPresent: true,
            ),
            hasForm: false,
            formOrColumnInsideSingleChildScrollView: null,
            anyWidgetWithoutSingleChildScrollView: state.isLoading
                ? CustomLoader(child: buildLegalsLayout(context, state))
                : buildLegalsLayout(context, state));
      },
    );
  }

  Column buildLegalsLayout(BuildContext context, LegalsWithInitialState state) {
    return customColumnsWithMenu(
        context: context,
        menuBarTitles: state.legals,
        onTapOnMenuBar: (i) {
          if (i != 3) {
            Navigator.of(context).pushNamed(AppRouteNames.routeCMS,
                arguments: i == 0
                    ? Legals.imprints
                    : i == 1
                        ? Legals.tou
                        : Legals.pp);
          } else {
            Navigator.of(context).pushNamed(AppRouteNames.routeFoss);
          }
        });
  }
}

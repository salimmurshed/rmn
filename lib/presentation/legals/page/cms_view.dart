import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../imports/common.dart';
import '../bloc/legals_bloc.dart';

class CmsView extends StatefulWidget {
  const CmsView({super.key, required this.legals});

  final Legals legals;

  @override
  State<CmsView> createState() => _CmsViewState();
}

class _CmsViewState extends State<CmsView> {
  @override
  void initState() {



    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LegalsBloc, LegalsWithInitialState>(
      builder: (context, state) {
        return customScaffold(
            customAppBar: CustomAppBar(
                title:  widget.legals == Legals.imprints
                    ? AppStrings.accountSettings_menu_legals_imprints_title
                    : widget.legals == Legals.pp
                        ? AppStrings.accountSettings_menu_legals_pp_title
                        : widget.legals == Legals.tou
                            ? AppStrings.accountSettings_menu_legals_tou_title
                            : widget.legals == Legals.aboutUs
                                ? AppStrings.getInTouch_aboutUs_title
                                : AppStrings.global_empty_string,
                isLeadingPresent: true),
            hasForm: true,
            formOrColumnInsideSingleChildScrollView: state.isLoading
                ? SizedBox(

              height: Dimensions.getScreenHeight(),
                child:   CustomLoader(child: buildCMSLayout(state)),)
                : buildCMSLayout(state),
            anyWidgetWithoutSingleChildScrollView: null);
      },
    );
  }

  Widget buildCMSLayout(LegalsWithInitialState state) {
    return !state.isLoading && state.data!.isNotEmpty
        ? buildHtmlWidget(text:
    widget.legals == Legals.imprints
        ? state.data!
        .firstWhere((element) => element.pageTitle! == "Imprint")
        .description!
        : widget.legals == Legals.pp
        ? state.data!
        .firstWhere((element) =>
    element.pageTitle! == "Privacy Policy")
        .description!
        : widget.legals == Legals.tou
        ? state.data!
        .firstWhere((element) =>
    element.pageTitle! == "Terms of Use")
        .description!
        : widget.legals == Legals.aboutUs
        ? state.data!
        .firstWhere((element) =>
    element.pageTitle! == "About Us")
        .description!
        : AppStrings.global_empty_string)
        : Container();
  }


}

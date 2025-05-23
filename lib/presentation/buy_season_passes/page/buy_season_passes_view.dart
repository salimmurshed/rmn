import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../imports/common.dart';
import '../../base/bloc/base_bloc.dart';
import '../bloc/buy_season_passes_bloc.dart';
import '../widgets/build_athletes_available_for_selection.dart';
import '../widgets/build_athletes_visible_for_selection.dart';
import '../widgets/build_carousel_slider_for_season_pass.dart';

class BuySeasonPassesView extends StatefulWidget {
  const BuySeasonPassesView({
    super.key,
  });

  @override
  State<BuySeasonPassesView> createState() => _BuySeasonPassesViewState();
}

class _BuySeasonPassesViewState extends State<BuySeasonPassesView> {
  @override
  initState() {
    BlocProvider.of<BuySeasonPassesBloc>(context)
        .add(TriggerFetchSeasonPasses());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BuySeasonPassesBloc, SeasonPassesWithInitialState>(
      listener: (context, state) {},
      child: BlocBuilder<BuySeasonPassesBloc, SeasonPassesWithInitialState>(
        builder: (context, state) {
          return customScaffold(
            persistentFooterButtons: [
              buildCustomLargeFooterBtn(
                  hasKeyBoardOpened: true,
                  onTap: state.canWeProceedToPurchase
                      ? () {
                    BlocProvider.of<BuySeasonPassesBloc>(context)
                        .add(TriggerCollectAthletes());
                  }: () {},
                  btnLabel: AppStrings.btn_purchase,
                  isActive: state.canWeProceedToPurchase,
                  isColorFilledButton: true)
            ],
              customAppBar: CustomAppBar(
                  title: globalCurrentSeason.title!, isLeadingPresent: true),
              hasForm: false,
              formOrColumnInsideSingleChildScrollView: null,
              anyWidgetWithoutSingleChildScrollView:state.isLoadingSeasonPasses? CustomLoader(child: buildSeasonPassesLayout(state, context),):
                  buildSeasonPassesLayout(state, context));
        },
      ),
    );
  }

  Widget buildSeasonPassesLayout(
      SeasonPassesWithInitialState state, BuildContext context) {
    return ListView.builder(
      itemCount: 1,
     shrinkWrap: true,
     itemBuilder: (context, index){return Column( children: [
       buildCarouselSliderForSeasonPasses(state, context),
       buildAthletesAvailableForSelection(context, state),
       buildAthletesVisibleForSelection(state: state, isScrollable: false)]);},
    );
  }
}

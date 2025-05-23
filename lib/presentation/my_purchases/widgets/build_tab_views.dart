import 'package:flutter/material.dart';

import '../../my_purchases/bloc/my_purchases_bloc.dart';
import 'build_regs_products.dart';
import 'build_season_passes.dart';

List<Widget> buildTabViews(MyPurchasesWithInitialState state) {
  return [
    if (state.selectTabIndex == 0) ...buildSeasonPasses(state),
    if (state.selectTabIndex == 1) ...buildRegsProducts(state),
  ];
}
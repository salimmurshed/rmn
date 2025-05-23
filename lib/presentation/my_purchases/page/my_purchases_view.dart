import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rmnevents/presentation/my_purchases/bloc/my_purchases_bloc.dart';
import '../../../common/widgets/buttons/invoice_button.dart';
import '../../../imports/common.dart';

import '../widgets/build_tab_views.dart';

class MyPurchasesView extends StatefulWidget {
  MyPurchasesView({super.key, this.myPurchases});

  MyPurchases? myPurchases;

  @override
  State<MyPurchasesView> createState() => _MyPurchasesViewState();
}

class _MyPurchasesViewState extends State<MyPurchasesView> {
  @override
  void initState() {
    BlocProvider.of<MyPurchasesBloc>(context).add(TriggerInitialize());
    BlocProvider.of<MyPurchasesBloc>(context).add(TriggerSeasonsEvent(
        myPurchases: widget.myPurchases ?? MyPurchases.seasonPasses));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyPurchasesBloc, MyPurchasesWithInitialState>(
      listener: (context, state) {
        if (state.message.isNotEmpty) {
          buildCustomToast(msg: state.message, isFailure: state.isFailure);
        }
      },
      child: BlocBuilder<MyPurchasesBloc, MyPurchasesWithInitialState>(
        builder: (context, state) {
          return customScaffold(
              hasForm: false,
              formOrColumnInsideSingleChildScrollView: null,
              customAppBar: CustomAppBar(
                  appBarActionFunction: !state.isLoading &&
                          state.seasons.isNotEmpty &&
                          state.selectTabIndex == 0
                      ? () {
                          buildCustomShowModalBottomSheetParent(
                              ctx: context,
                              isNavigationRequired: false,
                              child: BlocBuilder<MyPurchasesBloc,
                                  MyPurchasesWithInitialState>(
                                bloc: BlocProvider.of<MyPurchasesBloc>(context)
                                  ..add(TriggerOpenBottomSheetForDownload(
                                      memberships: state
                                          .seasons[state.indexOfSelectedSeason]
                                          .memberships!)),
                                builder: (context, state) {
                                  return buildBottomSheetWithDropDown(
                                      isInvoice: true,
                                      context: context,
                                      onLeftTap: () {},
                                      onRightTap: () {},
                                      prompt: AppStrings
                                          .myPurchases_bottomSheet_invoiceDownload_prompt,
                                      onMenuStateChange: (value) {
                                        BlocProvider.of<MyPurchasesBloc>(
                                                context)
                                            .add(TriggerDropDownExpand(
                                                isExpanded: value));
                                      },
                                      footerBtnLabel: AppStrings
                                          .myPurchases_bottomSheet_invoiceDownload_btn_text,
                                      globalKey: state.globalKey,
                                      highlightedTitle:
                                          AppStrings.global_empty_string,
                                      hint: AppStrings
                                          .myPurchases_bottomSheet_invoiceDownload_hint,
                                      isExpanded: state.isExpanded,
                                      selectedValue: state.selectedValue,
                                      title: AppStrings
                                          .myPurchases_bottomSheet_invoiceDownload_title,
                                      items: customDropDownMenuItems(
                                          items: state.invoiceUrls),
                                      onChanged: (value) {
                                        BlocProvider.of<MyPurchasesBloc>(
                                                context)
                                            .add(TriggerSelectInvoice(
                                                invoiceOrderNumber: value!,
                                                memberships: state
                                                    .seasons[state
                                                        .indexOfSelectedSeason]
                                                    .memberships!));
                                      },
                                      onTap: state.selectedValue != null
                                          ? () {
                                              BlocProvider.of<
                                                      MyPurchasesBloc>(context)
                                                  .add(TriggerDownloadSingleInvoice(
                                                      isIndividualInvoiceDownload:
                                                          false,
                                                      individualInvoiceIndex:
                                                          -1,
                                                      orderNo:
                                                          state.selectedValue!,
                                                      invoiceUrl:
                                                          state.invoiceUrl));
                                              Navigator.pop(context);
                                            }
                                          : () {});
                                },
                              ));
                        }
                      : () {},
                  customActionWidget: !state.isLoading &&
                          state.seasons.isNotEmpty &&
                          state.selectTabIndex == 0
                      ? buildInvoiceButton(
                          onTap: () {
                            buildCustomShowModalBottomSheetParent(
                                ctx: context,
                                isNavigationRequired: false,
                                child: BlocBuilder<MyPurchasesBloc,
                                    MyPurchasesWithInitialState>(
                                  bloc:
                                      BlocProvider.of<MyPurchasesBloc>(context)
                                        ..add(TriggerOpenBottomSheetForDownload(
                                            memberships: state
                                                .seasons[
                                                    state.indexOfSelectedSeason]
                                                .memberships!)),
                                  builder: (context, state) {
                                    return buildBottomSheetWithDropDown(
                                        isInvoice: true,
                                        context: context,
                                        onLeftTap: () {},
                                        onRightTap: () {},
                                        prompt: AppStrings
                                            .myPurchases_bottomSheet_invoiceDownload_prompt,
                                        onMenuStateChange: (value) {
                                          BlocProvider.of<MyPurchasesBloc>(
                                                  context)
                                              .add(TriggerDropDownExpand(
                                                  isExpanded: value));
                                        },
                                        footerBtnLabel: AppStrings
                                            .myPurchases_bottomSheet_invoiceDownload_btn_text,
                                        globalKey: state.globalKey,
                                        highlightedTitle:
                                            AppStrings.global_empty_string,
                                        hint: AppStrings
                                            .myPurchases_bottomSheet_invoiceDownload_hint,
                                        isExpanded: state.isExpanded,
                                        selectedValue: state.selectedValue,
                                        title: AppStrings
                                            .myPurchases_bottomSheet_invoiceDownload_title,
                                        items: customDropDownMenuItems(
                                            items: state.invoiceUrls),
                                        onChanged: (value) {
                                          BlocProvider.of<MyPurchasesBloc>(
                                                  context)
                                              .add(TriggerSelectInvoice(
                                                  invoiceOrderNumber: value!,
                                                  memberships: state
                                                      .seasons[state
                                                          .indexOfSelectedSeason]
                                                      .memberships!));
                                        },
                                        onTap: state.selectedValue != null
                                            ? () {
                                                BlocProvider.of<
                                                            MyPurchasesBloc>(
                                                        context)
                                                    .add(TriggerDownloadSingleInvoice(
                                                        isIndividualInvoiceDownload:
                                                            false,
                                                        individualInvoiceIndex:
                                                            -1,
                                                        orderNo: state
                                                            .selectedValue!,
                                                        invoiceUrl:
                                                            state.invoiceUrl));
                                                Navigator.pop(context);
                                              }
                                            : () {});
                                  },
                                ));
                          },
                          context: context,
                          isLoading: state.isDownloadingInvoice,
                        )
                      : null,
                  title: AppStrings.myPurchases_title,
                  isLeadingPresent: true),
              anyWidgetWithoutSingleChildScrollView: state.isLoading
                  ? CustomLoader(child: buildPurchaseHistoryLayout(state))
                  : buildPurchaseHistoryLayout(state));
        },
      ),
    );
  }

  Column buildPurchaseHistoryLayout(MyPurchasesWithInitialState state) {
    return Column(
      children: [
        buildCustomTabBar(
            isSmallButtonTitle: false,
            isScrollRequired: false,
            tabElements: [
              TabElements(
                title: AppStrings.myPurchases_tab_seasonPasses_title,
                onTap: () {
                  BlocProvider.of<MyPurchasesBloc>(context).add(
                      const TriggerSeasonsEvent(
                          myPurchases: MyPurchases.seasonPasses));
                },
                isSelected: state.selectTabIndex == 0,
              ),
              TabElements(
                  title: AppStrings.myPurchases_tab_products_title,
                  onTap: () {
                    BlocProvider.of<MyPurchasesBloc>(context)
                        .add(TriggerProductsEvent());
                  },
                  isSelected: state.selectTabIndex == 1)
            ]),
        if (!state.isLoading) ...buildTabViews(state)
      ],
    );
  }
}

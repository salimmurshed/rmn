import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rmnevents/presentation/chat/bloc/chat_bloc.dart';
import 'package:rmnevents/root_app.dart';
import '../../../imports/common.dart';
import '../../purchased_products/bloc/purchased_products_bloc.dart';
import '../../qr_scan_view/bloc/qr_scan_bloc.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  void initState() {
    BlocProvider.of<QrScanBloc>(context)
        .add(const TriggerHistoryTabEvents(HistoryTabEvents.all));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QrScanBloc, QrScanState>(
      builder: (context, state) {
        debugPrint(
            'historyPage: ${state.historyPage}--total ${state.totalHistoryPage}');
        debugPrint(
            'salesPage: ${state.salesPage}--total ${state.totalSalesPage}');
        return customScaffold(
            customAppBar: CustomAppBar(
                goBack: () {
                  BlocProvider.of<QrScanBloc>(context)
                      .add(TriggerReloadHistory());
                },
                title: AppStrings.staff_history_title,
                isLeadingPresent: true),
            hasForm: false,
            formOrColumnInsideSingleChildScrollView: null,
            anyWidgetWithoutSingleChildScrollView: state.isLoading
                ? CustomLoader(child: buildListView(state))
                : buildListView(state));
      },
    );
  }

  Widget buildListView(QrScanState state) {
    return Column(
      children: [
        buildCustomTabBar(isScrollRequired: false, tabElements: [
          TabElements(
            onTap: () {
              BlocProvider.of<QrScanBloc>(context)
                  .add(const TriggerSwitchTabs(index: 0));
            },
            title: 'Scan History',
            isSelected: state.selectedIndex == 0,
          ),
          TabElements(
            onTap: () {
              BlocProvider.of<QrScanBloc>(context)
                  .add(const TriggerSwitchTabs(index: 1));
            },
            title: 'Sales Transactions',
            isSelected: state.selectedIndex == 1,
          ),
        ]),

          if (state.selectedIndex == 0)
            Container(
              margin: EdgeInsets.only(
                bottom: 10.h,
              ),
              height: 30.h,
              width: Dimensions.getScreenWidth(),
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  buildFilter(
                    index: 0,
                    isSelected: state.filterIndex == 0
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  buildFilter(
                    index: 1,
                    isSelected: state.filterIndex == 1
                  ),
                ],
              ),
            ),
          if (state.selectedIndex == 0) buildScanHistory(state),
          if (state.selectedIndex == 1) buildSalesTransactions(state)

      ],
    );
  }


  Expanded buildSalesTransactions(QrScanState state) {
    debugPrint('salesPage: ${state.salesPage} -- ${state.totalSalesPage}');
    return Expanded(
      child: ListView.builder(
        itemCount: state.salesData.length,
        // controller: state.scrollControllerI
        //   ..addListener(() {
        //     print('pixels: ${state.isFetchingSales}');
        //     if (state.scrollControllerI.position.pixels >
        //         state.scrollControllerI.position.maxScrollExtent - 1000) {
        //       if(!state.isFetchingSales){
        //         if (state.totalSalesPage > state.salesPage) {
        //           BlocProvider.of<QrScanBloc>(context).add(TriggerScrollSales());
        //         }
        //       }
        //     } else {
        //       debugPrint('hh');
        //       debugPrint(
        //           '_______${state.scrollControllerI.position.maxScrollExtent}');
        //     }
        //   }),
        itemBuilder: (context, index) {

          if (index == state.salesData.length-1 &&(state.totalSalesPage > state.salesPage)) {
            if(!state.isFetchingSales){
              if (state.totalSalesPage > state.salesPage) {
                BlocProvider.of<QrScanBloc>(context).add(TriggerScrollSales());
              }
            }
            return state.isLoadingMore? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator(
                color: AppColors.colorPrimaryAccent,
              )),
            ): const SizedBox.shrink();
          }
          return Container(
            margin: const EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(
              horizontal: 5.w,
              vertical: 5.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.colorTertiary,
              borderRadius: BorderRadius.circular(10),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.grey.withOpacity(0.5),
              //     spreadRadius: 1,
              //     blurRadius: 7,
              //     offset: const Offset(0, 3),
              //   ),
              // ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: Dimensions.getScreenWidth() * 0.81,
                  margin: EdgeInsets.only(left: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildNamePriceRow(
                        name: state.salesData[index].purchaseType == 'products'
                            ? 'Product Purchase'
                            : 'Registration',
                        price: state.salesData[index].amount!,
                        items: state.salesData[index].qty,
                      ),
                      buildEventName(state, 1, false, index),
                      SizedBox(
                        height: 5.h,
                      ),
                      // buildScanPurchaseDetails(
                      //     isSales: true,
                      //     state: state,
                      //     index: index,
                      //     isScanned: false),
                      buildPurchaseDetailColumn(
                          state: state, index: index),

                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          method(
                              brand: state.salesData[index].cardBrand ??
                                  AppStrings.global_empty_string,
                              method: state.salesData[index].paymentMethod ??
                                  AppStrings.global_empty_string),
                          const Spacer(),
                          buildGestureInvoice(
                              index: index,
                              isDownloaded:
                                  state.salesData[index].isDownloaded!,
                              orderNo: state.salesData[index].orderNo!,
                              invoiceUrl: state.salesData[index].invoiceUrl!)
                        ],
                      ),

                      // buildScanPurchaseDetails(
                      //     state: state, index: index, isScanned: true),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildScanHistory(QrScanState state) {
    return state.isFilterItemsLoading
        ? Center(
            child: CustomLoader(
              isForSingleWidget: true,
              isTopMarginNeeded: true,
              topMarginHeight: Dimensions.getScreenHeight() * 0.3,
              child: SizedBox(
                height: 100.h,
                width: 100.w,
              ),
            ),
          )
        : (state.historyData.isEmpty && !state.isLoading
            ? Expanded(
                child: Center(
                child: Text(
                  AppStrings.staff_home_history_noQRData_title,
                  style: AppTextStyles.smallTitleForEmptyList(),
                ),
              ))
            : (
     buildHistoryLayout(state)
    ));
  }

  Expanded buildHistoryLayout(QrScanState state) {
    return Expanded(
      child: ListView.builder(
        itemCount: state.historyData.length,shrinkWrap: true,
        // controller: state.scrollController
        //   ..addListener(() {
        //
        //     if (state.scrollController.position.pixels >=
        //         state.scrollController.position.maxScrollExtent-1000) {
        //       if(!state.isFetchingHistory){
        //         if(state.filterIndex == -1){
        //           debugPrint('if ${state.totalAllPage} > ${state.allPage}');
        //           if (state.totalAllPage > state.allPage) {
        //             BlocProvider.of<QrScanBloc>(context)
        //                 .add(const TriggerHistoryTabEvents(
        //               HistoryTabEvents.allScroll,
        //             ));
        //           }
        //         }
        //         else{
        //           debugPrint('else');
        //           if (state.totalHistoryPage > state.historyPage) {
        //             BlocProvider.of<QrScanBloc>(context)
        //                 .add( TriggerHistoryTabEvents(
        //                 state.filterIndex == 0
        //                     ? HistoryTabEvents.productScroll
        //                     : HistoryTabEvents.registrationScroll),
        //             );
        //           }
        //         }
        //       }
        //     } else {
        //       debugPrint('else');
        //       debugPrint('pixels: ${state.scrollController.position.pixels}');
        //       debugPrint(
        //           'maxScrollExtent: ${state.scrollController.position.maxScrollExtent}');
        //     }
        //   }),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {

          if (index == state.historyData.length-1 && state.filterIndex == -1 && state.totalAllPage > state.allPage) {
            if(!state.isFetchingHistory){
                debugPrint('if ${state.totalAllPage} > ${state.allPage}');
                if (state.totalAllPage > state.allPage) {
                  BlocProvider.of<QrScanBloc>(context)
                      .add(const TriggerHistoryTabEvents(
                    HistoryTabEvents.allScroll,
                  ));
                }


            }
            return state.isLoadingMore? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator(
                color: AppColors.colorPrimaryAccent,
              )),
            ): const SizedBox.shrink();
          }
          if (index == state.historyData.length-1 && state.filterIndex != -1 && state.totalHistoryPage > state.historyPage) {
            if(!state.isFetchingHistory){


                debugPrint('else');
                if (state.totalHistoryPage > state.historyPage) {
                  BlocProvider.of<QrScanBloc>(context)
                      .add( TriggerHistoryTabEvents(
                      state.filterIndex == 0
                          ? HistoryTabEvents.productScroll
                          : HistoryTabEvents.registrationScroll),
                  );
                }

            }
            return state.isLoadingMore? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator(
                color: AppColors.colorPrimaryAccent,
              )),
            ): const SizedBox.shrink();
          }

          return Container(
            margin: const EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(
              horizontal: 5.w,
              vertical: 5.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.colorTertiary,
              borderRadius: BorderRadius.circular(10),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.grey.withOpacity(0.5),
              //     spreadRadius: 1,
              //     blurRadius: 7,
              //     offset: const Offset(0, 3),
              //   ),
              // ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(Dimensions.generalSmallRadius),
                  child: Container(
                    height: 96.h,
                    width: 84.w,
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          height: 96.h,
                          width: 84.w,
                          imageUrl: state.historyData[index].product != null
                              ? state.historyData[index].product!.image!
                              : state.historyData[index].athlete != null
                                  ? state
                                      .historyData[index].athlete!.profileImage!
                                  : AppStrings.global_empty_string,
                          errorWidget: (context, url, error) => Icon(
                            Icons.error,
                            color: AppColors.colorPrimaryAccent,
                          ),
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: IntrinsicHeight(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 3.h,
                              ),
                              width: Dimensions.getScreenWidth(),
                              decoration: BoxDecoration(
                                color:
                                    (!(state.historyData[index].isCancelled ??
                                            false))
                                        ? AppColors.colorSuccess
                                        : AppColors.colorError,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(2.r),
                                  bottomRight: Radius.circular(2.r),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  (!(state.historyData[index].isCancelled ??
                                          false))
                                      ? AppStrings
                                          .staff_history_itemStatus_success_text
                                      : AppStrings
                                          .staff_history_itemStatus_failure_text,
                                  style: AppTextStyles.normalPrimary(
                                      color: AppColors.colorPrimaryInverseText,
                                      isOutfit: false),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: Dimensions.getScreenWidth() * 0.6,
                  margin: EdgeInsets.only(left: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildNamePriceRow(
                        name: state.historyData[index].product?.title != null
                            ? state.historyData[index].product?.title ?? ''
                            : state.historyData[index].athlete != null
                                ? StringManipulation
                                    .combineStringWithSpaceBetween(
                                        firstPart: state.historyData[index]
                                            .athlete!.firstName!,
                                        lastPart: state.historyData[index]
                                            .athlete!.lastName!)
                                : AppStrings.global_empty_string,
                        price: state.historyData[index].price!,
                      ),
                      buildEventName(state, 0,
                          state.historyData[index].product != null, index),
                      SizedBox(
                        height: 5.h,
                      ),
                      buildScanPurchaseDetails(
                          state: state, index: index, isScanned: false),
                      buildScanPurchaseDetails(
                          state: state, index: index, isScanned: true),
                      SizedBox(
                        height: 10.h,
                      ),
                      if (state.historyData[index].product == null)
                        Row(
                          children: [
                            Expanded(
                              child: Wrap(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    StringManipulation
                                        .capitalizeFirstLetterOfEachWord(
                                            value: state.historyData[index]
                                                .division!.title!),
                                    style: AppTextStyles.normalPrimary(
                                      isOutfit: false,
                                      color: AppColors.colorPrimaryInverseText,
                                    ),
                                  ),
                                  const Text(' | ',
                                      style: TextStyle(
                                          height: 1.5, color: Colors.white30)),
                                  Text(
                                    StringManipulation
                                        .capitalizeFirstLetterOfEachWord(
                                            value: state.historyData[index]
                                                .division!.style!),
                                    style: AppTextStyles.normalPrimary(
                                      isOutfit: false,
                                      color: AppColors.colorPrimaryInverseText,
                                    ),
                                  ),
                                  const Text(' | ',
                                      style: TextStyle(
                                          height: 1.5, color: Colors.white30)),
                                  Text(
                                    StringManipulation
                                        .capitalizeFirstLetterOfEachWord(
                                            value: state.historyData[index]
                                                .weightClass!.weight!),
                                    style: AppTextStyles.normalPrimary(
                                      isOutfit: false,
                                      color: AppColors.colorPrimaryInverseText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // const Spacer(
                            //   flex: 2,
                            // ),
                            buildGestureInvoice(
                                index: index,
                                isDownloaded:
                                    state.historyData[index].isDownloaded!,
                                orderNo: state.historyData[index].orderNo!,
                                invoiceUrl:
                                    state.historyData[index].invoiceUrl!)
                          ],
                        ),
                      if (state.historyData[index].product != null)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Text(
                            //   StringManipulation
                            //       .capitalizeFirstLetterOfEachWord(
                            //           value: state
                            //               .historyData[index].product!.title!),
                            //   style: AppTextStyles.normalPrimary(
                            //     isOutfit: false,
                            //     color: AppColors.colorPrimaryInverseText,
                            //   ),
                            // ),
                            if (state.historyData[index].variant != null) ...[
                              if (state.historyData[index].variant!.isNotEmpty)
                                // const Text(' | ',
                                //     style: TextStyle(
                                //         height: 1.5, color: Colors.white30)),
                              if (state.historyData[index].variant!.isNotEmpty)
                                Text(
                                  'Variant-${StringManipulation.capitalizeFirstLetterOfEachWord(value: state.historyData[index].variant!)}',
                                  style: AppTextStyles.normalPrimary(
                                    isOutfit: false,
                                    color: AppColors.colorPrimaryInverseText,
                                  ),
                                ),
                            ],
                            const Spacer(
                              flex: 5,
                            ),
                            buildGestureInvoice(
                                index: index,
                                isDownloaded:
                                    state.historyData[index].isDownloaded!,
                                orderNo: state.historyData[index].orderNo!,
                                invoiceUrl:
                                    state.historyData[index].invoiceUrl!)
                          ],
                        )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  GestureDetector buildGestureInvoice({
    required String orderNo,
    required String invoiceUrl,
    required int index,
    required bool isDownloaded,
  }) {
    return GestureDetector(
      onTap: () {
        if (isDownloaded) {
          BlocProvider.of<PurchasedProductsBloc>(context).add(
              TriggerDownloadPdf(
                  orderNo: orderNo, invoiceUrl: invoiceUrl, index: index));
        }
      },
      child: Container(
        margin: EdgeInsets.only(left: 5.w),
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isDownloaded
              ? AppColors.colorSecondaryAccent
              : AppColors.colorBlueOpaque,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          'View Invoice',
          style: AppTextStyles.normalPrimary(
              color: AppColors.colorPrimaryInverseText, isOutfit: false),
        ),
      ),
    );
  }

  Widget buildPurchaseDetailColumn({required QrScanState state,required int index}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        SizedBox(height: 10.h
          ,),
        Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Text('Purchased at', style: AppTextStyles.normalNeutral(
              )),
              SizedBox(width: 15.w,),
              Text(
                 state.salesData[index].createdAt != null
                    ? DateFunctions.getMMMddyyyyFormat(
                    date: state.salesData[index].createdAt!)
                    : AppStrings.global_empty_string,
                style: AppTextStyles.normalPrimary(
                    isOutfit: true,
                  isBold: true
                ),
              ),
            ]),
        SizedBox(height: 10.h
          ,),
        Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Text('Purchased by', style: AppTextStyles.normalNeutral(
              )),
              SizedBox(width: 15.w,),
              Flexible(
                child: Text(
                  state.salesData[index].purchasedBy!.isEmpty ? AppStrings.global_empty_user: state.salesData[index].purchasedBy!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.normalPrimary(
                      isOutfit: true,
                      isBold: true
                  ),
                ),
              ),
            ]),
      ]
    );
  }
  RichText buildScanPurchaseDetails(
      {required bool isScanned,
      required QrScanState state,
      bool isSales = false,
      required int index}) {
    return isSales
        ? RichText(
            maxLines: 3,
            text: TextSpan(
              text: 'Purchased at  ',
              style: AppTextStyles.superSmallPrimary(
                  isOutFit: true,
                  isBold: true,
                  color: AppColors.colorPrimaryNeutralText, fontSize: AppFontSizes.component),
              children: [
                TextSpan(
                  text: state.salesData[index].createdAt != null
                      ? DateFunctions.getMMMddyyyyFormat(
                          date: state.salesData[index].createdAt!)
                      : AppStrings.global_empty_string,
                  style: AppTextStyles.superSmallPrimary(
                      isOutFit: true,
                      isBold: true,
                      color: AppColors.colorPrimaryInverseText, fontSize: AppFontSizes.component),
                ),
              ],
            ),
          )
        : RichText(
            maxLines: 3,
            text: TextSpan(
              text: isScanned
                  ? AppStrings.staff_history_itemScanner_prefix_text
                  : AppStrings.staff_history_itemBuyer_prefix_text,
              style: AppTextStyles.superSmallPrimary(
                  isOutFit: true,
                  isBold: true,
                  color: AppColors.colorPrimaryNeutralText, fontSize: AppFontSizes.component),
              children: [
                TextSpan(
                  text: isScanned
                      ? '    ${state.historyData[index].scanDetails!.scannedByUser!}'
                      : '    ${state.historyData[index].user!.firstName!} ${state.historyData[index].user!.lastName!}',
                  style: AppTextStyles.superSmallPrimary(
                      isOutFit: true,
                      isBold: true,
                      color: AppColors.colorPrimaryInverseText,fontSize: AppFontSizes.component),
                ),
                TextSpan(
                  text:
                      ' | ${DateFunctions.getMMMddyyyyFormat(date: isScanned ? state.historyData[index].scanDetails!.scannedAt! : state.historyData[index].createdAt!)}',
                  style: AppTextStyles.superSmallPrimary(
                      isOutFit: true,
                      isBold: true,
                      color: AppColors.colorPrimaryNeutralText, fontSize: AppFontSizes.component),
                ),
              ],
            ),
          );
  }

  Widget method({required String brand, required String method}) {
    String comparator = method.toLowerCase() == 'card' ? brand : method;
    return Row(
      children: [
        Text(
          'Payment Method  ',
          style: AppTextStyles.superSmallPrimary(
              isOutFit: true,
              isBold: false,
              color: AppColors.colorPrimaryNeutralText, fontSize: AppFontSizes.normal),
        ),
        Image.asset(method.toLowerCase() == 'amazon_pay'
            ? AppAssets.imgAmazon
            : comparator.toLowerCase() == 'paypal'
                ? AppAssets.imgPaypal
                : comparator.toLowerCase() == 'apple_pay'
                    ? AppAssets.imgApay
                    : comparator.toLowerCase() == 'google_pay'
                        ? AppAssets.imgGpay
                        : comparator.toLowerCase() == 'visa'
                            ? AppAssets.imgVisa
                            : AppAssets.imgMastercard),
        Text(
          '  ${StringManipulation.capitalizeFirstLetterOfEachWord(value: brand.isEmpty ? method : brand)}',
          style: AppTextStyles.superSmallPrimary(
              isOutFit: true,
              isBold: true,
              color: AppColors.colorPrimaryInverseText, fontSize: AppFontSizes.component),
        ),
      ],
    );
  }

  List<Widget> buildAthleteDivisionInfo(QrScanState state, int index) {
    return [
      // Text(
      //   StringManipulation.capitalizeFirstLetterOfEachWord(
      //       value: state.historyData[index].divisionType!),
      //   style: AppTextStyles.regularPrimary(
      //       color: AppColors.colorPrimaryInverseText,
      //       isBold: true,
      //       isOutFit: false),
      // ),
      Text(
        StringManipulation.capitalizeFirstLetterOfEachWord(
            value: state.historyData[index].division!.title!),
        style: AppTextStyles.superSmallPrimary(
            isOutFit: false,
            isBold: true,
            color: AppColors.colorPrimaryInverseText),
      ),
      Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 3.w),
            child: SvgPicture.asset(
              AppAssets.icWrestling,
              height: 10.h,
              width: 12.w,
            ),
          ),
          Text(
            StringManipulation.capitalizeFirstLetterOfEachWord(
                value: state.historyData[index].division!.style!),
            style: AppTextStyles.superSmallPrimary(
                isOutFit: false,
                isBold: false,
                color: AppColors.colorPrimaryInverseText),
          ),
          SizedBox(
            width: 5.w,
          ),
          Padding(
            padding: EdgeInsets.only(right: 3.w),
            child: SvgPicture.asset(AppAssets.icWeight),
          ),
          Text(
            'WC ${state.historyData[index].weightClass!.weight!}',
            style: AppTextStyles.superSmallPrimary(
                isOutFit: false,
                isBold: false,
                color: AppColors.colorPrimaryInverseText),
          ),
        ],
      ),
      SizedBox(
        height: 5.h,
      ),
    ];
  }

  Widget buildEventName(
      QrScanState state, int selectTab, bool isProduct, int index) {
    return selectTab == 0
        ? Text(
            state.historyData[index].event != null
                ? state.historyData[index].event!.title!
                : AppStrings.global_empty_string,
            style: AppTextStyles.normalPrimary(
                isOutfit: false, color: AppColors.colorPrimaryAccent),
          )
        : Text(
            state.salesData[index].event!.title ??
                AppStrings.global_empty_string,
            style: AppTextStyles.normalPrimary(
                isOutfit: false, color: AppColors.colorPrimaryAccent),
          );
    // return RichText(
    //   maxLines: 3,
    //   text: TextSpan(
    //     text: AppStrings.staff_history_itemEvent_prefix_text,
    //     style: AppTextStyles.regularPrimary(
    //         isOutFit: false,
    //         isBold: true,
    //         color: AppColors.colorPrimaryNeutralText),
    //     children: [
    //       TextSpan(
    //         text: state.historyData[index].event != null
    //             ? state.historyData[index].event!.title!
    //             : AppStrings.global_empty_string,
    //         style: AppTextStyles.regularPrimary(
    //             isOutFit: false,
    //             isBold: true,
    //             color: AppColors.colorPrimaryAccent),
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget buildNamePriceRow(
      {required String name, num? items, required num price}) {
    return SizedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              name,
              style: AppTextStyles.regularPrimary(
                  isOutFit: false,
                  isBold: true,
                  color: AppColors.colorPrimaryInverseText),
            ),
          ),
          if (items != null)
            Text(
              '$items items  ',
              style: AppTextStyles.regularPrimary(
                  isOutFit: false,
                  isBold: true,
                  color: AppColors.colorPrimaryNeutralText),
            ),
          Text(
            StringManipulation.addADollarSign(price: price),
            style: AppTextStyles.regularPrimary(
                isOutFit: false,
                isBold: true,
                color: AppColors.colorPrimaryInverseText),
          ),
        ],
      ),
    );
  }
}
IntrinsicWidth buildFilter({required int index, required bool isSelected,
  void Function()? onTap,
  String? title,
  double? width,
  bool isActive = true
}) {
  return IntrinsicWidth(
    child: GestureDetector(
      onTap: onTap ?? (isSelected ? (){
        BlocProvider.of<QrScanBloc>(navigatorKey.currentContext!).add(const TriggerHistoryTabEvents(
            HistoryTabEvents.all));
      }:
          () {
        BlocProvider.of<QrScanBloc>(navigatorKey.currentContext!).add(TriggerHistoryTabEvents(
            index == 0
                ? HistoryTabEvents.products
                : HistoryTabEvents.registrations));
      }),
      child: Opacity(
        opacity: isActive? 1: 0.7,
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: isSelected? AppColors.colorSecondaryAccent: AppColors.colorPrimary,
            border: Border.all(
              color: AppColors.colorTertiary,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 3.h,
          ),
          child: Center(
            child: Text(
              title ?? (index == 0 ? 'Products' : 'Registrations'),
              style: AppTextStyles.normalPrimary(
                color: AppColors.colorPrimaryInverseText,
                isOutfit: false,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

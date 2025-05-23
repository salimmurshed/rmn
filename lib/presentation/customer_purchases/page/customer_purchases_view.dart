import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rmnevents/imports/common.dart';
import 'package:rmnevents/presentation/event_details/page/event_detail_view.dart';

import '../../../imports/data.dart';
import '../../history/page/history_view.dart';
import '../bloc/customer_purchases_bloc.dart';

class CustomerPurchasesView extends StatefulWidget {
  const CustomerPurchasesView({super.key});

  @override
  State<CustomerPurchasesView> createState() => _CustomerPurchasesViewState();
}

class _CustomerPurchasesViewState extends State<CustomerPurchasesView> {
  @override
  void initState() {
    BlocProvider.of<CustomerPurchasesBloc>(context)
        .add(TriggerFetchCustomerPurchasesRefresh());
    BlocProvider.of<CustomerPurchasesBloc>(context)
        .add(TriggerFetchCustomerPurchases());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerPurchasesBloc, CustomerPurchasesState>(
      builder: (context, state) {
        return customScaffold(
            hasForm: true,
            customAppBar: CustomAppBar(
              title: state.userName.isEmpty
                  ? 'Customer Purchases'
                  : state.userName,
              isLeadingPresent: true,
            ),
            formOrColumnInsideSingleChildScrollView: null,
            anyWidgetWithoutSingleChildScrollView: state.isLoading
                ? CustomLoader(child: buildLayout(context, state))
                : buildLayout(context, state));
      },
    );
  }

  Column buildLayout(BuildContext context, CustomerPurchasesState state) {
    return Column(
      children: [
        buildCustomTabBar(isScrollRequired: false, tabElements: [
          TabElements(
              isActive: state.indexOfSelectedItem == -1,
              title: AppStrings.myPurchases_tab_products_title,
              onTap: () {
                BlocProvider.of<CustomerPurchasesBloc>(context)
                    .add(const TriggerSwitchBetweenTabs(selectedTabIndex: 0));
              },
              isSelected: state.selectedTab == 0),
          TabElements(
            isActive: state.indexOfSelectedItem == -1,
              title: AppStrings.myPurchases_tab_registration_title,
              onTap:  () {
                BlocProvider.of<CustomerPurchasesBloc>(context)
                    .add(const TriggerSwitchBetweenTabs(selectedTabIndex: 1));
              },
              isSelected: state.selectedTab == 1),
        ]),
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
                  width: 70.w,
                  index: 0,
                  isActive: state.indexOfSelectedItem == -1,
                  isSelected: state.customerPurchasesTypes ==
                      CustomerPurchasesTypes.all,
                  onTap: () {
                    if(state.indexOfSelectedItem == -1) {
                      BlocProvider.of<CustomerPurchasesBloc>(context).add(
                          const TriggerFilterPurchases(
                              customerPurchasesTypes:
                                  CustomerPurchasesTypes.all));
                    }
                  },
                  title: AppStrings.customerPurchases_tab_all_title),
              SizedBox(
                width: 10.w,
              ),
              buildFilter(
                  index: 1,
                  width: 70.w,
                  isActive: state.indexOfSelectedItem == -1,
                  isSelected: state.customerPurchasesTypes ==
                      CustomerPurchasesTypes.scanned,
                  onTap: () {
                    if(state.indexOfSelectedItem == -1) {
                      BlocProvider.of<CustomerPurchasesBloc>(context).add(
                          const TriggerFilterPurchases(
                              customerPurchasesTypes:
                                  CustomerPurchasesTypes.scanned));
                    }
                  },
                  title: AppStrings.customerPurchases_tab_scanned_title),
              SizedBox(
                width: 10.w,
              ),
              buildFilter(
                  width: 100.w,
                  isActive: state.indexOfSelectedItem == -1,
                  index: 2,
                  isSelected: state.customerPurchasesTypes ==
                      CustomerPurchasesTypes.unScanned,
                  onTap: () {
                    if(state.indexOfSelectedItem == -1) {
                      BlocProvider.of<CustomerPurchasesBloc>(context).add(
                          const TriggerFilterPurchases(
                              customerPurchasesTypes:
                                  CustomerPurchasesTypes.unScanned));
                    }
                  },
                  title: AppStrings.customerPurchases_tab_unscanned_title),
            ],
          ),
        ),
        if ((state.selectedTab == 0 && state.products.isNotEmpty) ||
            (state.selectedTab == 1 && state.registrations.isNotEmpty)) ...[
          Flexible(
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  return Opacity(
                    opacity: state.indexOfSelectedItem == i ? 0.2 : 1,
                    child: itemContainer(
                        isCancelled: state.selectedTab == 0
                            ? state.products[i].isCancelled!
                            : state.registrations[i].isCancelled!,
                        qrCode: state.selectedTab == 0
                            ? state.products[i].qrCode!
                            : state.registrations[i].qrCode!,
                        wc: state.selectedTab == 0
                            ? AppStrings.global_empty_string
                            : state.registrations[i].weightClass!.weight
                                .toString(),
                        division: state.selectedTab == 0
                            ? AppStrings.global_empty_string
                            : StringManipulation.capitalizeFirstLetterOfEachWord(
                                value: state.registrations[i].division!.divisionType!),
                        ageGroup: state.selectedTab == 0
                            ? AppStrings.global_empty_string
                            : StringManipulation.capitalizeFirstLetterOfEachWord(
                                value: state.registrations[i].division!.title!),
                        style: state.selectedTab == 0
                            ? AppStrings.global_empty_string
                            : StringManipulation.capitalizeFirstLetterOfEachWord(
                                value: state.registrations[i].division!.style!),
                        index: i,
                        purchaseItemType: state.selectedTab == 0
                            ? PurchaseItemType.product
                            : PurchaseItemType.registration,
                        purchaseId: state.selectedTab == 0
                            ? state.products[i].sId!
                            : state.registrations[i].sId!,
                        scanDetails: state.selectedTab == 0
                            ? state.products[i].scanDetails
                            : state.registrations[i].scanDetails,
                        date: state.selectedTab == 0
                            ? state.products[i].createdAt!
                            : '',
                        image: state.selectedTab == 0
                            ? state.products[i].product!.image!
                            : state.registrations[i].athlete!.profileImage!,
                        price: state.selectedTab == 0 ? state.products[i].price! : state.registrations[i].price!,
                        variant: state.selectedTab == 0 ? (state.products[i].variant ?? '') : AppStrings.global_empty_string,
                        onTap: () {},
                        title: state.selectedTab == 0 ? state.products[i].product!.title! : StringManipulation.combineFirstNameWithLastName(firstName: state.registrations[i].athlete!.firstName!, lastName: state.registrations[i].athlete!.lastName!)),
                  );
                },
                separatorBuilder: (context, i) {
                  return Container(height: 10.h);
                },
                itemCount: state.selectedTab == 0
                    ? state.products.length
                    : state.registrations.length),
          )
        ] else ...[
          Column(
            children: [
              SizedBox(
                height: Dimensions.getScreenHeight() * 0.3,
              ),
              Text(
                state.selectedTab == 0
                    ? (state.customerPurchasesTypes ==
                            CustomerPurchasesTypes.all
                        ? 'No products have been purchased yet'
                        : state.customerPurchasesTypes ==
                                CustomerPurchasesTypes.scanned
                            ? 'No products have been scanned yet.'
                            : 'All products have been scanned')
                    : (state.customerPurchasesTypes ==
                            CustomerPurchasesTypes.all
                        ? 'No registrations have been made yet'
                        : state.customerPurchasesTypes ==
                                CustomerPurchasesTypes.scanned
                            ? 'No registrations have been scanned yet'
                            : 'All registrations have been scanned'),
                style: AppTextStyles.smallTitleForEmptyList(),
              ),
            ],
          )
        ]
      ],
    );
  }

  Container itemContainer({
    required String image,
    required String title,
    required String date,
    required String purchaseId,
    required num price,
    required String variant,
    String division = AppStrings.global_empty_string,
    String ageGroup = AppStrings.global_empty_string,
    String style = AppStrings.global_empty_string,
    String wc = AppStrings.global_empty_string,
    required void Function() onTap,
    required ScanDetails? scanDetails,
    required int index,
    required String qrCode,
    required bool isCancelled,
    required PurchaseItemType purchaseItemType,
  }) {
    return Container(
      height: 130.h,
      width: Dimensions.getScreenWidth(),
      color: AppColors.colorSecondary,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Container(
                    color: AppColors.colorPrimary,
                    child: CachedNetworkImage(
                      imageUrl: image,
                      height: 120.h,
                      width: 100.w,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                if (scanDetails != null)
                  Container(
                    height: 120.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: AppColors.colorSuccess.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check,
                          color: AppColors.colorPrimaryInverse,
                          size: 50.h,
                        ),
                        Text(
                          'Scanned',
                          style: AppTextStyles.regularPrimary(isOutFit: true),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: Dimensions.getScreenWidth(),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: Text(
                                title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style:
                                    AppTextStyles.smallTitle(isOutFit: false),
                              )),
                          SizedBox(
                            width: 5.w,
                          ),
                          GestureDetector(
                            onTap: () async {
                              await showDialog(
                                  context: context,
                                  builder: (_) => customQRDialog(
                                      GlobalHandlers.convertQRCodeToImage(
                                          qrCode: qrCode),
                                      scanDetails == null
                                          ? (isCancelled
                                              ? AppStrings
                                                  .myPurchases_qrCode_noScanDetailsCancelled_text
                                              : AppStrings
                                                  .myPurchases_qrCode_noScanDetails_text)
                                          : (isCancelled
                                              ? AppStrings
                                                  .myPurchases_qrCode_noScanDetailsCancelled_text
                                              : AppStrings
                                                  .myPurchases_qrCode_scanDetailsConfirmed_text)));
                            },
                            child: SvgPicture.asset(
                              AppAssets.icQRWhiteBg,
                              height: 40.h,
                              width: 40.w,
                            ),
                          )
                        ],
                      ),
                    ),
                    // if (purchaseItemType == PurchaseItemType.product)
                    //   Container(
                    //     width: Dimensions.getScreenWidth() * 0.45,
                    //     child: Row(
                    //       children: [
                    //         SvgPicture.asset(AppAssets.icCart,
                    //             width: 12.w,
                    //             height: 12.h,
                    //             colorFilter: ColorFilter.mode(
                    //                 AppColors.colorPrimaryAccent,
                    //                 BlendMode.srcIn)),
                    //         SizedBox(
                    //           width: 5.w,
                    //         ),
                    //         Expanded(
                    //             child: Text(
                    //           DateFunctions.getMMMMddyyyyFormat(date: date),
                    //           overflow: TextOverflow.ellipsis,
                    //           maxLines: 1,
                    //           style: AppTextStyles.regularNeutralOrAccented(),
                    //         )),
                    //       ],
                    //     ),
                    //   ),
                    if (purchaseItemType == PurchaseItemType.product) ...[
                      if (variant.isNotEmpty)
                        Container(
                          width: Dimensions.getScreenWidth() * 0.45,
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                'Variant: $variant',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: AppTextStyles.regularPrimary(
                                    isOutFit: false),
                              )),
                            ],
                          ),
                        )
                    ] else ...[
                      Container(
                        width: Dimensions.getScreenWidth() * 0.45,
                        child: RichText(
                            maxLines: 2,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: division,
                                  style: AppTextStyles.regularPrimary(
                                      isOutFit: false)),
                              TextSpan(
                                  text:  ' | ',
                                  style: AppTextStyles.regularNeutralOrAccented()),
                              TextSpan(
                                  text: ageGroup,
                                  style: AppTextStyles.regularPrimary(
                                      isOutFit: false)),
                              TextSpan(
                                  text: ' | ',
                                  style:
                                      AppTextStyles.regularNeutralOrAccented()),
                              TextSpan(
                                  text: style,
                                  style: AppTextStyles.regularPrimary(
                                      isOutFit: false)),
                              TextSpan(
                                  text: ' | ',
                                  style:
                                      AppTextStyles.regularNeutralOrAccented()),
                              TextSpan(
                                  text: wc,
                                  style: AppTextStyles.regularPrimary(
                                      isOutFit: false)),
                            ])),
                      )
                    ],
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          StringManipulation.addADollarSign(price: price),
                          style: AppTextStyles.regularNeutralOrAccented(),
                        ),
                        const Spacer(),
                        if (scanDetails == null)
                          GestureDetector(
                            // splashColor: Colors.transparent,
                            onTap: () {
                              buildBottomSheetWithBodyText(
                                  context: context,
                                  title:
                                      'Are you sure you want to mark as scanned?',
                                  subtitle:
                                      "We couldn't find any user with this email or name. You can create a new registration.",
                                  isSingeButtonPresent: false,
                                  onLeftButtonPressed: () {
                                    Navigator.pop(context);
                                  },
                                  onRightButtonPressed: () {
                                    BlocProvider.of<CustomerPurchasesBloc>(
                                            context)
                                        .add(TriggerMarkAsScanned(
                                            purchaseId: purchaseId,
                                            indexOfSelectedItem: index));
                                    Navigator.pop(context);
                                  },
                                  leftButtonText: AppStrings.btn_cancel,
                                  rightButtonText: AppStrings.btn_confirm);
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 7.h),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.r),
                                // Applies rounded corners
                                child: Container(
                                  height: 30.h,
                                  decoration: BoxDecoration(
                                    color: AppColors
                                        .colorSecondaryAccentAlternative,
                                    borderRadius: BorderRadius.circular(
                                        5.r), // Ensure rounding applies
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 2.h),
                                    child: IntrinsicWidth(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.colorSecondaryAccent,
                                          borderRadius: BorderRadius.circular(
                                              5.r), // Apply here too!
                                        ),
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  5.r), // Also apply to button
                                            ),
                                          ),
                                          onPressed: () {
                                            buildBottomSheetWithBodyText(
                                                context: context,
                                                title:
                                                    'Are you sure you want to mark as scanned?',
                                                subtitle:
                                                    "We couldn't find any user with this email or name. You can create a new registration.",
                                                isSingeButtonPresent: false,
                                                onLeftButtonPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                onRightButtonPressed: () {
                                                  BlocProvider.of<
                                                              CustomerPurchasesBloc>(
                                                          context)
                                                      .add(TriggerMarkAsScanned(
                                                          purchaseId:
                                                              purchaseId,
                                                          indexOfSelectedItem:
                                                              index));
                                                  Navigator.pop(context);
                                                },
                                                leftButtonText:
                                                    AppStrings.btn_cancel,
                                                rightButtonText:
                                                    AppStrings.btn_confirm);
                                          },
                                          child: Text(
                                            'Mark As Scanned',
                                            style: AppTextStyles.regularPrimary(
                                              isOutFit: false,
                                              color: AppColors
                                                  .colorPrimaryInverseText,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

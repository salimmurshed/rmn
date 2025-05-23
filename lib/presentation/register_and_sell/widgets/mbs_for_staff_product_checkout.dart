import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';
import '../../base/bloc/base_bloc.dart';
import '../bloc/register_and_sell_bloc.dart';

class MBSForStaffProductCheckOut extends StatefulWidget {
  MBSForStaffProductCheckOut({
    super.key,
    required this.registrations,
    required this.products,
    required this.totalSum,
    required this.eventTitle,
    required this.reduce,
    required this.increase,
    required this.removeItems,
    required this.applyCoupon,
    required this.removeCoupon,
    required this.couponAmount,
    required this.couponController,
    required this.couponFocusNode,
    required this.isActive,
    required this.isFix,
    required this.isLoeaderVisible,
    this.variant = '',
  });

  List<StaffCheckoutRegistrations> registrations;
  List<StaffCheckoutProducts> products;
  num totalSum;
  bool isActive;
  bool isLoeaderVisible;
  final String eventTitle;
   String variant;
  final void Function(int i) reduce;
  final void Function(int i) increase;
  final void Function() removeItems;
  final void Function() removeCoupon;
  final void Function(String code) applyCoupon;
  num? couponAmount;
  bool isFix;
  TextEditingController couponController;
  FocusNode couponFocusNode;

  @override
  State<MBSForStaffProductCheckOut> createState() =>
      _MBSForStaffProductCheckOutState();
}

class _MBSForStaffProductCheckOutState
    extends State<MBSForStaffProductCheckOut> {
  late num totalSum;
  late TextEditingController couponController;
  late FocusNode couponFocusNode;
  late bool isActive;

  @override
  initState() {
    totalSum = widget.totalSum;
    couponController = widget.couponController;
    couponFocusNode = widget.couponFocusNode;
    isActive = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterAndSellBloc, RegisterAndSellState>(
  listener: (context, state) {
    print('got result --> ${state.selectedProducts}');
  },
  child: BlocBuilder<RegisterAndSellBloc, RegisterAndSellState>(
      builder: (context, state) {
        debugPrint('${state.isFix}');
        return Container(

          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                      color: AppColors.colorTertiary,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    // child: state.isLoadingCoupon
                    //     ? CustomLoader(child: buildLayout(state))
                    //     :
                    child:buildLayout(state),
                  ),
                )
              ],
            ),
          ),

        );
      },
    ),
);
  }

  Column buildLayout(RegisterAndSellState state) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 15.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 100.w),
          child: Divider(
            thickness: 2.w,
            color: AppColors.colorPrimaryInverse,
          ),
        ),
        SizedBox(height: 15.h),
        Padding(
          padding:  EdgeInsets.only(bottom: 4.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    widget.eventTitle,
                    style: AppTextStyles.largeTitle(color: AppColors.colorPrimaryNeutralText),
                    maxLines: 1
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 1.w,
          color: AppColors.colorPrimaryDivider,
        ),

        Padding(
          padding:  EdgeInsets.only(bottom:10.h, top:8.h),
          child: Row(
            children: [
              Text(
                'Purchase Summary',
                style: AppTextStyles.largeTitle(),
              ),
              const Spacer(),
              if (widget.totalSum > 0)
                GestureDetector(
                  onTap: () {
                    widget.removeItems();
                    setState(() {
                      widget.registrations = [];
                      widget.products = [];
                      totalSum = 0;
                    });
                  },
                  child: Text(
                    'Remove all items',
                    style: AppTextStyles.smallTitle(isUnderlined: true),
                  ),
                ),
            ],
          ),
        ),
        ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            if (widget.registrations.isNotEmpty)
            Text(
              'Registrations',
              style: AppTextStyles.smallTitle(isOutFit: false),
            ),
            SizedBox(height: 6.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.registrations.isNotEmpty) ...[
                  for (int i = 0; i < widget.registrations.length; i++)
                    if(widget.registrations[i].quantity > 0)
                    SubjectContainer(
                      increase: (i, totalSum, q) {},
                      reduce: (i, totalSum, q) {},
                      totalSum: totalSum,
                      productName: widget.registrations[i].athleteName,
                      i: i,
                      checkOutType: CheckOutType.registration,
                      absolutePrice: widget.registrations[i].absolutePrice,
                      quantity: widget.registrations[i].quantity,
                      totalPrice: widget.registrations[i].totalPrice,
                      divisionName: StringManipulation.capitalizeFirstLetterOfEachWord(value: widget.registrations[i].divisionName),
                      styleName: StringManipulation.capitalizeFirstLetterOfEachWord(value: widget.registrations[i].styleName),
                      wc: widget.registrations[i].wc,
                    )
                ],
                // if (widget.registrations.isEmpty) ...[
                //   SizedBox(height: 6.h),
                //   Center(
                //     child: Text(
                //       'No registrations added',
                //       style: AppTextStyles.smallTitle(
                //           isOutFit: false,
                //           color: AppColors.colorPrimaryNeutralText),
                //     ),
                //   ),
                //   SizedBox(height: 6.h),
                // ],
                if (widget.registrations.isNotEmpty)
                Divider(
                  thickness: 1.w,
                  color: AppColors.colorPrimaryDivider,
                ),
                SizedBox(height: 8.h),
                if (widget.products.any((element) => element.quantity > 0))...
               [ Text(
                  'Products',
                  style: AppTextStyles.smallTitle(isOutFit: false),
                ),
                SizedBox(height: 6.h),],

                  for (int i = 0; i < widget.products.length; i++)
                    if(widget.products[i].quantity > 0)
                    ...[SubjectContainer(
                      isGiveaway: widget.products[i].isGiveAway,
                      giveAwayCounts: widget.products[i].giveAwayCounts,
                      totalSum: totalSum,
                      increase: (i, ts, q) {
                        widget.increase(i);
                        // widget.increase(i);
                        setState(() {
                          totalSum = ts;
                          widget.products[i].quantity = q;

                        });
                      },
                      reduce: (i, ts, q) {

                        widget.reduce(i);
                        setState(() {
                          totalSum = ts;
                          print('quantity: ${widget.products[i].productName}');
                          widget.products[i].quantity = q;
                          if(widget.products[i].quantity == 0){
                            widget.products.removeAt(i);
                          }
                        });
                      },
                      i: i,
                      productName: widget.products[i].variantName.isEmpty ?
                      widget.products[i].productName: '${widget.products[i].productName} (${widget.products[i].variantName})',
                      checkOutType: CheckOutType.products,
                      absolutePrice: widget.products[i].absolutePrice,
                      quantity: widget.products[i].quantity,
                      totalPrice: widget.products[i].totalPrice,
                    )],

                // else ...[
                //   SizedBox(height: 6.h),
                //   Center(
                //     child: Text(
                //       'No products added',
                //       style: AppTextStyles.smallTitle(
                //           isOutFit: false,
                //           color: AppColors.colorPrimaryNeutralText),
                //     ),
                //   ),
                //   SizedBox(height: 6.h),
                // ],
                if(widget.products.any((element) => element.quantity > 0))
                Divider(
                  thickness: 1.w,
                  color: AppColors.colorPrimaryDivider,
                ),
                Row(
                  children: [
                    Text(
                      'Total Sum',
                      style: AppTextStyles.smallTitle(),
                    ),
                    const Spacer(),
                    Text(
                      StringManipulation.addADollarSign(price: totalSum),
                      style: AppTextStyles.largeTitle(
                          color: AppColors.colorPrimaryAccent),
                    ),
                  ],
                ),
                Divider(
                  thickness: 1.w,
                  color: AppColors.colorPrimaryDivider,
                ),
                if (widget.couponAmount == null)
                  Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Apply Coupon',
                          style: AppTextStyles.smallTitle(),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: Dimensions.getScreenWidth() * 0.65,
                              // height: 40.h,
                              child: TextFormField(
                                controller: couponController,
                                focusNode: couponFocusNode,
                                style: AppTextStyles.textFormFieldELabelStyle(),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      isActive =
                                          widget.registrations.isNotEmpty ||
                                              widget.products.isNotEmpty;
                                    });
                                  } else {
                                    setState(() {
                                      isActive = false;
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.colorPrimary,
                                  hintText: 'Enter Coupon Code',
                                  hintStyle:
                                      AppTextStyles.textFormFieldEHintStyle(),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 5.h),
                                  errorStyle:
                                      AppTextStyles.textFormFieldErrorStyle(),
                                  enabledBorder: AppWidgetStyles
                                      .textFormFieldEnabledBorder(
                                          isDisabled: false),
                                  focusedBorder: AppWidgetStyles
                                      .textFormFieldFocusedBorder(
                                          isReadOnly: false),
                                  errorBorder: AppWidgetStyles
                                      .textFormFieldErrorBorder(),
                                  focusedErrorBorder: AppWidgetStyles
                                      .textFormFieldFocusedErrorBorder(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: GestureDetector(
                                onTap: (isActive &&
                                        (widget.registrations.isNotEmpty ||
                                            widget.products.isNotEmpty))
                                    ? () {
                                        widget
                                            .applyCoupon(couponController.text);
                                        setState(() {
                                          isActive = false;
                                        });
                                      }
                                    : () {},
                                child: Container(
                                  height: 36.h,
                                  margin: EdgeInsets.only(bottom: 3.h),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 6.h),
                                  decoration: BoxDecoration(
                                    color: (isActive &&
                                            (widget.registrations.isNotEmpty ||
                                                widget.products.isNotEmpty))
                                        ? AppColors.colorSecondaryAccent
                                        : AppColors.colorBlueOpaque,
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Apply',
                                      style: AppTextStyles.buttonTitle(),
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
                if (widget.couponAmount != null && state.couponError == null)
                  Container(
                    margin:
                    EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Applied Coupon',
                          style: AppTextStyles.smallTitle(),
                        ),
                        SizedBox(height: 10.h),
                        IntrinsicWidth(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 1.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.colorPrimaryAccent,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            padding:
                                EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    couponController.text,
                                    style: AppTextStyles.regularPrimary(
                                        color: AppColors.colorPrimaryInverseText),
                                  ),
                                  SizedBox(width: 10.w),
                                  GestureDetector(
                                    onTap: () {
                                      widget.removeCoupon();
                                      setState(() {
                                        couponController.clear();
                                        isActive = true;
                                      });
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: AppColors.colorPrimaryInverseText,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (state.couponError != null)
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(
                        state.couponError!,
                        style: AppTextStyles.textFormFieldErrorStyle(),
                      )),
                Divider(
                  thickness: 1.w,
                  color: AppColors.colorPrimaryDivider,
                ),
                SizedBox(height: 10.h),
                if (widget.couponAmount != null) ...[
                  Row(
                    children: [
                      Text(
                        'Coupon Discount',
                        style: AppTextStyles.smallTitle(),
                      ),
                      const Spacer(),
                      Text(
                        state.isFix
                            ? '-${widget.couponAmount}'
                            : '-${widget.couponAmount}%',
                        style: AppTextStyles.smallTitle(
                            color: AppColors.colorPrimaryNeutralText),
                      ),
                      const Spacer(),
                      Text(
                        state.isFix
                            ? '-${StringManipulation.addADollarSign(price: widget.couponAmount!)}'
                            : '-${StringManipulation.addADollarSign(price: totalSum * (widget.couponAmount! / 100))}',
                        style: AppTextStyles.smallTitle(),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                ],
                Row(
                  children: [
                    Text(
                      'Transaction Fees',
                      style: AppTextStyles.smallTitle(),
                    ),
                    const Spacer(),
                    Text(
                      '$globalTransactionFee%',
                      style: AppTextStyles.smallTitle(
                          color: AppColors.colorPrimaryNeutralText),
                    ),
                    const Spacer(),
                    Text(
                      StringManipulation.addADollarSign(
                          price: widget.couponAmount != null
                              ?(totalSum - widget.couponAmount!)* (globalTransactionFee / 100)
                                  :
                          globalTransactionFee * totalSum / 100),
                      style: AppTextStyles.smallTitle(),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: Dimensions.getScreenWidth() * 0.55,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: AppColors.colorPrimary,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: AppColors.colorPrimaryNeutral,
                            ),
                          ),
                          child: Center(
                            child: RichText(
                                text: TextSpan(
                              text: 'Total   ',
                              style: AppTextStyles.largeTitle(),
                              children: [
                                TextSpan(
                                  text: getAmount(
                                      isFixed: state.isFix,
                                      total: totalSum,
                                      couponAmount: widget.couponAmount),
                                  style: AppTextStyles.largeTitle(
                                      color: AppColors.colorPrimaryAccent),
                                ),
                              ],
                            )),
                          ),
                        )
                        // TextFormField(
                        //   controller: TextEditingController(),
                        //   focusNode: FocusNode(),
                        //   decoration: InputDecoration(filled: true,
                        //     fillColor: AppColors.colorPrimary,
                        //     hintText: 'Enter Coupon Code',
                        //     hintStyle: AppTextStyles.textFormFieldEHintStyle(),
                        //     contentPadding: EdgeInsets.symmetric(
                        //         horizontal: 10.w, vertical: 5.h),
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(10.r),
                        //     ),
                        //   ),
                        // ),
                        ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (widget.totalSum != 0) {
                            BlocProvider.of<RegisterAndSellBloc>(context)
                                .add(TriggerCheckOut(
                              couponCode: couponController.text,
                            ));
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 3.h),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color:(widget.totalSum != 0)?
                            AppColors.colorSecondaryAccent: AppColors.colorBlueOpaque,
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: Center(
                            child: widget.isLoeaderVisible ? CircularProgressIndicator(color: AppColors.colorPrimaryText,) : Text(
                              'Checkout',
                              style: AppTextStyles.buttonTitle(),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 15.h),
              ],
            )
          ],
        ),
      ],
    );
  }
}

class SubjectContainer extends StatefulWidget {
  SubjectContainer(
      {super.key,
      required this.checkOutType,
      this.divisionName,
      this.styleName,
      this.wc,
      required this.absolutePrice,
      required this.quantity,
      required this.totalPrice,
      required this.reduce,
      required this.totalSum,
      required this.increase,
      required this.i,
       this.isGiveaway = false,
       this.giveAwayCounts = 1,
      this.productName});

  final CheckOutType checkOutType;
  String? divisionName;
  String? styleName;
  String? wc;
  num absolutePrice;
  num quantity;
  num totalPrice;
  num totalSum;
  int giveAwayCounts;
  String? productName;
   bool isGiveaway;
  final int i;
  void Function(int i, num totalSum, num quantity) reduce;
  void Function(int i, num totalSum, num quantity) increase;

  @override
  State<SubjectContainer> createState() => _SubjectContainerState();
}

class _SubjectContainerState extends State<SubjectContainer> {
  // num quantity = 0;
  // num totalPrice = 0;
  // num absolutePrice = 0;

  @override
  void initState() {
    // quantity = widget.quantity;
    // totalPrice = widget.totalPrice;
    // absolutePrice = widget.absolutePrice;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('${widget.giveAwayCounts}');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
         // color: AppColors.colorPrimary,
          margin: EdgeInsets.only(right: 2.w),
          width: Dimensions.getScreenWidth() * 0.35,
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      '${widget.productName}',
                      style: AppTextStyles.normalPrimary(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              if (widget.checkOutType == CheckOutType.registration)
                Container(
                  margin: EdgeInsets.only(bottom: 5.h),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          '(${widget.divisionName}/${widget.styleName})',
                          style: AppTextStyles.normalNeutral(),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
        Container(
        //  color: AppColors.colorPrimaryAccent,
          margin: EdgeInsets.only(right: 2.w),
          width: Dimensions.getScreenWidth() * 0.4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  StringManipulation.addADollarSign(
                      price: widget.absolutePrice),
                  style: AppTextStyles.regularPrimary(
                      isOutFit: false,
                      isBold: true,
                      color: AppColors.colorPrimaryNeutralText),
                ),
              ),
              SizedBox(width:widget.checkOutType == CheckOutType.products? 10.w:20.w),
              if(widget.checkOutType == CheckOutType.products && widget.quantity > 0)
              GestureDetector(
                onTap: () {
                  if (widget.checkOutType == CheckOutType.products) {
                    if ( widget.quantity > 0) {
                      setState(() {
                        // quantity--;
                        widget.quantity= widget.quantity - 1;
                        widget.totalSum -= widget.absolutePrice;
                        widget.totalPrice =  widget.quantity *  widget.absolutePrice;
                      });
                    }

                    debugPrint('quantity: ${widget.productName}');
                    debugPrint('${widget.quantity} ${widget.totalSum} ${widget.i}');
                    widget.reduce(widget.i, widget.totalSum, widget.quantity);
                  }
                },
                child: SvgPicture.asset(
                  colorFilter: widget.checkOutType == CheckOutType.registration
                      ? const ColorFilter.mode(
                          Colors.transparent, BlendMode.srcIn)
                      : null,
                  AppAssets.icStaffMinus,
                  height: 18.h,
                  width:widget.checkOutType == CheckOutType.registration? 5.w:15.w,
                ),
              ),
              SizedBox(
                width: widget.checkOutType == CheckOutType.products?
                25.w: 30.w,
                child: Text(
                  widget.checkOutType == CheckOutType.products
                      ? widget.quantity.toString()
                      : '${widget.quantity}x',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subtitle(),
                ),
              ),
              if((widget.checkOutType == CheckOutType.products && !widget.isGiveaway)
              || (widget.checkOutType == CheckOutType.products && widget.isGiveaway && widget.quantity < widget.giveAwayCounts
                  )
              )
              GestureDetector(
                onTap: () {
                  if (widget.checkOutType == CheckOutType.products) {
                    setState(() {
                      // quantity++;
                      widget.totalSum +=  widget.absolutePrice;
                      widget.quantity = widget.quantity + 1;
                      widget.totalPrice = widget.quantity *  widget.absolutePrice;
                    });
                    widget.increase(widget.i, widget.totalSum, widget.quantity);
                  }
                },
                child: SvgPicture.asset(
                  colorFilter: widget.checkOutType == CheckOutType.registration
                      ? const ColorFilter.mode(
                          Colors.transparent, BlendMode.srcIn)
                      : null,
                  AppAssets.icStaffPlus,
                  height: 18.h,
                  width:widget.checkOutType == CheckOutType.registration? 5.w:15.w,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Text(
            StringManipulation.addADollarSign(price: widget.totalPrice),
            textAlign: TextAlign.end,
            style: AppTextStyles.subtitle(isOutFit: false),
          ),
        )
      ],
    );
  }
}

String getAmount(
    {required bool isFixed, required num total, required num? couponAmount}) {
  if (couponAmount == null) {
    return StringManipulation.addADollarSign(
        price: total + (globalTransactionFee * total / 100));
  } else {
    if (isFixed) {

      num amount = total - couponAmount + (globalTransactionFee * (total - couponAmount) / 100);
      print('amount: $amount');
      if (amount < 0) {
        return StringManipulation.addADollarSign(price: 0);
      } else {
        return StringManipulation.addADollarSign(price: amount);
      }
    } else {
      num amount = total -
          (total * couponAmount / 100) +
          (globalTransactionFee * (total-couponAmount) / 100);
      if (amount < 0) {
        return StringManipulation.addADollarSign(price: 0);
      } else {
        return StringManipulation.addADollarSign(price: amount);
      }
    }
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../imports/common.dart';
import '../../../imports/data.dart';

class UpdatedProductWidget extends StatefulWidget {
  final Products products;
  final BuildContext context;
  final void Function(String?) onChanged;
  final String? selectedValueProduct;
  final void Function(bool?) onMenuStateChange;
   GlobalKey<State<StatefulWidget>> dropDownKeyForProducts;
  final bool isProductDropDownOpened;
  final void Function() reduce;
  final void Function() increase;
  void Function()? add;
  bool isEmployeProduct;
  bool isInsideBottomSheet;

  UpdatedProductWidget({
    required this.products,
    required this.context,
    required this.onChanged,
    required this.selectedValueProduct,
    required this.onMenuStateChange,
    required this.dropDownKeyForProducts,
    required this.isProductDropDownOpened,
    required this.reduce,
    required this.increase,
    this.isEmployeProduct = false,
    this.isInsideBottomSheet = false,
    this.add,
    super.key,
  });

  @override
  _UpdatedProductWidgetState createState() => _UpdatedProductWidgetState();
}

class _UpdatedProductWidgetState extends State<UpdatedProductWidget> {
  ValueNotifier<bool> isCollapsedDes = ValueNotifier<bool>(true);
  ValueNotifier<bool> isCollapsedTitle = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: widget.isInsideBottomSheet?  AppColors.colorPrimary:
        AppColors.colorTertiary,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildProductImage(widget.products),
              if (widget.products.variants!.isNotEmpty)
                Container(
                  width: 100.w,
                  height: 30.h,
                  margin: EdgeInsets.only(top: 10.h),
                  child: buildVariantDropDownForSmallSpace(
                    context: context,
                    color: widget.isEmployeProduct
                        ? AppColors.colorPrimary
                        : AppColors.colorSecondary,
                    dropDownKey: widget.dropDownKeyForProducts,
                    isOpen:  widget.isProductDropDownOpened,
                    onChanged: widget.onChanged,
                    onMenuStateChange: widget.onMenuStateChange,
                    selectedValue: widget.selectedValueProduct,
                    variants: widget.products.variants!,
                  ),
                ),
            ],
          ),

        Container(
          color: Colors.transparent,
          width:
          widget.isInsideBottomSheet? Dimensions.getScreenWidth() *0.57:
            Dimensions.getScreenWidth() *0.62,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [  SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(widget.products.productDetails?.isGiveaway == true)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      const Spacer(),
                      Container(decoration: BoxDecoration(
                        color: AppColors.colorWarning,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                        child: Center(
                          child: Text(
                            'Giveaway',
                            style: AppTextStyles.subtitle(
                              isOutFit: false,
                              color: AppColors.colorPrimary,
                            ),
                          ),
                        ),
                      )
                    ]),
                  buildTitle(
                    products: widget.products,
                  ),
                  SizedBox(height: 5.h),
                  buildProductDescription(
                      widget.products, context, isCollapsedDes),
                  SizedBox(height: 5.h),
                  buildPriceAndQuantity(
                    isInsideBottomSheet: widget.isInsideBottomSheet,
                    add: widget.add,
                    products: widget.products,
                    reduce: widget.reduce,
                    increase: widget.increase,
                    iconName: AppAssets.icGoToLink,
                  ),
                ],
              ),
            ),],),
        )
        ],
      ),
    );
  }
}

Row buildTitle({
  required Products products,

}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        // color: Colors.transparent,
        // width: Dimensions.getScreenWidth() *0.6,
        child: Text(
          products.productDetails!.title!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.smallTitle(isOutFit: false),
        ),
      ),
      // if (products.variants!.isNotEmpty)
      //   Container(
      //     width: 100.w,
      //     height: 30.h,
      //     margin: EdgeInsets.only(bottom: 10.h),
      //     child: buildVariantDropDownForSmallSpace(
      //       context: context,
      //       color: isEmployeeProduct
      //           ? AppColors.colorPrimary
      //           : AppColors.colorSecondary,
      //       dropDownKey: dropDownKeyForProducts,
      //       isOpen: isProductDropDownOpened,
      //       onChanged: onChanged,
      //       onMenuStateChange: onMenuStateChange,
      //       selectedValue: selectedValueProduct,
      //       variants: products.variants!,
      //     ),
      //   ),
    ],
  );
}

Container buildProductDescription(
    Products products, BuildContext context, isCollapsedDesc) {
  return Container(
    margin: EdgeInsets.only(bottom: 10.h),
    width: Dimensions.getScreenWidth(),
    child: Wrap(
      children: [
        ReadMoreText(
          text: products.productDetails!.description!,
          style: AppTextStyles.normalNeutral(),
          onReadMoreTap: () {
            buildBottomSheetWithBodyText(
              context: context,
              title: products.productDetails?.title ??
                  AppStrings.global_empty_string,
              subtitle: products.productDetails!.description!,
              isSingeButtonPresent: true,
              singleButtonText: AppStrings.btn_ok,
              singleButtonFunction: () {
                Navigator.pop(context);
              },
              isSingleButtonColorFilled: true,
              onLeftButtonPressed: () {},
              onRightButtonPressed: () {},
            );
          },
        ),
      ],
    ),
  );
}

Widget buildProductImage(Products products) {
  return Center(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        height: 100.h,
        width: 100.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: AppColors.colorPrimary,
        ),
        child: products.productDetails!.image!.isEmpty
            ? SvgPicture.asset(fit: BoxFit.cover, AppAssets.icProfileAvatar)
            : CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: products.productDetails!.image!,
        ),
      ),
    ),
  );
}

Row buildPriceAndQuantity({
  String? iconName,
  void Function()? add,
  required Products products,
  required void Function() reduce,
  required void Function() increase,
  required bool isInsideBottomSheet,
}) {


    return Row(
    children: [
      Text(
        StringManipulation.addADollarSign(price: products.price!),
        style: AppTextStyles.subtitle(
            isOutFit: false,
            color: products.externalUrl != null
                ? AppColors.colorPrimaryInverseText
                : AppColors.colorPrimaryNeutralText),
      ),
      SizedBox(
        width: 10.w,
      ),
      if (products.externalUrl == null) ...[
        if (!products.productDetails!.isGiveaway!) ...[
          buildQuantityChangeButtons(
              isReduce: true,
              onTap: reduce),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            //padding: EdgeInsets.symmetric(horizontal: 5.w),
            width:  30.w,
            height: 25.h,
            decoration: BoxDecoration(
                color:  Colors.transparent,
                borderRadius: BorderRadius.circular(5.r)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Text(
                  products.quantity.toString(),
                  style: AppTextStyles.subtitle(),
                ),
              ),
            ),
          ),
          buildQuantityChangeButtons(
              isReduce: false,
              onTap: increase),
        ]
        else ...[
            if(products.isMaxGiveawayAdded != null)...[
              Expanded(
                flex: 2,
                child: Text(
                  products.productDetails?.giveAwayType == 'athlete-bracket'?
                      'This giveaway is only available for the athlete-bracket(s) combination':
                      products.productDetails?.giveAwayType == 'athlete'?
                      'This giveaway is only available for athlete(s)':
                  AppStrings.eventDetail_products_giveAwayUnavailable_warning,
                  maxLines: 10,
                  style: AppTextStyles.normalNeutral(isBold: true,),
                ),
              )]
            else...[
              buildQuantityChangeButtons(
                isBottomSheetNeededProds: isInsideBottomSheet,
                isReduce: true,
                onTap: reduce),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                width:  30.w,
                height: 25.h,
                decoration: BoxDecoration(
                    color: Colors.transparent,

                    borderRadius: BorderRadius.circular(5.r)),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Text(
                      products.quantity.toString(),
                      style: AppTextStyles.subtitle(),
                    ),
                  ),
                ),
              ),
                if(products.quantity == 0 || products.quantity! < products.giveAwayCounts!)
                buildQuantityChangeButtons(
                    isReduce: false,
                    onTap: increase),]

        ],
        SizedBox(
          width: 10.w,
        ),
        if(!products.productDetails!.isGiveaway! || (products.productDetails!.isGiveaway! && products.isMaxGiveawayAdded == null))
          const Spacer(),

          if (products.productDetails!.isGiveaway!) ...[
            GestureDetector(
              onTap: products.quantity == 0 ||
                  (products.isMaxGiveawayAdded != null)
                  ? () {}
                  : add,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: products.quantity == 0 ||
                      (products.isMaxGiveawayAdded != null)
                      ? AppColors.colorBlueOpaque
                      : AppColors.colorSecondaryAccent,
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Center(
                  child: Text(
                    AppStrings.btn_add,
                    style: AppTextStyles.buttonTitle(),
                  ),
                ),
              ),
            )
          ]
          else ...[
            GestureDetector(
              onTap: products.quantity == 0 ? () {

              } : add,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: products.productDetails!.isGiveaway! ?
                  (products.isGiveawayAdded != null  ? AppColors.colorBlueOpaque
                      : AppColors.colorSecondaryAccent )
                      :
                  (products.quantity == 0
                      ? AppColors.colorBlueOpaque
                      : AppColors.colorSecondaryAccent),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Center(
                  child: Text(
                    AppStrings.btn_add,
                    style: AppTextStyles.buttonTitle(),
                  ),
                ),
              ),
            )
          ]

      ]
      else ...[
        const Spacer(),
        buildBtn(
          hasHeight: false,
          iconName: iconName,
          onTap: () {
            launchUrlString(products.externalUrl ?? '');
          },
          btnLabel: AppStrings.eventDetailsView_buyTicket_button_title,
          isColorFilledButton: true,
          isActive: true,
        )
      ]
    ],
  );
}

GestureDetector buildQuantityChangeButtons(
    {void Function()? onTap,
      bool isEmployeeProduct = false,
      bool isBottomSheetNeededProds = false,
      required bool isReduce}) {
  return GestureDetector(
    onTap: isBottomSheetNeededProds ? (){} :onTap,
    child: Container(
      width: 24.w,
      height:24.h,
      decoration: BoxDecoration(
          color:  AppColors.colorPrimary,
          borderRadius: BorderRadius.circular(5.r)),
      child: isBottomSheetNeededProds ? SizedBox():
      Center(
        child: Icon(isReduce ? Icons.remove : Icons.add,
            color: AppColors.colorPrimaryNeutral, size: 20.sp),
      ),
    ),
  );
}

class ReadMoreText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final int maxLines;
  final VoidCallback onReadMoreTap;

  const ReadMoreText({
    super.key,
    required this.text,
    required this.style,
    this.maxLines = 2,
    required this.onReadMoreTap,
  });

  @override
  _ReadMoreTextState createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final textSpan = TextSpan(
          text: widget.text,
          style: widget.style,
        );
        final textPainter = TextPainter(
          text: textSpan,
          maxLines: 2,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(maxWidth: constraints.maxWidth);

        if (textPainter.didExceedMaxLines) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: widget.text.substring(
                          0,
                          textPainter
                              .getPositionForOffset(Offset(constraints.maxWidth,
                              textPainter.size.height))
                              .offset),
                      style: widget.style,
                    ),
                    TextSpan(
                      text: '...read more',
                      style: AppTextStyles.normalPrimary(
                          color: AppColors.colorPrimaryAccent),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          widget.onReadMoreTap();
                        },
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Text(
            widget.text,
            style: widget.style,
          );
        }
      },
    );
  }
}

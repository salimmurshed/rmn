import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';
import '../../../root_app.dart';
import '../../purchase/widgets/build_products_widget.dart';

class ProductsTab extends StatefulWidget {
  final List<Products> products;
  bool isShorten;
   ProductsTab({required this.products, this.isShorten = false, super.key});

  @override
  _ProductsTabState createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab> {
  ValueNotifier<bool> isCollapsedDes = ValueNotifier<bool>(true);
  ScrollController scrollController = ScrollController();
  // @override
  // void initState() {
  //   scrollController.addListener(() {
  //     if (scrollController.position.userScrollDirection ==
  //         ScrollDirection.reverse) {
  //       setState(() {
  //         widget.isShorten = true;
  //       });
  //     } else {
  //       setState(() {
  //         widget.isShorten = false;
  //        scrollController.animateTo(0,
  //             duration:  const Duration(milliseconds: 200), curve: Curves.ease);
  //       });
  //     }
  //   });
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      controller: scrollController,
      physics: widget.isShorten && widget.products.length > 3
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemBuilder: (context, index) {
        return Container(
          //height:isCollapsedDes.value? (isTablet? 140.h:120.h): null,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: AppColors.colorTertiary,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: SizedBox(
                    height: 100.h,
                    width: 120.w,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.products[index].productDetails!.image!,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              widget.products[index].productDetails!.title!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.subtitle(isOutFit: false),
                            ),
                          ),
                        ],
                      ),
                      buildProductDescription(widget.products[index], context, isCollapsedDes),
                      Container(
                        margin: EdgeInsets.only(top: 12.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              StringManipulation.addADollarSign(
                                  price: widget.products[index].price!),
                              style: AppTextStyles.buttonTitle(),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRouteNames.routePurchaseRegs,
                                  arguments: CouponModules.tickets,
                                );
                              },
                              child: Container(
                                width: 70.w,
                                decoration: BoxDecoration(
                                  color: AppColors.colorSecondaryAccent,
                                  borderRadius: BorderRadius.circular(3.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 2.h),
                                child: Center(
                                  child: Text(
                                    AppStrings.btn_buy,
                                    style: AppTextStyles.buttonTitle(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 10.h,
        );
      },
      itemCount: widget.products.length,
    );
  }
}
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';

class AwardsTab extends StatefulWidget {
  final List<Award> awards;
  bool isShorten;

  AwardsTab({super.key, required this.awards, this.isShorten = false});

  @override
  _AwardsTabState createState() => _AwardsTabState();
}

class _AwardsTabState extends State<AwardsTab> {
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
  //         scrollController.animateTo(0,
  //             duration: const Duration(milliseconds: 200), curve: Curves.ease);
  //       });
  //     }
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return
      widget.awards.isNotEmpty?
      GridView.custom(
        shrinkWrap: true,
        physics: widget.isShorten && widget.awards.length > 4
            ? const AlwaysScrollableScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        controller: scrollController,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.h,
          childAspectRatio: 0.82,
        ),
        childrenDelegate: SliverChildBuilderDelegate(
              (context, index) {
            return GestureDetector(
              onTap: () {
                if (widget.awards[index].description!.isNotEmpty) {
                  buildBottomSheetWithBodyText(
                    context: context,
                    title: widget.awards[index].title!,
                    subtitle: widget.awards[index].description!,
                    isSingeButtonPresent: true,
                    isSingleButtonColorFilled: true,
                    singleButtonText: AppStrings.btn_ok,
                    singleButtonFunction: () {
                      Navigator.of(context).pop();
                    },
                    onLeftButtonPressed: () {},
                    onRightButtonPressed: () {},
                  );
                }
              },
              child: IntrinsicHeight(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.colorTertiary,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 10.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          height: 70.h,
                          width: double.infinity,
                          imageUrl: widget.awards[index].image!,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        widget.awards[index].title!,
                        style: AppTextStyles.subtitle(
                            isOutFit: false, isBold: true),
                      ),
                      SizedBox(height: 5.h),
                      if (widget.awards[index].description!.isNotEmpty)
                        Expanded(
                          flex: 3,
                          child: Text(
                            widget.awards[index].description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.normalNeutral(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
          childCount: widget.awards.length,
        ),
      ):
      Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
        child: Column(
          children: [
            SizedBox(height: Dimensions.getScreenHeight() * 0.15),
            Center(
              child: Text(
                AppStrings.eventDetailView_awardsTab_empty,
                style: AppTextStyles.smallTitleForEmptyList(),
              ),
            ),
          ],
        ),
      );
    //   Column(
    //   children: [
    //     if (widget.awards.isNotEmpty)
    //       Flexible(
    //         child: GridView.custom(
    //           shrinkWrap: true,
    //           physics: widget.isShorten && widget.awards.length > 4
    //               ? const AlwaysScrollableScrollPhysics()
    //               : const NeverScrollableScrollPhysics(),
    //           controller: scrollController,
    //           padding: EdgeInsets.symmetric(horizontal: 20.w),
    //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //             crossAxisCount: 2,
    //             crossAxisSpacing: 10.w,
    //             mainAxisSpacing: 10.h,
    //             childAspectRatio: 0.8,
    //           ),
    //           childrenDelegate: SliverChildBuilderDelegate(
    //             (context, index) {
    //               return GestureDetector(
    //                 onTap: () {
    //                   if (widget.awards[index].description!.isNotEmpty) {
    //                     buildBottomSheetWithBodyText(
    //                       context: context,
    //                       title: widget.awards[index].title!,
    //                       subtitle: widget.awards[index].description!,
    //                       isSingeButtonPresent: true,
    //                       isSingleButtonColorFilled: true,
    //                       singleButtonText: AppStrings.btn_ok,
    //                       singleButtonFunction: () {
    //                         Navigator.of(context).pop();
    //                       },
    //                       onLeftButtonPressed: () {},
    //                       onRightButtonPressed: () {},
    //                     );
    //                   }
    //                 },
    //                 child: IntrinsicHeight(
    //                   child: Container(
    //                     decoration: BoxDecoration(
    //                       color: AppColors.colorTertiary,
    //                       borderRadius: BorderRadius.circular(10.r),
    //                     ),
    //                     padding: EdgeInsets.symmetric(
    //                         horizontal: 10.w, vertical: 10.h),
    //                     child: Column(
    //                       mainAxisAlignment: MainAxisAlignment.start,
    //                       children: [
    //                         ClipRRect(
    //                           borderRadius: BorderRadius.circular(10.r),
    //                           child: CachedNetworkImage(
    //                             fit: BoxFit.cover,
    //                             height: 70.h,
    //                             width: double.infinity,
    //                             imageUrl: widget.awards[index].image!,
    //                           ),
    //                         ),
    //                         SizedBox(height: 10.h),
    //                         Text(
    //                           widget.awards[index].title!,
    //                           style: AppTextStyles.subtitle(
    //                               isOutFit: false, isBold: true),
    //                         ),
    //                         SizedBox(height: 5.h),
    //                         if (widget.awards[index].description!.isNotEmpty)
    //                           Expanded(
    //                             flex: 3,
    //                             child: Text(
    //                               widget.awards[index].description!,
    //                               maxLines: 3,
    //                               overflow: TextOverflow.ellipsis,
    //                               style: AppTextStyles.normalNeutral(),
    //                             ),
    //                           ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               );
    //             },
    //             childCount: widget.awards.length,
    //           ),
    //         ),
    //       ),
    //     if (widget.awards.isEmpty)
    //       Padding(
    //         padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
    //         child: Column(
    //           children: [
    //             SizedBox(height: Dimensions.getScreenHeight() * 0.15),
    //             Center(
    //               child: Text(
    //                 AppStrings.eventDetailView_awardsTab_empty,
    //                 style: AppTextStyles.smallTitleForEmptyList(),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //   ],
    // );
  }
}


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../imports/common.dart';

//
// Widget buildNestedScrollViewForImageBehind({
//   required Widget body,
//   required String coverImage,
//   bool isInfoForEventDetail = true,
//   required String title,
//   String desc = AppStrings.global_empty_string,
//   EventStatus eventStatus = EventStatus.none,
//   bool isScrollable = true,
//   String date = AppStrings.global_empty_string,
//   String location = AppStrings.global_empty_string,
//   required String subtitle,
// }) {
//   return NestedScrollView(
//     scrollBehavior: isScrollable
//         ? null
//         : const MaterialScrollBehavior().copyWith(
//             physics: const NeverScrollableScrollPhysics(),
//             dragDevices: {}, // no drag devices
//           ),
//     headerSliverBuilder: (context, innerBoxIsScrolled) {
//       return [
//         SliverAppBar(
//           backgroundColor: AppColors.colorPrimary,
//           leading: Container(),
//           // expandedHeight: isInfoForEventDetail ? 200.h : 150.h,
//           flexibleSpace: FlexibleSpaceBar(
//             background: Stack(
//               fit: StackFit.loose,
//               children: [
//                 coverImage.isNotEmpty
//                     ? ClipRRect(
//                         borderRadius: BorderRadius.circular(10.r),
//                         child: SizedBox(
//                           height: 170.h,
//                           child: CachedNetworkImage(
//                             imageUrl: coverImage,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       )
//                     : const Center(),
//                 Positioned(
//                   top:  Dimensions.getScreenHeight() * 0.17,
//                   right: 0,
//                   left: 0,
//                   child: Container(
//                     //height: isInfoForEventDetail? null: Dimensions.getScreenHeight() * 0.2,
//                     decoration: BoxDecoration(
//                       color: AppColors.colorBlackOpaque,
//                       borderRadius: BorderRadius.circular(10.r),
//                     ),
//                     margin: EdgeInsets.only(
//                         left: 20.w, right: 20.h, top: 10.h, bottom: 10.h),
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(
//                           width: Dimensions.getScreenWidth(),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               if (eventStatus != EventStatus.none)
//                                 Container(
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 8.w, vertical: 2.h),
//                                   margin: EdgeInsets.only(right: 10.w),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(3.r),
//                                     color: eventStatus == EventStatus.live
//                                         ? AppColors.colorPrimaryAccent
//                                         :
//                                     eventStatus == EventStatus.upcoming
//                                             ? AppColors.colorGreenAccent
//                                             : AppColors.colorSecondaryAccent,
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       StringManipulation.capitalizeTheInitial(
//                                           value: eventStatus.name),
//                                       style:
//                                           AppTextStyles.componentLabels(isRegular: false)
//                                       ,
//                                     ),
//                                   ),
//                                 ),
//                               Expanded(
//                                 flex: 2,
//                                 child: Text(
//                                   title,
//                                   style: AppTextStyles.smallTitle(),
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               // Expanded(
//                               //   flex: 2,
//                               //   child:     ReadMoreText(
//                               //     title,
//                               //     style: AppTextStyles.smallTitle(),
//                               //     trimMode: TrimMode.Line,
//                               //     trimLines: 1,
//                               //     colorClickableText: AppColors.colorPrimaryAccent,
//                               //     trimCollapsedText: ' read more',
//                               //     trimExpandedText: '...read less',
//                               //     moreStyle: AppTextStyles.normalPrimary(
//                               //         color: AppColors.colorPrimaryAccent),
//                               //     lessStyle: AppTextStyles.normalPrimary(
//                               //         color: AppColors.colorPrimaryAccent),
//                               //   ),
//                               //
//                               // ),
//                             ],
//                           ),
//                         ),
//
//                           SizedBox(height: 10.h),
//                           Text(
//                             subtitle,
//                             style: AppTextStyles.normalNeutral(),),
//
//                           // Container(
//                           //   margin: EdgeInsets.only(top: 20.h, bottom: 5.h),
//                           //   child: ReadMoreText(
//                           //     subtitle,
//                           //     style: AppTextStyles.normalNeutral(),
//                           //     trimMode: TrimMode.Line,
//                           //     trimLines: 2,
//                           //     colorClickableText: AppColors.colorPrimaryAccent,
//                           //     trimCollapsedText: ' read more',
//                           //     trimExpandedText: '...read less',
//                           //     moreStyle: AppTextStyles.normalPrimary(
//                           //         color: AppColors.colorPrimaryAccent),
//                           //     lessStyle: AppTextStyles.normalPrimary(
//                           //         color: AppColors.colorPrimaryAccent),
//                           //   ),
//                           // ),
//                        // ],
//
//                           SizedBox(height: 15.h),
//
//                         buildSvgWithInfo(text: date, isDate: true),
//                         buildSvgWithInfo(text: location, isDate: false),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           pinned: false,
//           floating: true,
//         ),
//       ];
//     },
//     body: body,
//   );
// }
//
Widget buildSvgWithInfo({required String text, required bool isDate}) {
  return Container(
    margin: EdgeInsets.only(top: 5.h),
    child: Row(
      children: [
        isDate
            ? SvgPicture.asset(
                AppAssets.icCalendar,
                height: 12.h,
                width: 12.w,
                colorFilter: ColorFilter.mode(
                    AppColors.colorPrimaryAccent, BlendMode.srcIn),
              )
            : SvgPicture.asset(
                AppAssets.icLocation,
                height: 10.h,
                width: 10.w,
                colorFilter: ColorFilter.mode(
                    AppColors.colorPrimaryAccent, BlendMode.srcIn),
              ),
        SizedBox(width: 2.w),
        Flexible(
          child: Text(text,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style:
                  AppTextStyles.normalPrimary(isOutfit: true, isBold: false)),
        ),
      ],
    ),
  );
}

class DynamicSliverAppBar extends StatefulWidget {
  final Widget body;
  final String coverImage;
  final bool isInfoForEventDetail;
  final String title;
  final String desc;
  final EventStatus eventStatus;
  final bool isScrollable;
  String date;
  final String location;
  final String subtitle;
  bool fromDivisionList;
  Widget? purchaseMetrics;
  bool isLoading;
  String tabTitle;
  Widget? tabElements;
  bool isNestedScrollable;
  ScrollController? scrollController;

  DynamicSliverAppBar({
    required this.body,
    this.purchaseMetrics,
    this.tabElements,
    this.scrollController,
    this.isNestedScrollable = true,
    this.tabTitle = AppStrings.global_empty_string,
    required this.isLoading,
    required this.coverImage,
    this.isInfoForEventDetail = true,
    required this.title,
    this.desc = AppStrings.global_empty_string,
    this.eventStatus = EventStatus.none,
    this.isScrollable = true,
    this.date = AppStrings.global_empty_string,
    this.fromDivisionList = false,
    this.location = AppStrings.global_empty_string,
    required this.subtitle,
    super.key,
  });

  @override
  _DynamicSliverAppBarState createState() => _DynamicSliverAppBarState();
}

class _DynamicSliverAppBarState extends State<DynamicSliverAppBar> {
  final GlobalKey _contentKey = GlobalKey();
  double _contentHeight = 30.h; // Default expandedHeight

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateContentHeight());
  }

  void _updateContentHeight() {
    final RenderBox? renderBox =
        _contentKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _contentHeight = widget.purchaseMetrics != null
            ? renderBox.size.height + 30.h
            : (widget.fromDivisionList
                ? renderBox.size.height + 30.h
                : renderBox.size.height + 20.h); // Add image height
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      floatHeaderSlivers: true,
      controller: widget.scrollController,
      scrollBehavior: widget.isScrollable
          ? null
          : const MaterialScrollBehavior().copyWith(
              physics: const NeverScrollableScrollPhysics(),
              dragDevices: {},
            ),
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            excludeHeaderSemantics: true,
            backgroundColor: AppColors.colorPrimary,
            forceMaterialTransparency: true,
            leading: Container(),
            expandedHeight:
                // widget.tabElements != null ? 80.h :
                _contentHeight,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.loose,
                children: [
                  widget.coverImage.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(3.r),
                          child: SizedBox(
                            height: 170.h,
                            child: CachedNetworkImage(
                              imageUrl: widget.coverImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : const Center(),
                  Positioned(
                    top: Dimensions.getScreenHeight() * 0.17,
                    right: 0,
                    left: 0,
                    child: IntrinsicHeight(
                      key: _contentKey,
                      child: Container(
                        margin: EdgeInsets.only(
                            // left: 20.w,
                            // right: 20.h,
                            bottom: 10.h),
                        // padding: EdgeInsets.symmetric(
                        //     horizontal: 10.w, vertical: 10.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.colorBlackOpaque,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              margin: EdgeInsets.only(
                                top: 10.h,
                                left: 20.w,
                                right: 20.h,
                              ),
                              padding: EdgeInsets.only(
                                left: 10.w,
                                right: 10.w,
                                top: 10.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (widget.eventStatus !=
                                          EventStatus.none)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.w, vertical: 2.h),
                                          margin: EdgeInsets.only(right: 10.w),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3.r),
                                            color: widget.eventStatus ==
                                                    EventStatus.live
                                                ? AppColors.colorPrimaryAccent
                                                : widget.eventStatus ==
                                                        EventStatus.upcoming
                                                    ? AppColors.colorGreenAccent
                                                    : AppColors
                                                        .colorSecondaryAccent,
                                          ),
                                          child: Center(
                                            child: Text(
                                              StringManipulation
                                                  .capitalizeTheInitial(
                                                      value: widget
                                                          .eventStatus.name),
                                              style: TextStyle(
                                                color: AppColors
                                                    .colorPrimaryInverseText,
                                                fontFamily:
                                                    AppFontFamilies.squada,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          widget.title,
                                          style: AppTextStyles.smallTitle(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (widget.subtitle.isNotEmpty) ...[
                                    SizedBox(height: 10.h),
                                    Text(
                                      widget.subtitle,
                                      style: AppTextStyles.normalNeutral(),
                                    ),
                                    SizedBox(height: 15.h)
                                  ],
                                  if (!widget.isLoading)
                                    buildSvgWithInfo(
                                        text: widget.date, isDate: true),
                                  if (!widget.isLoading)
                                    buildSvgWithInfo(
                                        text: widget.location, isDate: false),
                                  if (widget.purchaseMetrics == null)
                                    SizedBox(height: 20.h),
                                  if (widget.fromDivisionList)
                                    Text(
                                      AppStrings
                                          .eventWiseAthleteRegistration_divisionList_title,
                                      style: AppTextStyles.largeTitle(),
                                    ),
                                  if (widget.purchaseMetrics != null)
                                    widget.purchaseMetrics!
                                ],
                              ),
                            ),
                            if (widget.tabElements != null) widget.tabElements!,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pinned: true,
            floating: false,
            // forceMaterialTransparency: true,
          ),
        ];
      },
      body: widget.body,
    );
  }
}

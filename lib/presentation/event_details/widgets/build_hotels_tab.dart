import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';

class HotelsTab extends StatefulWidget {
  final List<Hotels> hotels;
  bool isShorten;

  HotelsTab({super.key, required this.hotels, this.isShorten = false});

  @override
  _HotelsTabState createState() => _HotelsTabState();
}

class _HotelsTabState extends State<HotelsTab> {
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
    return ListView.separated(
      shrinkWrap: true,
      controller: scrollController,
      physics: widget.isShorten
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemBuilder: (context, index) {
        return Container(
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
                      imageUrl: widget.hotels[index].image!,
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
                              widget.hotels[index].title!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.subtitle(isOutFit: false),
                            ),
                          ),
                        ],
                      ),
                      buildInfoSection(
                        link: widget.hotels[index].link!,
                        context: context,
                        address: widget.hotels[index].address!,
                        contactNumber: widget.hotels[index].contactNumber!,
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
      itemCount: widget.hotels.length,
    );
  }
}

Widget buildInfoSection({
  required BuildContext context,
  required String address,
  required String link,
  required String contactNumber,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      buildSvgWithInformation(text: address, isAddress: true),
      buildSvgWithInformation(text: contactNumber, isAddress: false),
      Container(
        margin: EdgeInsets.only(top: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Spacer(),
            GestureDetector(
              onTap: () async {
                var url = link;
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                } else {
                  throw 'Could not launch $url';
                }
              },
              child:Container(
                width: 70.w,
                decoration: BoxDecoration(
                  color: AppColors.colorSecondaryAccent,
                  borderRadius: BorderRadius.circular(3.r),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: 10.w, vertical: 2.h),
                child: Center(
                  child: Text(
                    AppStrings.btn_visit,
                    style: AppTextStyles.buttonTitle(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget buildSvgWithInformation({
  required String text,
  required bool isAddress,
}) {
  return SizedBox(
    width: Dimensions.getScreenWidth(),
    child: Row(
      children: [
        SvgPicture.asset(
          isAddress ? AppAssets.icLocation : AppAssets.icCall,
          colorFilter:
              ColorFilter.mode(AppColors.colorPrimaryAccent, BlendMode.srcIn),
          height: 14.h,
          width: 14.h,
        ),
        SizedBox(
          width: 4.w,
        ),
        Expanded(
          child: Text(
            text,
            maxLines: 10,
            style: AppTextStyles.normalNeutral(isSquada: false),
          ),
          // ReadMoreText(
          //   text,
          //   style: AppTextStyles.normalPrimary(
          //     color: AppColors.colorPrimaryNeutralText,
          //   ),
          //   trimMode: TrimMode.Line,
          //   trimLines: 2,
          //   colorClickableText: AppColors.colorPrimaryAccent,
          //   trimCollapsedText: 'read more',
          //   trimExpandedText: '...read less',
          //   moreStyle: AppTextStyles.normalPrimary(
          //     color: AppColors.colorPrimaryAccent,
          //   ),
          //   lessStyle: AppTextStyles.normalPrimary(
          //     color: AppColors.colorPrimaryAccent,
          //   ),
          // ),
        ),
      ],
    ),
  );
}

SizedBox buildImageContainer({
  required BuildContext context,
  required String imageUrl,
}) {
  return SizedBox(
    height: 150.h,
    width: Dimensions.getScreenWidth() * 0.35,
    child: CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: imageUrl,
    ),
  );
}

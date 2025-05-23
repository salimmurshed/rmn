import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/imports/common.dart';

class EventHeaderView extends StatelessWidget {
  final String imageUrl;
  final String location;
  final String date;
  final String title;
  final VoidCallback? onBackTap;

  const EventHeaderView({
    super.key,
    required this.imageUrl,
    required this.location,
    required this.date,
    required this.title,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.h,
      child: Stack(
        children: [
          Container(
            color: AppColors.colorSuccess,
            height: 160.h, // Enough space for the image and header
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              height: 120.h,
              width: double.infinity,
              fit: BoxFit.fill
            ),
          ),
          Positioned(top: 0,left: 0,right: 0, bottom: 0,child: buildOpaqueLayer()),
          buildTitleAndDate(title,'$location | $date')
        ],
      ),
    );
  }
}
Container buildOpaqueLayer() {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black26,
          Colors.black.withOpacity(0.6),
          Colors.black, // End with dark at the bottom
        ],
      ),
    ),
  );
}
Positioned buildTitleAndDate(String title, String date) {
  return Positioned(
    top: 45.5.h,
    left: 75.w,
    child: SizedBox(
      width: Dimensions.getScreenWidth() - 100.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.smallTitle(),
            maxLines: 2,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(date,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.start,
              style: AppTextStyles.normalNeutral(isBold: true)),
        ],
      ),
    ),
  );
}
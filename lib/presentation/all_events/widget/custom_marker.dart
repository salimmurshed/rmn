import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rmnevents/root_app.dart';

import '../../../imports/common.dart';

class CustomMarker extends StatelessWidget {
  const CustomMarker(
      {super.key,
      required this.imageUrl,
      required this.eventName,
      required this.eventInDays,
      required this.eventStatus,});

  final String imageUrl;
  final String eventName;
  final String eventInDays;
  final EventStatus eventStatus;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isTablet? 55.h: 45.h,
      width: 100.w,
      child: CustomPaint(
        painter: CustomMarkerBody(eventStatus: eventStatus),
        child: Padding(
          padding: EdgeInsets.all(5.r),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 5.h),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.r),
                      child: Opacity(
                        opacity: 0.7,
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          width: 40.w,
                          height:isTablet? 35.h: 30.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  if(eventStatus == EventStatus.live)
                    SvgPicture.asset(
                     AppAssets.icLiveMapIcon,
                      width: 8.w,
                      height: 8.h,
                    ),
                  if(eventStatus != EventStatus.live)
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 5.h),
                      child: Center(
                        child: Text(
                          eventInDays,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.regularForMap(
                              color: AppColors.colorPrimaryInverseText),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 3.w, bottom: 5.h),
                  child: Text(
                    eventName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.regularForMap(
                        color: AppColors.colorPrimaryInverseText),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomMarkerBody extends CustomPainter {
  final EventStatus eventStatus;

  const CustomMarkerBody({required this.eventStatus});@override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = eventStatus == EventStatus.live
          ? const Color(0xFFD50000).withOpacity(1.0)
          : const Color(0xff050505).withOpacity(1.0);

    final path = Path()
      ..moveTo(5, 0) // Slightly rounded top-left corner
      ..lineTo(size.width - 5, 0) // Slightly rounded top-right corner
      ..quadraticBezierTo(size.width, 0, size.width, 5)
      ..lineTo(size.width, size.height * 0.7916667)
      ..cubicTo(
          size.width,
          size.height * 0.8491958,
          size.width * 0.9878973,
          size.height * 0.8958333,
          size.width * 0.9729730,
          size.height * 0.8958333)
      ..lineTo(size.width * 0.5246043, size.height * 0.8958333)
      ..lineTo(size.width * 0.4972973, size.height)
      ..lineTo(size.width * 0.4699903, size.height * 0.8958333)
      ..lineTo(size.width * 0.02702703, size.height * 0.8958333)
      ..cubicTo(size.width * 0.01210043, size.height * 0.8958333, 0,
          size.height * 0.8491958, 0, size.height * 0.7916667)
      ..lineTo(0, size.height * 0.1041667)
      ..quadraticBezierTo(0, 0, 5, 0) // Slightly rounded bottom-left corner
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';
import '../../../imports/common.dart';

class FossItemWidget extends StatefulWidget {
  final String title, licence, description;

  const FossItemWidget(
      {super.key,
      required this.title,
      required this.licence,
      required this.description});

  @override
  State<FossItemWidget> createState() => _FossItemWidgetState();
}

class _FossItemWidgetState extends State<FossItemWidget> {


  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.colorTertiary,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.generalRadius)),
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(widget.title,
                      style: AppTextStyles.smallTitle(
                          color: AppColors.colorPrimaryAccent)),
                ),
              ],
            ),
            SizedBox(height: 5.h),
            ReadMoreText(
              widget.licence,
              style: AppTextStyles.subtitle(),
              trimMode: TrimMode.Line,
              trimLines: 1,
              colorClickableText: AppColors.colorPrimaryAccent,
              trimCollapsedText: '...read more',
              trimExpandedText: '...read less',
              moreStyle: AppTextStyles.normalPrimary(
                  color: AppColors.colorPrimaryAccent),
            ),
            SizedBox(height: 5.h),
            ReadMoreText(
              widget.description,
              style: AppTextStyles.normalNeutral(),
              trimMode: TrimMode.Line,
              trimLines: 1,
              colorClickableText: AppColors.colorPrimaryAccent,
              trimCollapsedText: '...read more',
              trimExpandedText: '...read less',
              moreStyle: AppTextStyles.normalPrimary(
                  color: AppColors.colorPrimaryAccent),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/presentation/qr_scan_view/widgets/pop_up_detail_space.dart';
import 'package:rmnevents/presentation/qr_scan_view/widgets/pop_up_scan_title_space.dart';
import 'package:rmnevents/presentation/qr_scan_view/widgets/scan_again_button.dart';
import 'package:rmnevents/presentation/qr_scan_view/widgets/stacked_decline_button.dart';
import 'package:rmnevents/presentation/qr_scan_view/widgets/subject_title.dart';
import '../../../imports/common.dart';
import '../bloc/qr_scan_bloc.dart';
import 'already_scanned_warning.dart';
import 'confirm_button.dart';

class StaffPopup extends StatefulWidget {
  const StaffPopup({super.key,
    required this.scanType,
    required this.title,
    required this.imageUrl,
    required this.productTitle,
    required this.metric1,
    required this.metric2,
    required this.metric3,
    required this.buyerName,
    required this.buyerDate,
    required this.scannerName,
    required this.scannerDate,
    required this.decline,
    required this.confirm,
    required this.scanAgain,
    required this.isFailure});

  final ScanType scanType;
  final String title;
  final bool isFailure;
  final String imageUrl;
  final String productTitle;
  final String metric1, metric2, metric3;
  final String buyerName, buyerDate;
  final String scannerName, scannerDate;
  final void Function() decline;
  final void Function() confirm;
  final void Function() scanAgain;

  @override
  State<StaffPopup> createState() => _StaffPopupState();
}

class _StaffPopupState extends State<StaffPopup> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QrScanBloc, QrScanState>(
      builder: (context, state) {
        debugPrint('StaffPopup: ${state.scanLoading}');
        return state.scanLoading?CustomLoader(
          topMarginHeight: Dimensions.getScreenHeight() * 0.3,
            isTopMarginNeeded: true,
            isForSingleWidget: true,
            child: buildLayout()):
          buildLayout();
      },
    );
  }

  BackdropFilter buildLayout() {
    return BackdropFilter(
        blendMode: BlendMode.srcOver,
        filter: ImageFilter.blur(sigmaX: 17.w, sigmaY: 17.h),
        child: Wrap(
          runAlignment: WrapAlignment.end,
          children: [
            Container(
              height: Dimensions.getScreenHeight() * 0.15,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15.w),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.colorTertiary,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PopUpScanTitleSpace(
                      scanType: widget.scanType, title: widget.title),
                  SizedBox(height: 10.h),
                  PopUpDetailSpace(
                    scanType: widget.scanType,
                    imageUrl: widget.imageUrl,
                    productTitle: widget.productTitle,
                    metric1: widget.metric1,
                    metric2: widget.metric2,
                    metric3: widget.metric3,
                  ),
                  SizedBox(height: 5.h),
                  Divider(
                    color: AppColors.colorPrimaryNeutral,
                    thickness: 0.5,
                  ),
                  SizedBox(height: 5.h),
                  const SubjectTitle(),
                  buyerScannerSpace(),
                ],
              ),
            ),
            Container(
              height: 20.h,
            ),
            if (widget.isFailure) const AlreadyScannedWarning(),
            if (!widget.isFailure) declineConfirmButtons(),
            ScanAgainButton(scanAgain: widget.scanAgain),
            Container(
              height: Dimensions.getScreenHeight() * 0.2,
            ),
          ],
        ),
      );
  }

  Container declineConfirmButtons() {
    return Container(
      height: 40.h,
      width: double.infinity,
      margin: EdgeInsets.only(top: 20.h, left: 18.w, right: 18.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StackedDeclineButton(decline: widget.decline),
          SizedBox(width: 10.w),
          ConfirmButton(confirm: widget.confirm),
        ],
      ),
    );
  }

  Material buyerScannerSpace() {
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          if (widget.buyerName.isEmpty) ...deletedBuyer(),
          if (widget.buyerName.isNotEmpty) ...existingBuyer(),
          if (widget.scannerName.isNotEmpty) ...scanner()
        ],
      ),
    );
  }

  List<Widget> scanner() {
    return [
      Text(AppStrings.qrCode_popUp_itemScanner_prefix_text,
          style: AppTextStyles.normalNeutral(fontWeight: FontWeight.w400)),
      SizedBox(height: 4.h),
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: widget.scannerName,
              style: AppTextStyles.normalPrimary(fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text: ' | ',
              style: AppTextStyles.normalNeutral(),
            ),
            TextSpan(
              text: widget.scannerDate,
              style: AppTextStyles.normalNeutral(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> existingBuyer() {
    return [
      Text(AppStrings.qrCode_popUp_itemBuyer_prefix_text,
          style: AppTextStyles.normalNeutral(fontWeight: FontWeight.w400)),
      SizedBox(height: 4.h),
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: widget.buyerName,
              style: AppTextStyles.normalPrimary(fontWeight: FontWeight.w500),
            ),
            TextSpan(
              text: ' | ',
              style: AppTextStyles.normalNeutral(),
            ),
            TextSpan(
              text: widget.buyerDate,
              style: AppTextStyles.normalNeutral(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      SizedBox(height: 16.h),
    ];
  }

  List<Widget> deletedBuyer() {
    return [
      Text(AppStrings.qrCode_popUp_itemBuyer_prefix_text,
          style: AppTextStyles.normalNeutral(fontWeight: FontWeight.w400)),
      SizedBox(height: 4.h),
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: AppStrings.qrCode_popUp_deletedUser,
              style: AppTextStyles.normalPrimary(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      SizedBox(height: 16.h),
    ];
  }
}




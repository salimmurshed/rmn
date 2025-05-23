import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:rmnevents/imports/common.dart';
import 'package:rmnevents/presentation/qr_scan_view/bloc/qr_scan_bloc.dart';

import '../../purchase/widgets/build_products_widget.dart';

class QRScanView extends StatefulWidget {
  const QRScanView({super.key});

  @override
  State<QRScanView> createState() => _QRScanViewState();
}

class _QRScanViewState extends State<QRScanView> {
  @override
  void reassemble() {
    super.reassemble();
    BlocProvider.of<QrScanBloc>(context).add(TriggerQRCameraReassemble());
  }

  bool isCameraResumed = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<QrScanBloc, QrScanState>(
      listener: (context, state) {
        if (state.message.isNotEmpty) {
          buildCustomToast(msg: state.message, isFailure: state.isFailure);
          isCameraResumed = true;
        }
        isCameraResumed = state.isCameraResumed;
      },
      child: BlocBuilder<QrScanBloc, QrScanState>(
        builder: (context, state) {
          return Scaffold(
            extendBody: true,
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    AppAssets.imgQrBg,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                    top: 50.h,
                    left: 15.w,
                    right: 0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            Navigator.pop(
                              context,
                            );
                          },
                          child: Container(
                            width: 50.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.appBarToolRadius),
                              color: AppColors.colorSecondary,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                  height: 18.h,
                                  AppAssets.icAppbarBackButton,
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15.w,
                        ),
                        Text(
                          AppStrings.staff_qrView_title,
                          style: AppTextStyles.extraLargeTitle(),
                        )
                      ],
                    )),
                Positioned(
                  top: Dimensions.getScreenHeight() * 0.3,
                  left: Dimensions.getScreenWidth() * 0.14,
                 // right: Dimensions.getScreenWidth() * 0.14,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(Dimensions.generalRadius),
                    child: SizedBox(
                      height: Dimensions.getScreenWidth() * 0.72,
                      width: Dimensions.getScreenWidth() * 0.72,
                      child: QRView(
                        key: state.qrKey,
                        onQRViewCreated: (controller) {
                          BlocProvider.of<QrScanBloc>(context)
                              .add(TriggerCreationOfQRView(controller));
                        },
                        overlay: QrScannerOverlayShape(
                          cutOutHeight: Dimensions.getScreenWidth() * 0.72,
                          cutOutWidth: Dimensions.getScreenWidth() * 0.72,
                          borderColor: Colors.white,
                          borderRadius: 10,
                          borderLength: 30,
                          borderWidth: 10,
                        ),
                        onPermissionSet: (ctrl, p) =>
                            _onPermissionSet(context, ctrl, p),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: Dimensions.getScreenHeight() * 0.3 + Dimensions.getScreenWidth() * 0.72 + 16.sp,
                  left: Dimensions.getScreenWidth() * 0.2,
                  right: Dimensions.getScreenWidth() * 0.2,
                  child: Text(
                    'Align QR code within the frame to scan',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.subtitle(),
                  ),
                )
              ],
            ),
          );
          // customScaffold(
          //   customAppBar: CustomAppBar(
          //       title: AppStrings.staff_qrView_title, isLeadingPresent: true),
          //   hasForm: false,
          //   formOrColumnInsideSingleChildScrollView: null,
          //   anyWidgetWithoutSingleChildScrollView: state.isLoading
          //       ? CustomLoader(child: Container())
          //       : Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: [
          //             const Spacer(),
          //             Align(
          //               alignment: Alignment.center,
          //               child: Stack(
          //                 children: [
          //                   ClipRRect(
          //                     borderRadius: BorderRadius.circular(
          //                         Dimensions.generalRadius),
          //                     child: SizedBox(
          //                       height: 180.h,
          //                       width: 200.w,
          //                       child: QRView(
          //                         key: state.qrKey,
          //                         onQRViewCreated: (controller) {
          //                           BlocProvider.of<QrScanBloc>(context).add(
          //                               TriggerCreationOfQRView(controller));
          //                         },
          //                         overlay: QrScannerOverlayShape(
          //                             borderColor: Colors.red,
          //                             borderRadius: 10,
          //                             borderLength: 30,
          //                             borderWidth: 10,
          //                             cutOutSize: 300.w),
          //                         onPermissionSet: (ctrl, p) =>
          //                             _onPermissionSet(context, ctrl, p),
          //                       ),
          //                     ),
          //                   ),
          //                   if (!state.isCameraResumed)
          //                     Positioned.fill(
          //                       child: Container(
          //                         height: 180.h,
          //                         width: 200.w,
          //                         decoration: BoxDecoration(
          //                             borderRadius: BorderRadius.circular(
          //                                 Dimensions.generalRadius),
          //                             color: AppColors.colorPrimary
          //                                 .withOpacity(0.7)),
          //                       ),
          //                     ),
          //                 ],
          //               ),
          //             ),
          //             if (!isCameraResumed) ...[
          //               SizedBox(height: Dimensions.getScreenWidth() * 0.4),
          //               Padding(
          //                 padding: EdgeInsets.symmetric(horizontal: 15.w),
          //                 child: buildCustomLargeFooterBtn(
          //                     onTap: state.isScannedButtonActive
          //                         ? () async {
          //                             BlocProvider.of<QrScanBloc>(context)
          //                                 .add(TriggerQRSanResume());
          //                           }
          //                         : () {},
          //                     btnLabel:
          //                         AppStrings.staff_qrView_scanAgain_btn_text,
          //                     hasKeyBoardOpened: false,
          //                     isActive: state.isScannedButtonActive,
          //                     isColorFilledButton: true),
          //               ),
          //             ],
          //             const Spacer(
          //               flex: 2,
          //             )
          //           ],
          //         ));
        },
      ),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('no Permission')),
      // );
    }
  }
}

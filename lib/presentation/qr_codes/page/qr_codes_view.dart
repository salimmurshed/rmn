import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/imports/common.dart';
import 'package:rmnevents/presentation/purchased_products/widgets/build_card_container.dart';
import 'package:rmnevents/presentation/purchased_products/widgets/build_price_information.dart';
import 'package:rmnevents/presentation/qr_codes/bloc/qr_codes_bloc.dart';

import '../../../imports/data.dart';
import '../../../root_app.dart';
import '../widgets/build_purchase_information.dart';
import '../widgets/build_qr_code.dart';

class QrCodesView extends StatefulWidget {
  final List<Registrations> registrations;

  const QrCodesView({super.key, required this.registrations});

  @override
  State<QrCodesView> createState() => _QrCodesViewState();
}

class _QrCodesViewState extends State<QrCodesView> {
  @override
  void initState() {
    BlocProvider.of<QrCodesBloc>(context)
        .add(TriggerCheckForQRCodeStatus(registrations: widget.registrations));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QrCodesBloc, QRCodesWithInitialState>(
      builder: (context, state) {
        return customScaffold(
          customAppBar: CustomAppBar(
              title: appBarTitle.isEmpty ? AppStrings.myPurchases_title: appBarTitle, isLeadingPresent: true),
          hasForm: false,
          formOrColumnInsideSingleChildScrollView: null,
          anyWidgetWithoutSingleChildScrollView: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.screenHorizontalGap,
            ),
            child: state.isLoading
                ? CustomLoader(child: buildQRCodesViewLayout(state))
                : buildQRCodesViewLayout(state),
          ),
        );
      },
    );
  }

  Column buildQRCodesViewLayout(QRCodesWithInitialState state) {
    return Column(
      children: [
        Flexible(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return buildCardContainer(isBig: false, children: [
                    SizedBox(
                      width: 5.w,
                    ),
                    GestureDetector(
                        onTap: () async {
                          await showDialog(
                              context: navigatorKey.currentState!.context,
                              builder: (_) => customQRDialog(
                                  GlobalHandlers.convertQRCodeToImage(
                                      qrCode:
                                          state.registration[index].qrCode!),
                                  state.registration[index].qrCodeStatus!));
                        },
                        child: buildQrCode(
                            qrCode: state.registration[index].qrCode!,
                            qrCodeStatus:
                                state.registration[index].qrCodeStatus!)),
                    buildPurchaseInformation(
                      context: context,
                      price: state.registration[index].price!,
                      weight: state.registration[index].weightClass!.weight
                          .toString(),
                      style: state.registration[index].division!.style!,
                      divisionTitle: state.registration[index].division!.title!,
                      divisionType:
                          state.registration[index].division!.divisionType!,
                    ),
                  ]);
                },
                separatorBuilder: (context, index) {
                  return Container(
                    height: 20,
                  );
                },
                itemCount: state.registration.length))
      ],
    );
  }
}

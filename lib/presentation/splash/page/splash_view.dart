import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rmnevents/presentation/splash/bloc/splash_bloc.dart';

import '../../../imports/common.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {

    BlocProvider.of<SplashBloc>(context).add(TriggerSplashTiming());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<SplashBloc, SplashWithInitialState>(
      listener: (context, state) {
      },
      child: BlocBuilder<SplashBloc, SplashWithInitialState>(
        builder: (context, state) {
          return Scaffold(
              backgroundColor: AppColors.colorPrimary,
              body: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: Dimensions.getScreenHeight() * 0.3),
                      child: SvgPicture.asset(
                        AppAssets.icLogo,
                        width: 250.w,
                        height: 70.h,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                  Container(
                    color: AppColors.colorPrimary,
                    child: Image.asset(
                      AppAssets.imgSplash,
                      width: 450.w,
                      height: 400.h,
                      alignment: Alignment.bottomCenter,
                    ),
                  ),
                ],
              ));
        },
      ),
    );
  }
}

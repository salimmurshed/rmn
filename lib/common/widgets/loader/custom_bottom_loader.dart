import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';

class CustomBottomLoader extends StatefulWidget {
  const CustomBottomLoader({

    super.key, required this.child,
  });
  final Widget child;

  @override
  State<CustomBottomLoader> createState() => _CustomBottomLoaderState();
}

class _CustomBottomLoaderState extends State<CustomBottomLoader>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animationController!.repeat();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: AppColors.colorPrimary,
            height: 50.h,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                CircularProgressIndicator(
                  backgroundColor: AppColors.colorPrimaryInverse,
                  valueColor: animationController!.drive(ColorTween(
                      begin: AppColors.colorPrimaryAccent,
                      end: AppColors.colorSecondaryAccent)),
                  //AlwaysStoppedAnimation(ColorManager.secondaryBlue),
                  color: AppColors.colorPrimaryAccent,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}



class CustomBottomLoaderWithoutStack extends StatefulWidget {
  const CustomBottomLoaderWithoutStack({

    super.key, required this.child,
  });
  final Widget child;

  @override
  _CustomBottomLoaderWithoutStack createState() => _CustomBottomLoaderWithoutStack();
}

class _CustomBottomLoaderWithoutStack extends State<CustomBottomLoader>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animationController!.repeat();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      backgroundColor: AppColors.colorPrimaryInverse,
      valueColor: animationController!.drive(ColorTween(
          begin: AppColors.colorPrimaryAccent,
          end: AppColors.colorSecondaryAccent)),
      //AlwaysStoppedAnimation(ColorManager.secondaryBlue),
      color: AppColors.colorPrimaryAccent,
    );
  }


}


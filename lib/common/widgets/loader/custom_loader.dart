import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../imports/common.dart';

class CustomLoader extends StatefulWidget {
   CustomLoader({super.key,

     this.topMarginHeight,
     required this.child, this.isForSingleWidget =false,  this.isTopMarginNeeded = false});
  final Widget child;
   bool isTopMarginNeeded;
   bool isForSingleWidget;
   double? topMarginHeight;

  @override
  State<CustomLoader> createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  @override
  void initState() {
    animationController =
        AnimationController(duration: const Duration(seconds: 10), vsync: this);
    animationController!.repeat();
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: widget.isForSingleWidget? 2:
          0, sigmaY: widget.isForSingleWidget? 2:
      0),
      child: Stack(
        children: [
          widget.child,
          Container(
            margin: widget.isTopMarginNeeded? EdgeInsets.only(
              top: widget.topMarginHeight ?? Dimensions.getScreenHeight() * 0.2
            ): null,
          width: double.infinity,
          height:widget.isForSingleWidget? null: double.infinity,
          color: Colors.grey.withOpacity(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                backgroundColor: AppColors.colorPrimaryInverse,
                valueColor: animationController!.drive(ColorTween(
                    begin: AppColors.colorPrimaryAccent,
                    end: AppColors
                        .colorSecondaryAccent)),
                color: AppColors.colorPrimaryAccent,
              ),

            ],
          ),
                    )
        ],
      ),
    );
  }
}
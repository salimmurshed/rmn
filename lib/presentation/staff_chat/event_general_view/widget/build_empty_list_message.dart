
import 'package:flutter/cupertino.dart';
import 'package:rmnevents/imports/common.dart';

Widget buildEmptyListMessage({String? description}){
  return Container(
    child: Column(
      children: [
        Image.asset(AppAssets.imgNoChatFound, height: 127, width: 127,),
        Text('No Conversation Found', style: AppTextStyles.smallTitle(isLinedThrough: false, isOutFit:  false)),
        Text(description ?? '', style: AppTextStyles.largeTitleWithoutLingThrough(color: AppColors.colorPrimaryNeutral),)
      ],
    ),
  );
}
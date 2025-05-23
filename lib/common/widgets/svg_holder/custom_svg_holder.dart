import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

SvgPicture buildCustomSvgHolder({required String imageUrl}) {
  return SvgPicture.asset(imageUrl,
      fit: BoxFit.cover);
}
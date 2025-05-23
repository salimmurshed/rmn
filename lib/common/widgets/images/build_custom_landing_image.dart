import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../imports/common.dart';

CachedNetworkImage buildCustomLandingImage({
  required double? height,
  required double? width,
  required String imageUrl,
}) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    height: height,
    width: width,
    fit: BoxFit.cover,
    placeholder: (context, url) => Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.colorPrimaryAccent,
            AppColors.colorSecondaryAccent,
            AppColors.colorPrimaryInverseText
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
    errorWidget: (context, url, error) => const Icon(Icons.error),
  );
}

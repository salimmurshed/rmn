import 'package:flutter/material.dart';

import '../../../imports/common.dart';

Widget buildProductPrice({required num totalAmount}) {
  return Text(
    StringManipulation.addADollarSign(price: totalAmount),
    textAlign: TextAlign.end,
    overflow: TextOverflow.ellipsis,
    style: AppTextStyles.buttonTitle(),
  );
}
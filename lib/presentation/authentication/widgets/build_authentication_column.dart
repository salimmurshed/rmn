import 'package:flutter/material.dart';

import '../../../imports/common.dart';

Widget buildAuthenticationColumn(
    {required Authentication authenticationType,
    required List<Widget> children,
    required GlobalKey<FormState> formKey}) {
  return Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        );
}

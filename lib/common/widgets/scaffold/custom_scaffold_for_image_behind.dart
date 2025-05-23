import 'package:flutter/material.dart';

import '../../../imports/common.dart';
import '../../../root_app.dart';

Widget customScaffoldForImageBehind({
  required PreferredSizeWidget? appBar,
  bool hasForm = false,
  required Widget body,
  List<Widget>? persistentFooterButtons,
  Widget? floatingActionButton,
}) {
  return GestureDetector(
    onTap: () {
      if (hasForm) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    },
    child: Theme(
      data: Theme.of(navigatorKey.currentContext!).copyWith(
        dividerColor: Colors.transparent,
        dividerTheme: DividerTheme.of(navigatorKey.currentContext!).copyWith(
          color: Colors.transparent,
        ),
      ),
      child: Scaffold(
        persistentFooterButtons: persistentFooterButtons,
        floatingActionButton: floatingActionButton,
        backgroundColor: AppColors.colorPrimary,
        appBar: appBar,
        extendBodyBehindAppBar: true, // Extend body behind AppBar
        body: body,
      ),
    ),
  );
}

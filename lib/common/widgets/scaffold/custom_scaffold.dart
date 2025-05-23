import 'package:flutter/material.dart';
import 'package:rmnevents/root_app.dart';
import '../../../imports/common.dart';

Widget customScaffold(
    {CustomAppBar? customAppBar,
    bool isPaddingOn = true,
    required bool hasForm,
     bool resizeToAvoidBottomInset = true,
    List<Widget>? persistentFooterButtons,
    Widget? floatingActionButton,
    ScrollController? scrollController,
    required Widget? formOrColumnInsideSingleChildScrollView,
    required Widget? anyWidgetWithoutSingleChildScrollView}) {
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
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          appBar: customAppBar,
          floatingActionButton: floatingActionButton,
          persistentFooterButtons: persistentFooterButtons,
          backgroundColor: AppColors.colorPrimary,
          body: formOrColumnInsideSingleChildScrollView != null &&
                  anyWidgetWithoutSingleChildScrollView == null
              ? customSingleChildScrollView(
                  isPaddingOn: isPaddingOn,
                  column: formOrColumnInsideSingleChildScrollView)
              : anyWidgetWithoutSingleChildScrollView != null &&
                      formOrColumnInsideSingleChildScrollView == null &&
                      isPaddingOn
                  ? customScreenPadding(
                      anyWidgetWithoutSingleChildScrollView:
                          anyWidgetWithoutSingleChildScrollView)
                  : anyWidgetWithoutSingleChildScrollView != null &&
                          formOrColumnInsideSingleChildScrollView == null &&
                          !isPaddingOn
                      ? anyWidgetWithoutSingleChildScrollView
                      : Container()),
    ),
  );
}

Padding customScreenPadding({
  required Widget anyWidgetWithoutSingleChildScrollView,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(
        horizontal: Dimensions.screenHorizontalGap,
        vertical: Dimensions.screenVerticalGap),
    child: anyWidgetWithoutSingleChildScrollView,
  );
}

SingleChildScrollView customSingleChildScrollView(
    {required Widget column,
    bool isPaddingOn = true,
    ScrollController? scrollController}) {
  return SingleChildScrollView(
    controller: scrollController,
    padding: isPaddingOn
        ? EdgeInsets.only(
            left: Dimensions.screenHorizontalGap,
            right: Dimensions.screenHorizontalGap,
            top: Dimensions.screenVerticalGap,
            bottom: MediaQuery.of(navigatorKey.currentContext!)
                .viewInsets
                .bottom, // Adjust for keyboard
          )
        : EdgeInsets.zero,
    child: column,
  );
}

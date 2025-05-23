import 'package:flutter/material.dart';


buildCustomShowModalBottomSheetParent<T>({required BuildContext ctx,
  required bool isNavigationRequired,
  bool isDismissible = true,
  bool isEnableDrag = true,
  void Function()? navigatorFunction,
  required Widget child}) {
  return isNavigationRequired
      ? showModalBottomSheet(
    context: ctx,
    isDismissible: isDismissible,useSafeArea: false,
    enableDrag: isEnableDrag,
    constraints: const BoxConstraints(
      maxWidth: double.infinity,
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
        ),
        child:  isDismissible && isEnableDrag ?
      child : PopScope(
      canPop: false,
        child: child,
      ),
      );
    },
  ).then((value) {
    if(navigatorFunction != null) {
      navigatorFunction();
    }
  })
      : showModalBottomSheet(
    context: ctx,
    isDismissible: isDismissible,
    useSafeArea: false,
    enableDrag: isEnableDrag,
    isScrollControlled: true,
    constraints: const BoxConstraints(
      maxWidth: double.infinity,
    ),
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
        ),
        child: isDismissible && isEnableDrag ?
        child : PopScope(
         canPop: false,
          child: child,
        ),
      );
    },
  );
}

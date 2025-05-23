import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rmnevents/presentation/my_athletes/bloc/my_athletes_bloc.dart';

import '../../../imports/common.dart';

buildBottomSheetForRequestAccess(
    {required BuildContext context,
      required String radioButtonValue,
      required void Function() onTapViewAccess,
      required void Function() onTapCoachAccess,
      required void Function() onTapOwnerAccess,
      required void Function() onTapForRequest,
      required String? userStatus,
      required String athleteName,
    }) {
  if (userStatus == null) {
    radioButtonValue = '1';
    print('radioButtonValue: $radioButtonValue');
    BlocProvider.of<MyAthletesBloc>(context).add(TriggerRadioButtonValue(
      value: radioButtonValue,
    ));
    buildBottomSheetWithBodyRadioButtonList(
      athleteName: athleteName,
      onTapViewAccess: onTapViewAccess,
      onTapCoachAccess: onTapCoachAccess,
      onTapOwnerAccess: onTapOwnerAccess,
      context: context,
      title: AppStrings.myAthletes_bottomSheet_accessRequest_title,
      groupValue: int.parse(radioButtonValue),
      subtitle: AppStrings.myAthletes_bottomSheet_accessRequest_subtitle,
      onTapForRequest: onTapForRequest,
      requestTypeCombination: RequestTypeCombination.all,
    );
  } else {
    if (userStatus == TypeOfAccess.coach.name) {
      radioButtonValue = '2';
      print('radioButtonValue: $radioButtonValue');
      BlocProvider.of<MyAthletesBloc>(context).add(TriggerRadioButtonValue(
        value: radioButtonValue,
      ));
      buildBottomSheetWithBodyRadioButtonList(
        athleteName: athleteName,
        onTapViewAccess: onTapViewAccess,
        onTapCoachAccess: onTapCoachAccess,
        onTapOwnerAccess: onTapOwnerAccess,
        context: context,
        title: AppStrings.myAthletes_bottomSheet_accessRequest_title,
        groupValue: int.parse(radioButtonValue),
        subtitle: AppStrings.myAthletes_bottomSheet_accessRequest_subtitle,
        onTapForRequest: onTapForRequest,
        requestTypeCombination: RequestTypeCombination.ownerOnly,
      );
    }
    if (userStatus == TypeOfAccess.view.name) {
      radioButtonValue = '3';
      print('radioButtonValue: $radioButtonValue');
      BlocProvider.of<MyAthletesBloc>(context).add(TriggerRadioButtonValue(
        value: radioButtonValue,
      ));
      buildBottomSheetWithBodyRadioButtonList(
        athleteName: athleteName,
        onTapViewAccess: onTapViewAccess,
        onTapCoachAccess: onTapCoachAccess,
        onTapOwnerAccess: onTapOwnerAccess,
        context: context,
        title: AppStrings.myAthletes_bottomSheet_accessRequest_title,
        groupValue: int.parse(radioButtonValue),
        subtitle: AppStrings.myAthletes_bottomSheet_accessRequest_subtitle,
        onTapForRequest: onTapForRequest,
        requestTypeCombination: RequestTypeCombination.coachOwner,
      );
    }

  }
}
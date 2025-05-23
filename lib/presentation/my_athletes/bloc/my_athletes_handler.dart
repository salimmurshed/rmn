import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';
import 'my_athletes_bloc.dart';

class MyAthletesHandler {
  static void emitInitialState(
      {required Emitter<MyAthletesWithInitialState> emit,
      required MyAthletesWithInitialState state}) {
    emit(state.copyWith(
        isRefreshRequired: true,
        isFailure: false,
        isLoading: false,
        message: AppStrings.global_empty_string));
  }

  static void emitWithLoader(
      {required Emitter<MyAthletesWithInitialState> emit,
      required MyAthletesWithInitialState state}) {
    emit(state.copyWith(
        isRefreshRequired: true,
        isFailure: false,
        isLoading: true,
        message: AppStrings.global_empty_string));
  }

  static bool isScrollPermissible(
      {required ScrollController scrollController,
      required int page,
      required int totalPage}) {

    return (scrollController.position.pixels > scrollController.position.maxScrollExtent) &&
        (totalPage > page);
  }

  static bool isSupportTeamContactAvailable({required Athlete athlete}) {
    if (DateTime.now().difference(athlete.requestData!.createdAt!).inDays > 7) {
      return true;
    } else {
      return false;
    }
  }
}

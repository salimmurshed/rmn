import 'package:bloc/bloc.dart';
import 'package:rmnevents/common/resources/app_strings.dart';

import '../../../data/models/response_models/season_passes_response_model.dart';
import '../../../imports/data.dart';
import 'buy_season_passes_bloc.dart';

class BuySeasonHandlers {
  static void emitInitialState(
      {required Emitter<SeasonPassesWithInitialState> emit,
        required SeasonPassesWithInitialState state}) {
    emit(state.copyWith(
        isLoadingSeasonPasses: true,
        isFailure: false,
        message: AppStrings.global_empty_string));
  }

  static void emitRefreshState(
      {required Emitter<SeasonPassesWithInitialState> emit,
        required SeasonPassesWithInitialState state}) {
    emit(state.copyWith(
        isRefreshRequired: true,
        isFailure: false,
        message: AppStrings.global_empty_string));
  }

  static bool checkIfWeCanProceedToPurchase({required List<Athlete> athletes}) {
    bool canWeProceedToPurchase = false;
    for (Athlete athlete in athletes) {
      if (athlete.membership != null) {
        canWeProceedToPurchase = true;
        break;
      }
    }
    return canWeProceedToPurchase;
  }

  static List<Athlete> collectSelectedAthletes(
      {required List<Athlete> athletes}) {
    List<Athlete> selectedAthletes = [];
    for (Athlete athlete in athletes) {
      if (athlete.membership != null) {
        selectedAthletes.add(athlete);
      }
    }
    return selectedAthletes;
  }

  static List<Athlete> updateAthleteSeasonParameter({required List<
      SeasonPass> seasons, required String assetsUrl, required List<
      Athlete> athletes}) {
    List<Athlete> athleteList = athletes;

    for (int i = 0; i < athleteList.length; i++) {
      athleteList[i].profileImage = '$assetsUrl${athleteList[i].profileImage}';
      athleteList[i].selectedSeasonPassTitle = AppStrings.global_empty_string;
      athleteList[i].temporarySeasonPassTitle = AppStrings.global_empty_string;
      athleteList[i].availableSeasonPasses = [];
      for(SeasonPass season in seasons){
        athleteList[i].availableSeasonPasses!.add(season.title!);
      }

      athleteList[i].isSelected = false;
      athleteList[i].isInList = true;
    }
    return athleteList;
  }
}

part of 'create_edit_profile_bloc.dart';

@immutable
sealed class CreateEditProfileEvent extends Equatable {
  const CreateEditProfileEvent();

  @override
  List<Object?> get props => [];
}

class TriggerInitializationOfAthleteProfileFields
    extends CreateEditProfileEvent {
  final CreateProfileTypes createProfileTypes;

  const TriggerInitializationOfAthleteProfileFields({
    required this.createProfileTypes,
  });

  @override
  List<Object?> get props => [createProfileTypes];
}

class TriggerInitializationCreateProfileFields extends CreateEditProfileEvent {
  final CreateProfileTypes createProfileTypes;
  String? athleteId;
   TriggerInitializationCreateProfileFields(
      {required this.createProfileTypes,
        this.athleteId
      });

  @override
  List<Object?> get props => [createProfileTypes, athleteId];
}

class TriggerCreateAthleteLocally extends CreateEditProfileEvent {}
class TriggerEditAthleteLocally extends CreateEditProfileEvent {
  final String athleteId;
  const TriggerEditAthleteLocally({required this.athleteId});
  @override
  List<Object?> get props => [athleteId];
}

class TriggerForAddAthleteMBSTappedOutside extends CreateEditProfileEvent {}

class TriggerOpenCalendar extends CreateEditProfileEvent {
  final AgeType ageType;

  const TriggerOpenCalendar({required this.ageType});

  @override
  List<Object?> get props => [ageType];
}

class TriggerImageEvent extends CreateEditProfileEvent {
  final bool isCamera;

  const TriggerImageEvent({required this.isCamera});

  @override
  List<Object?> get props => [isCamera];
}

class TriggerEnableInteractionWithContactField extends CreateEditProfileEvent {}

class TriggerCheckZipCodeField extends CreateEditProfileEvent {}

class TriggerCheckForAddressValidity extends CreateEditProfileEvent {}

class TriggerGenderSelection extends CreateEditProfileEvent {
  final int index;

  const TriggerGenderSelection({required this.index});

  @override
  List<Object?> get props => [index];
}

class TriggerFetchPlaceDetails extends CreateEditProfileEvent {
  final Prediction prediction;
  bool isFromRegisterAndSell;

  TriggerFetchPlaceDetails(
      {required this.prediction, this.isFromRegisterAndSell = false});

  @override
  List<Object?> get props => [prediction, isFromRegisterAndSell];
}

class TriggerCreateOwnerProfile extends CreateEditProfileEvent {
  final bool isCreateProfile;

  const TriggerCreateOwnerProfile({this.isCreateProfile = true});

  @override
  List<Object?> get props => [isCreateProfile];
}

class TriggerCreateAthleteProfile extends CreateEditProfileEvent {}

class TriggerOpenExploreBottomSheet extends CreateEditProfileEvent {}

class TriggerCheckUnCheckParentalInformation extends CreateEditProfileEvent {}

class TriggerCheckActivityOfVerifyButton extends CreateEditProfileEvent {}

class TriggerVerifyEmailChange extends CreateEditProfileEvent {}

class TriggerChangePassword extends CreateEditProfileEvent {}

class TriggerHideUnHideFieldContents extends CreateEditProfileEvent {
  final FieldType fieldType;

  const TriggerHideUnHideFieldContents({required this.fieldType});

  @override
  List<Object> get props => [fieldType];
}

class TriggerDropDownSelectionInCreateProfile extends CreateEditProfileEvent {
  final String? selectedValue;
  final Athlete? athlete;
  final List<Team> teams;

  const TriggerDropDownSelectionInCreateProfile(
      {required this.selectedValue,
      required this.athlete,
      required this.teams});

  @override
  List<Object?> get props => [selectedValue, athlete, teams];
}

class TriggerGradeSelectionInCreateProfile extends CreateEditProfileEvent {
  final String? selectedValue;
  final Athlete? athlete;
  final List<GradeData> grades;

  const TriggerGradeSelectionInCreateProfile(
      {required this.selectedValue,
      required this.athlete,
      required this.grades});

  @override
  List<Object?> get props => [selectedValue, athlete, grades];
}

class TriggerAthleteAccountDeletion extends CreateEditProfileEvent {
  final String athleteId;

  const TriggerAthleteAccountDeletion({required this.athleteId});

  @override
  List<Object?> get props => [athleteId];
}

class TriggerTeamNameRequest extends CreateEditProfileEvent {
  final String teamName;

  const TriggerTeamNameRequest({required this.teamName});

  @override
  List<Object?> get props => [teamName];
}

class TriggerSwitchToRedshirt extends CreateEditProfileEvent {}

class TriggerCheckForErrorToast extends CreateEditProfileEvent {}

class TriggerRevealPasswordChecker extends CreateEditProfileEvent {}

class TriggerUpdateFieldOnChange extends CreateEditProfileEvent {
  final FieldType fieldType;
  final String value;
  final String retypedValue;

  const TriggerUpdateFieldOnChange(
      {required this.fieldType,
      required this.value,
      this.retypedValue = AppStrings.global_empty_string});

  @override
  List<Object> get props => [fieldType, value, retypedValue];
}

class TriggerCheckForUserUpdateButton extends CreateEditProfileEvent {
  final bool isOwner;
  bool? dob;

  TriggerCheckForUserUpdateButton({required this.isOwner, this.dob});

  @override
  List<Object> get props => [
        isOwner,
      ];
}

class TriggerValidateCalenderDate extends CreateEditProfileEvent {
  final AgeType ageType;

  const TriggerValidateCalenderDate({required this.ageType});

  @override
  List<Object> get props => [ageType];
}

class TriggerCheckChangePasswordActiveState extends CreateEditProfileEvent {}

class TriggerNavigateToAthlete extends CreateEditProfileEvent {}
class TriggerDeleteLocalAthlete extends CreateEditProfileEvent{
  final String athleteId;
  const TriggerDeleteLocalAthlete({required this.athleteId});
  @override
  List<Object?> get props => [athleteId];

}
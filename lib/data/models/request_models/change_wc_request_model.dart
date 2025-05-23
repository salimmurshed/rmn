class ChangeWCRequestModel {
  final String eventId;
  final String athleteId;
  final String divisionId;
  final List<String> weightClasses;

  ChangeWCRequestModel(
      {required this.athleteId,
      required this.eventId,
      required this.divisionId,
      required this.weightClasses});
}

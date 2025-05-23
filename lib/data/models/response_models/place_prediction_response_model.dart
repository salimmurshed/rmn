class PlacePredictionResponseModel {
  String? description;
  String? placeId;

  PlacePredictionResponseModel({this.description, this.placeId});

  factory PlacePredictionResponseModel.fromJson(Map<String, dynamic> json) {
    return PlacePredictionResponseModel(
      description: json['description'],
      placeId: json['place_id'],
    );
  }
}

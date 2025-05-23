import 'athlete_response_model.dart';

class AthleteDetailsResponseModel {
  AthleteDetailsResponseModel({
    this.status,
    this.responseData,
  });

  AthleteDetailsResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null
        ? AthleteDetailResponseData.fromJson(json['responseData'])
        : null;
  }

  bool? status;
  AthleteDetailResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }
}

class AthleteDetailResponseData {
  AthleteDetailResponseData({
    this.message,
    this.assetsUrl,
    this.athlete,
  });

  AthleteDetailResponseData.fromJson(dynamic json) {
    message = json['message'];
    assetsUrl = json['assets_url'];
    athlete =
        json['athlete'] != null ? Athlete.fromJson(json['athlete']) : null;
  }

  String? message;
  String? assetsUrl;
  Athlete? athlete;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['assets_url'] = assetsUrl;
    if (athlete != null) {
      map['athlete'] = athlete?.toJson();
    }
    return map;
  }
}


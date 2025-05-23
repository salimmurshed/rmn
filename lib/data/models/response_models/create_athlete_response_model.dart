import 'athlete_response_model.dart';

class CreateAthleteResponseModel {
  CreateAthleteResponseModel({
    this.status,
    this.responseData,
  });

  CreateAthleteResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null
        ? CreateAthleteResponseData.fromJson(json['responseData'])
        : null;
  }

  bool? status;
  CreateAthleteResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }
}

class CreateAthleteResponseData {
  CreateAthleteResponseData({
    this.message,
    this.data,
  });

  CreateAthleteResponseData.fromJson(dynamic json) {
    message = json['message'];
    data = json['data'] != null ? Athlete.fromJson(json['data']) : null;
  }

  String? message;
  Athlete? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}



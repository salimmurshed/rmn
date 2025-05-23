import '../../../imports/data.dart';

class AthleteWithoutSeasonPassResponseModel {
  AthleteWithoutSeasonPassResponseModel({
    this.status,
    this.responseData,
  });

  AthleteWithoutSeasonPassResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null
        ? AthleteWithoutSeasonPassData.fromJson(json['responseData'])
        : null;
  }

  bool? status;
  AthleteWithoutSeasonPassData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }
}

class AthleteWithoutSeasonPassData {
  AthleteWithoutSeasonPassData({
    this.message,
    this.assetsUrl,
    this.data,
  });

  AthleteWithoutSeasonPassData.fromJson(dynamic json) {
    message = json['message'];
    assetsUrl = json['assets_url'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Athlete.fromJson(v));
      });
    }
  }

  String? message;
  String? assetsUrl;
  List<Athlete>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['assets_url'] = assetsUrl;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

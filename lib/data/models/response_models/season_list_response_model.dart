import 'package:rmnevents/data/models/response_models/season_passes_response_model.dart';

class SeasonListResponseModel {
  SeasonListResponseModel({
    this.status,
    this.responseData,
  });

  SeasonListResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null
        ? SeasonListResponseData.fromJson(json['responseData'])
        : null;
  }

  bool? status;
  SeasonListResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }
}

class SeasonListResponseData {
  SeasonListResponseData({
    this.data,
  });

  SeasonListResponseData.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(SeasonPass.fromJson(v));
      });
    }
  }

  List<SeasonPass>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}



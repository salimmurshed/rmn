import '../../../imports/data.dart';

class TeamsResponseModel {
  TeamsResponseModel({
      this.status, 
      this.responseData,});

  TeamsResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null ? TeamsResponseData.fromJson(json['responseData']) : null;
  }
  bool? status;
  TeamsResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }

}

class TeamsResponseData {
  TeamsResponseData({
      this.data, 
      this.message,});

  TeamsResponseData.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Team.fromJson(v));
      });
    }
    message = json['message'];
  }
  List<Team>? data;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['message'] = message;
    return map;
  }

}

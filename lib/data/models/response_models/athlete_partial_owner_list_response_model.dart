
import '../../../imports/data.dart';

class AthletePartialOwnerListResponseModel {
  AthletePartialOwnerListResponseModel({
      this.status, 
      this.responseData,});

  AthletePartialOwnerListResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null ? AthletePartialOwnerResponseData.fromJson(json['responseData']) : null;
  }
  bool? status;
  AthletePartialOwnerResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }

}

class AthletePartialOwnerResponseData {
  AthletePartialOwnerResponseData({
      this.users, 
      this.message, 
      this.assetsUrl,});

  AthletePartialOwnerResponseData.fromJson(dynamic json) {
    if (json['users'] != null) {
      users = [];
      json['users'].forEach((v) {
        users?.add(DataBaseUser.fromJson(v));
      });
    }
    message = json['message'];
    assetsUrl = json['assets_url'];
  }
  List<DataBaseUser>? users;
  String? message;
  String? assetsUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (users != null) {
      map['users'] = users?.map((v) => v.toJson()).toList();
    }
    map['message'] = message;
    map['assets_url'] = assetsUrl;
    return map;
  }

}


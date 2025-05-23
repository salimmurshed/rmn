class SendRequestResponseModel {
  SendRequestResponseModel({
      this.status, 
      this.responseData,});

  SendRequestResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null ? SendRequestResponseData.fromJson(json['responseData']) : null;
  }
  bool? status;
  SendRequestResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }

}

class SendRequestResponseData {
  SendRequestResponseData({
      this.message, 
      this.data,});

  SendRequestResponseData.fromJson(dynamic json) {
    message = json['message'];
    data = json['data'] != null ? SentRequestData.fromJson(json['data']) : null;
  }
  String? message;
  SentRequestData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class SentRequestData {
  SentRequestData({
      this.accessType, 
      this.isSupportRequested, 
      this.isAccess, 
      this.isAccept, 
      this.id, 
      this.userId, 
      this.athleteId, 
      this.createdAt, 
      this.updatedAt,});

  SentRequestData.fromJson(dynamic json) {
    accessType = json['access_type'];
    isSupportRequested = json['is_support_requested'];
    isAccess = json['is_access'];
    isAccept = json['is_accept'];
    id = json['_id'];
    userId = json['user_id'];
    athleteId = json['athlete_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  num? accessType;
  num? isSupportRequested;
  bool? isAccess;
  dynamic isAccept;
  String? id;
  String? userId;
  String? athleteId;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['access_type'] = accessType;
    map['is_support_requested'] = isSupportRequested;
    map['is_access'] = isAccess;
    map['is_accept'] = isAccept;
    map['_id'] = id;
    map['user_id'] = userId;
    map['athlete_id'] = athleteId;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}
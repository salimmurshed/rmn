class CommonResponseModel {
  CommonResponseModel({
      this.status, 
      this.responseData,});

  CommonResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null ? CommonResponseData.fromJson(json['responseData']) : null;
  }
  bool? status;
  CommonResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }

}

class CommonResponseData {
  CommonResponseData({
      this.message, this.errorCode, this.error,this.unreadCount, this.data
  });

  CommonResponseData.fromJson(dynamic json) {
    message = json['message'];
    errorCode = json['error_code'];
    error = json['error'];
    unreadCount = json['unread_count'];
    data = json['data'] != null ? CommonData.fromJson(json['data']) : null;
  }
  String? message;
  String? errorCode;
  String? error;
  num? unreadCount;
  CommonData? data;
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['error_code'] = errorCode;
    map['error'] = error;
    map['unread_count'] = unreadCount;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class CommonData {
  CommonData({
     this.unreadCount, this.archiveCount
  });

  CommonData.fromJson(dynamic json) {
    archiveCount = json['archive_count'];
    unreadCount = json['unread_count'];
  }
  num? unreadCount;
  num? archiveCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['archive_count'] = archiveCount;
    map['unread_count'] = unreadCount;
    return map;
  }
}
class BoolObject{
  bool? value;
  BoolObject({this.value});
  BoolObject.fromJson(dynamic json){
    value = json['is_online'];
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['is_online'] = value;
    return map;
  }
}

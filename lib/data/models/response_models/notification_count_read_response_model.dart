class NotificationCountReadResponseModel {
  NotificationCountReadResponseModel({
      this.status, 
      this.responseData,});

  NotificationCountReadResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null ? CountResponseData.fromJson(json['responseData']) : null;
  }
  bool? status;
  CountResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }

}

class CountResponseData {
  CountResponseData({
      this.count,});

  CountResponseData.fromJson(dynamic json) {
    count = json['count'];
  }
  num? count;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = count;
    return map;
  }

}
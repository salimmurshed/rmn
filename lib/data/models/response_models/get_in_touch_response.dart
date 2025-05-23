class GetInTouchResponseModel {
  GetInTouchResponseModel({
      this.status, 
      this.responseData,});

  GetInTouchResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null ? GetInTouchResponseData.fromJson(json['responseData']) : null;
  }
  bool? status;
  GetInTouchResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }

}

class GetInTouchResponseData {
  GetInTouchResponseData({
      this.message, 
      this.data,});

  GetInTouchResponseData.fromJson(dynamic json) {
    message = json['message'];
    data = json['data'] != null ? GetInTouchData.fromJson(json['data']) : null;
  }
  String? message;
  GetInTouchData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class GetInTouchData {
  GetInTouchData({
      this.isResolved, 
      this.id, 
      this.firstName, 
      this.lastName, 
      this.phoneCode, 
      this.phoneNumber, 
      this.email, 
      this.message, 
      this.userId, 
      this.createdAt, 
      this.updatedAt,});

  GetInTouchData.fromJson(dynamic json) {
    isResolved = json['is_resolved'];
    id = json['_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phoneCode = json['phone_code'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    message = json['message'];
    userId = json['user_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  bool? isResolved;
  String? id;
  String? firstName;
  String? lastName;
  num? phoneCode;
  num? phoneNumber;
  String? email;
  String? message;
  String? userId;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['is_resolved'] = isResolved;
    map['_id'] = id;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['phone_code'] = phoneCode;
    map['phone_number'] = phoneNumber;
    map['email'] = email;
    map['message'] = message;
    map['user_id'] = userId;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}
class AuthenticationSignUpResponseModel {
  AuthenticationSignUpResponseModel({
      this.status, 
      this.responseData,});

  AuthenticationSignUpResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null ? AuthenticationSignUpResponseData.fromJson(json['responseData']) : null;
  }
  bool? status;
  AuthenticationSignUpResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }

}

class AuthenticationSignUpResponseData {
  AuthenticationSignUpResponseData({
      this.message, 
      this.userId,});

  AuthenticationSignUpResponseData.fromJson(dynamic json) {
    message = json['message'];
    userId = json['user_id'];
  }
  String? message;
  String? userId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['user_id'] = userId;
    return map;
  }

}
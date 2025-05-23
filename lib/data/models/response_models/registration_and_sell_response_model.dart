class RegistrationAndSellResponseModel {
  RegistrationAndSellResponseModel({
      this.status, 
      this.responseData,});

  RegistrationAndSellResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null ? ResponseData.fromJson(json['responseData']) : null;
  }
  bool? status;
  ResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }

}

class ResponseData {
  ResponseData({
      this.message, 
      this.data,});

  ResponseData.fromJson(dynamic json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? message;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class Data {
  Data({
      this.paymentRequired,
      this.paymentIntent,
      this.paymentId,});

  Data.fromJson(dynamic json) {
    paymentRequired = json['payment_required'];
    paymentId = json['payment_id'];
    paymentIntent = json['payment_intent'];
  }
  bool? paymentRequired;
  String? paymentId;
  String? paymentIntent;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['payment_id'] = paymentId;
    map['payment_intent'] = paymentIntent;
    map['payment_required'] = paymentRequired;
    return map;
  }

}